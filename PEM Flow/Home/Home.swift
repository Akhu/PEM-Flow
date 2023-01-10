//
//  Home.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 26/08/2022.
//

import SwiftUI
import Charts
import Foundation
import UniformTypeIdentifiers

enum HistorySize {
    case sinceTwoWeeks, sinceAMonth, all
}

struct Home: View {
    
    @Environment(\.dismiss) private var dismiss

    @StateObject var viewModel = HomeViewModel()
    @State private var isAddItemOpen = false
    @State var isImportingFile = false

    var body: some View {
        NavigationStack {
            List() {
                Section("Today \(viewModel.entries.count)") {
                    Button {
                        isImportingFile.toggle()
                    } label: {
                        Label("Importer les données depuis un tableur", systemImage: "")
                    }.sheet(isPresented: $isImportingFile) {
                        CSVImporterView()
                    }
                    
                    Button {
                        isAddItemOpen.toggle()
                    } label: {
                        Label("Comment était votre journée ?", systemImage: "list.bullet.clipboard.fill")
                    }
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Votre suivi")
                        .fontWeight(.black)
                    Text("En analysant les données, vous pourrez mieux adapter vos activités pour faire du pacing et éviter les crashs. Vérifiez quand ils apparaissent, quelles activités vous avez effectuées avant et quels symptomes sont révélateurs.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if viewModel.entries.count > 0 {
                    VStack {
                        Picker("Periode", selection: $viewModel.historySize) {
                            Text("2 semaines").tag(HistorySize.sinceTwoWeeks)
                            Text("Mois").tag(HistorySize.sinceAMonth)
                        }.pickerStyle(SegmentedPickerStyle())
                    
                    }
                    .listRowSeparator(.hidden)
                    Dashboard()
                        .animation(.easeInOut(duration: 0.4), value: viewModel.historySize)
                } else {
                    Text("Pas encore de données, remplissez un rapport journalier pour commencer et voir apparaitre des statistiques.")
                }
 
                Section("Conseils & Ressources") {
                    Link("Plan d'évitement MPE", destination: URL(string: "https://google.com")!)
                }
                NavigationLink(destination: {
                    HistoryView()
                }, label: {
                    Label("History", systemImage: "clock.arrow.circlepath")
                })

            }
            .listRowSeparator(.hidden)
            .listStyle(PlainListStyle())
            .onAppear {
                viewModel.fetchEntries()
            }
            .sheet(isPresented: $isAddItemOpen, content: {
                EditEntry()
            })
            .toolbar(id: UUID().uuidString) {
                
                ToolbarItem(id: "addEntry") {
                    Button("Add entry for today") {
                        isAddItemOpen.toggle()
                    }
                }
                ToolbarItem(id:"history") {
                    NavigationLink(destination: {
                        HistoryView()
                            .environmentObject(viewModel)
                    }, label: {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    })
                }
                ToolbarItem(id: "Add Sample") {
                    Button("Add samples") {
                        viewModel.addSampleEntries()
                    }
                }
            }
            .environmentObject(viewModel)
            
            .navigationTitle("Pacing.Quest 🧙‍♂️")
        }
        
    }
    
    private let todayDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environment(\.managedObjectContext, CoreDataManager.preview.managedObjectContext)
    }
}

