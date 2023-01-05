//
//  CSVFileManager.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 03/01/2023.
//

import Foundation
import CodableCSV

class CSVFileManager: ObservableObject {
    @Published var dataFromCsvFile = [RawTrackingData]()
    @Published var totalNumberOfRows = 0
    @Published var totalNumberOfDroppedRows = 0
    @Published var fileSelected = false
    
    @Published var fileName = "Choisir un fichier"
    
    func importFile(result: Result<[URL], Error>) {
        do {
            guard let selectedFile: URL = try result.get().first else { return }
            guard selectedFile.startAccessingSecurityScopedResource() else { return }
            fileName = selectedFile.lastPathComponent
            
            //guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "csv") else { return }
            
            guard let stringData = try? String(contentsOf: selectedFile) else { return }
            
            print(stringData)
            
            guard let rawData = try? Data(contentsOf: selectedFile) else { return }
            selectedFile.stopAccessingSecurityScopedResource()
            fileSelected = true
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
            
            var droppedRows = 0
            
            self.dataFromCsvFile = decoder.compactMap { element in
                self.totalNumberOfRows += 1
                let rowData = try? element.decode(RawTrackingData.self)
                
                if rowData == nil || (rowData?.validateTrackingData() ?? false) == false {
                    self.totalNumberOfDroppedRows += 1
                    return nil
                }
                return rowData
            }
        } catch {
            print(error)
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
    
    
    func validateTrackingData() -> Bool {
        let reflection = Mirror(reflecting: self)
        return reflection.children.allSatisfy({ label, value in
            if let valueIsNumber = value as? Int16, (valueIsNumber > 10 || valueIsNumber < 0) {
                return false
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
    case wrongFormat, wrongHeader, noDataFound
}

enum ValidationError: Error {
    case invalidRange
}
