//
//  CSVImporterView.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 03/01/2023.
//

import SwiftUI

struct CSVImporterView: View {
    @StateObject var csvFileManager = CSVFileManager()
    var body: some View {
        VStack {
            Text("Vous allez importer un fichier dans vos données de suivi")
            Text("Nombre d'entrée trouvé dans le fichier : \(csvFileManager.dataFromCsvFile.count)")
            if csvFileManager.dataFromCsvFile.count > 2 {
                Text("\(csvFileManager.dataFromCsvFile[0].notes!)")
                Text("\(csvFileManager.dataFromCsvFile[1].notes!)")
            }
        }
    }
}

struct CSVImporterView_Previews: PreviewProvider {
    static var previews: some View {
        CSVImporterView()
    }
}
