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
    case sinceTwoWeeks, sinceAMonth
}

struct Home: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var isAddItemOpen = false
    @State var isImportingFile = false
        
    private var mocDidSaved = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    @State private var dataRefreshing = false
    @State private var displayCrash = false
    
    @State private var historySize = HistorySize.sinceTwoWeeks
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: true)], animation: .easeInOut(duration: 0.4)) var items: FetchedResults<Entry>
    
    func getHistorySizeAsStartInterval() -> Date {
        let calendar = Calendar.current
        
        switch historySize {
            case .sinceTwoWeeks:
                return calendar.date(byAdding: .day, value: -14, to: Date())!
            case .sinceAMonth:
               return calendar.date(byAdding: .month, value: -1, to: Date())!
        }
        
    }

    var body: some View {
        NavigationStack {
            List() {
               
                Section("Today") {
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
                if items.count > 0 {
                    VStack {
                        
                        Picker("Periode", selection: $historySize) {
                            Text("2 semaines").tag(HistorySize.sinceTwoWeeks)
                            Text("Mois").tag(HistorySize.sinceAMonth)
                        }.pickerStyle(SegmentedPickerStyle())
                    
                    }
                    .listRowSeparator(.hidden)
                    
                        
                    Dashboard(startInterval: getHistorySizeAsStartInterval(), displayCrash: $displayCrash)
                        .animation(.easeInOut(duration: 0.4), value: historySize)
                } else {
                    Text("Pas encore de données, remplissez un rapport journalier pour commencer et voir apparaitre des statistiques.")
                }
//                Section("Activities") {
//                    ActivityChart(seriesArray: items, refreshed: dataRefreshing)
//                        .frame(height: 300)
//                        .padding(.horizontal)
//                }
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
            .onChange(of: mocDidSaved, perform: { newValue in
                dataRefreshing.toggle()
            })
            .sheet(isPresented: $isAddItemOpen, content: {
                EditEntry(dataRefreshed: $dataRefreshing)
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
                    }, label: {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    })
                }
                ToolbarItem(id: "Add Sample") {
                    Button("Add samples") {
                        EntryManager.generateSampleItems(number: 20, context: viewContext)
                        if viewContext.hasChanges {
                            try? viewContext.save()
                        }
                    }
                }
            }
            
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
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

