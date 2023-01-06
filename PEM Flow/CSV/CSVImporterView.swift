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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: true)], animation: .easeInOut(duration: 0.4)) var items: FetchedResults<Entry>
    
    @State var shouldImportFile = false
    
    var body: some View {
        NavigationView {
            List {
                if csvFileManager.importationError != .noError {
                    Section("Erreur") {
                        Group {
                            switch csvFileManager.importationError {
                            case .wrongHeader:
                               Label("Format non reconnu, vérifiez la ligne d'en-tête, le format et le séparateur (virgule et non point-virgule)", systemImage: "exclamationmark.octagon.fill")
                            case .noDataFound:
                                Label("Aucune données trouvées dans le fichier fourni 🤷‍♀️)", systemImage: "exclamationmark.octagon.fill")
                            default:
                                EmptyView()
                            }
                        }
                        .foregroundColor(.red)
                    }
                }
                Section(header: Text("Fichier .CSV")  , footer: Text("Toucher pour choisir un fichier")) {
                    Button {
                        shouldImportFile.toggle()
                    } label: {
                        Label("\(csvFileManager.fileName.isEmpty ? "Choisir un fichier..." : csvFileManager.fileName)", systemImage: "doc")
                    }
                }
                
                if !csvFileManager.fileSelected || (csvFileManager.fileSelected && csvFileManager.importationError != .noError) {
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
                    
                    
                }
                if csvFileManager.importationError == .noError {
                    Section(header: Text("Importer / Exporter"), footer:  Label(items.count > 0 ? "Attention, l'importation remplace les données déjà présentes, assurez vous d'exporter les données existantes pour éviter de perdre votre historique sur l'appareil" : "Importe la totalité du fichier", systemImage: "exclamationmark.triangle.fill")) {
                        Button {
                            csvFileManager.importData(moc: managedObjectContext)
                        } label: {
                            Label("Importer \(csvFileManager.dataFromCsvFile.count) entrées", systemImage: "square.and.arrow.down.fill")
                                .labelStyle(TitleAndIconLabelStyle())
                                .font(.headline)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                        if items.count > 0 {
                            Button {
                                //Create file and open FileExporter
                            } label: {
                                Label("Exporter \(items.count) entrée(s) existante(s)", systemImage: "internaldrive.fill")
                                    .labelStyle(TitleAndIconLabelStyle())
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .foregroundColor(Color.primary.opacity(0.8))
                            }
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
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
