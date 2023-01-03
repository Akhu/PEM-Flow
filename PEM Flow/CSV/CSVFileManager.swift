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
    
    init() {
        guard let fileURL = Bundle.main.url(forResource: "PEMFLOW_CLEAN", withExtension: "csv") else { return }
        
        print(fileURL)
        
        guard let stringData = try? String(contentsOf: fileURL) else { return }
        
        print(stringData)
        
        guard let rawData = try? Data(contentsOf: fileURL) else { return }
        
        do {
            let decoder = CSVDecoder {
                $0.headerStrategy = .firstLine
                $0.delimiters.field = ","
                $0.boolStrategy = .numeric
            }
            let result = try decoder.decode([RawTrackingData].self, from: rawData)
            self.dataFromCsvFile = result
        } catch {
            print(error)
        }
    }
}

struct RawTrackingData: Codable {
    let createdAt: String
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
