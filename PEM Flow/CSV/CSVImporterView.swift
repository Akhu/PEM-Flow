//
//  CSVImporterView.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 03/01/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct CSVImporterView: View {
    @StateObject var csvFileManager = CSVFileManager()
    
    @State var shouldImportFile = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Fichier .CSV")  , footer: Text("Toucher pour choisir un fichier")) {
                    Button {
                        shouldImportFile.toggle()
                    } label: {
                        Label("\(csvFileManager.fileName)", systemImage: "doc")
                    }
                }
                if !csvFileManager.fileSelected {
                    Section("Aide") {
                        Text("L'app peut importer votre historique de mesure du pacing si vous l'avez en format numérique (depuis un tableur par exemple) il suffit de récupérer le modèle et de mettre les données dans le bon format.")
                        Link("🔗 Instructions par étapes", destination: URL(string: "https://google.com")!)
                    }
                }
                if csvFileManager.fileSelected {
                    Section("Données") {
                        Group {
                            Text("Entrées trouvées \(csvFileManager.totalNumberOfRows)")
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("\(csvFileManager.dataFromCsvFile.count)")
                                Text("Correctes")
                                
                            }
                            .foregroundColor(.green)
                            
                            HStack {
                                Image(systemName: "checkmark.circle.badge.xmark")
                                Text("\(csvFileManager.totalNumberOfDroppedRows)")
                                Text("Invalides")
                            }.foregroundColor(.yellow)
                        }.fontWeight(.bold)
                    }
                    
                    Section(footer: Label("Attention, l'importation remplacera les données déjà présentes en fonction de la date si elles existent déjà", systemImage: "exclamationmark.triangle.fill")) {
                        Button {
                            
                        } label: {
                            Label("Importer \(csvFileManager.dataFromCsvFile.count) entrées", systemImage: "square.and.arrow.down.fill")
                                .labelStyle(TitleAndIconLabelStyle())
                                .font(.headline)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                        
                    }
                    
                    
                }
            }
            .fileImporter(
                isPresented: $shouldImportFile,
                allowedContentTypes: [UTType.plainText, UTType.commaSeparatedText],
                allowsMultipleSelection: false
            ) { csvFileManager.importFile(result: $0) }
            .navigationTitle("🗄️ Importation CSV")
        }
    }
}

struct CSVImporterView_Previews: PreviewProvider {
    static var previews: some View {
        CSVImporterView()
    }
}
