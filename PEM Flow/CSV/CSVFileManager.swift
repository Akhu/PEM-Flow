//
//  CSVFileManager.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 03/01/2023.
//

import Foundation
import CodableCSV
import CoreData

class CSVFileManager: ObservableObject {
    @Published var dataFromCsvFile = [RawTrackingData]()
    @Published var totalNumberOfRows = 0
    @Published var totalNumberOfDroppedRows = 0
    @Published var fileSelected = false
    
    @Published var importationError: FileImportError = .noError
    
    @Published var fileName = ""
    
    func importData(moc: NSManagedObjectContext) {
        EntryManager.importDataFromCSV(input: dataFromCsvFile)
    }
    
    func importFile(result: Result<[URL], Error>) {
        do {
            guard let selectedFile: URL = try result.get().first else { return }
            guard selectedFile.startAccessingSecurityScopedResource() else { return }
            fileName = selectedFile.lastPathComponent
            
//            guard let stringData = try? String(contentsOf: selectedFile) else { return }
//
//            print(stringData)
            
            guard let rawData = try? Data(contentsOf: selectedFile) else { return }
            selectedFile.stopAccessingSecurityScopedResource()
            self.totalNumberOfRows = 0
            self.totalNumberOfDroppedRows = 0
            self.dataFromCsvFile = [RawTrackingData]()
            fileSelected = true
            importationError = .noError
            self.decodeCSV(rawData: rawData)
        } catch {
            print(error)
        }
    }
    
    func decodeCSV(rawData: Data) {
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let decoder = try CSVDecoder {
                $0.headerStrategy = .firstLine
                $0.delimiters.field = ","
                $0.boolStrategy = .numeric
                $0.bufferingStrategy = .sequential
                $0.dateStrategy = .formatted(dateFormatter)
            }.lazy(from: rawData)
            
            while let row = decoder.next() {
                do {
                    self.totalNumberOfRows += 1
                    
                    let rowData = try row.decode(RawTrackingData.self)
                    let _ = try rowData.validateTrackingData()
                    self.dataFromCsvFile.append(rowData)
                    
                } catch let decodingError as DecodingError {
                    print("Decoding error \(decodingError)")
                    self.totalNumberOfDroppedRows += 1
                } catch let validationError as ValidationError {
                    print("Validation Error \(validationError)")
                    self.totalNumberOfDroppedRows += 1
                }  catch let libraryError as CSVError<CodableCSV.CSVDecoder> {
                    print("Library Error")
                    print(libraryError.localizedDescription)
                    if libraryError.errorCode == CSVDecoder.Error.invalidConfiguration.rawValue {
                        self.importationError = .wrongHeader
                    }
                    break
                } catch {
                    print("Other error \(error.localizedDescription)")
                }
            }
            if self.totalNumberOfRows == 0 {
                self.importationError = .noDataFound
            }
        } catch {
            
        }
    }
}

struct RawTrackingData: Codable {
    let createdAt: Date
    let physicalActivity: Int16
    let socialActivity: Int16?
    let mentalActivity: Int16
    let emotionalActivity: Int16
    let fatigue: Int16
    let goodSleep: Bool
    let globalPain: Int16
    let gutPain: Int16
    let neurologicalPain: Int16
    let crash: Bool
    let notes: String?
    
    
    func validateTrackingData() throws -> Bool {
        let reflection = Mirror(reflecting: self)
        return try reflection.children.allSatisfy({ label, value in
            if let valueIsNumber = value as? Int16, (valueIsNumber > 10 || valueIsNumber < 0) {
                throw ValidationError.invalidRange
            }
            return true
        })
    }
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "date"
        case physicalActivity = "act physique"
        case socialActivity
        case mentalActivity = "act mental"
        case emotionalActivity = "act emotion"
        case fatigue
        case goodSleep = "sommeil reparateur"
        case globalPain = "douleurs"
        case gutPain = "digestif"
        case neurologicalPain = "neurologique"
        case crash
        case notes
    }
}

enum FileImportError: Error {
    case wrongFormat, wrongHeader, noDataFound, noError
}

enum ValidationError: Error {
    case invalidRange
}
