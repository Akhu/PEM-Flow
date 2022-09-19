//
//  Home.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 26/08/2022.
//

import SwiftUI
import Charts
struct Home: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: true)],
        animation: .easeInOut(duration: 0.4)) var items: FetchedResults<Entry>

    @State private var isAddItemOpen = false
    
    private var mocDidSaved = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    @State private var dataRefreshing = false
    var body: some View {
        NavigationStack {
            List() {
                Section("Today") {
                    Button {
                        isAddItemOpen.toggle()
                    } label: {
                        Label("How was your day?", systemImage: "list.bullet.clipboard.fill")
                    }
                }
                Section("Fatigue") {
                    Chart {
                        ForEach(items) { entry in
                            BarMark(
                                x: .value("Date", entry.createdAt),
                                y: .value("Level", entry.fatigue)
                            )
                            .foregroundStyle(by: .value("Fatigue level", "Fatigue"))
                            if entry.crash {
                                PointMark(
                                    x: .value("Date", entry.createdAt), y: .value("Crash", entry.fatigue)
                                )
                                .annotation(content: {
                                    Text("☠️")
                                        .font(.system(size: 8))
                                })
                                .opacity(0)
                                .foregroundStyle(by: .value("Crash ☠️", "Crash ☠️"))
                            }
                        }
                    }
                    .chartForegroundStyleScale([
                        "Fatigue": .purple, "Crash ☠️": .red
                    ])
                    .frame(height: 100)
                    .padding(.horizontal)
                    .padding(.top, 24)
                }
                Section("Symptômes et Activités") {
                    AverageChart(seriesArray: items, refreshed: dataRefreshing)
                    .frame(height: 300)
                    .padding(.horizontal)
                }
                
//                Section("Activities") {
//                    ActivityChart(seriesArray: items, refreshed: dataRefreshing)
//                        .frame(height: 300)
//                        .padding(.horizontal)
//                }
                NavigationLink(destination: {
                    HistoryView(items: items)
                }, label: {
                    Label("History", systemImage: "clock.arrow.circlepath")
                })

            }
            .onChange(of: mocDidSaved, perform: { newValue in
                dataRefreshing.toggle()
            })
            .sheet(isPresented: $isAddItemOpen, content: {
                AddEntry()
            })
            .toolbar(id: UUID().uuidString) {
                
                ToolbarItem(id: "addEntry") {
                    Button("Add entry for today") {
                        isAddItemOpen.toggle()
                    }
                }
                ToolbarItem(id: "removeAll") {
                    Button("Remove All") {
                        items.forEach { entry in
                            viewContext.delete(entry)
                        }
                        try? viewContext.save()
                    }
                }
                ToolbarItem(id:"history") {
                    NavigationLink(destination: {
                        HistoryView(items: items)
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

            .navigationTitle("PEM Flow")
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

struct AverageChart: View {
    var seriesArray: FetchedResults<Entry>
    @State var refreshed: Bool
    @State var highlightedActivity = true
    @State var highlightedSymptoms = true
    @State var displayCrash = false
    var body: some View {
        VStack {
            Chart {
                ForEach(seriesArray) { entry in
                    LineMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.averageActivity)
                    )
                    .foregroundStyle(by: .value("Symptômes", "Symptômes"))
                    LineMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.averageSymptoms)
                    )
                    .foregroundStyle(by: .value("Activités", "Activités"))
                   
                    if entry.crash {
                        PointMark(
                            x: .value("Date", entry.createdAt), y: .value("Crash", 5)
                        )
                        .annotation(position: .overlay , content: {
                            Text(displayCrash ? "☠️" : "")
                                .font(.system(size: 12))
                        })
                        .opacity(0)
                        .foregroundStyle(by: .value("Crash ☠️", "Crash ☠️"))
                    }
                    PointMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.averageActivity)
                    )
                    .foregroundStyle(by: .value("Symptômes", "Symptômes"))
                    PointMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.averageSymptoms)
                    )
                    .foregroundStyle(by: .value("Activités", "Activités"))
                }
            }
            .animation(.easeOut(duration: 0.3), value: refreshed)
            .chartForegroundStyleScale([
                "Activités": .green.opacity(highlightedActivity ? 1 : 0.3), "Symptômes": .pink.opacity(highlightedSymptoms ? 1 : 0.3), "Crash ☠️" : .yellow
            ])
        .chartYAxisLabel("Activités & Symptômes")
            
            VStack {
                
                Button("Afficher les crash ☠️") {
                    displayCrash.toggle()
                }
                .buttonStyle( BorderedProminentButtonStyle())
                .tint(displayCrash ? .yellow : .secondary)
                .frame(maxWidth: .infinity)
                
                    Button("Activités") {
                        highlightedActivity.toggle()
                    }
                    .buttonStyle( BorderedProminentButtonStyle())
                    .tint(highlightedActivity ? .green : .secondary)
                    .frame(maxWidth: .infinity)
                
                    Button("Symptômes") {
                        highlightedSymptoms.toggle()
                    }
                    .buttonStyle( BorderedProminentButtonStyle())
                    .tint(highlightedSymptoms ? .pink : .secondary)
            }.frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity)
        
        
    }
}


struct ActivityChart: View {
    var seriesArray: FetchedResults<Entry>
    @State var refreshed: Bool
    var body: some View {
        Chart {
            ForEach(seriesArray) { entry in
                LineMark(
                    x: .value("Date", entry.createdAt),
                    y: .value("Level", entry.socialActivity)
                )
                .foregroundStyle(by: .value("Social Activity", "Social"))
                LineMark(
                    x: .value("Date", entry.createdAt),
                    y: .value("Level", entry.mentalActivity)
                )
                .foregroundStyle(by: .value("Mental Activity", "Mental"))
                LineMark(
                    x: .value("Date", entry.createdAt),
                    y: .value("Level", entry.physicalActivity)
                )
                .foregroundStyle(by: .value("Physical Activity", "Physical"))
                LineMark(
                    x: .value("Date", entry.createdAt),
                    y: .value("Level", entry.emotionalActivity)
                )
                .foregroundStyle(by: .value("Emotional Activity", "Emotional"))
                
                PointMark(
                    x: .value("Date", entry.createdAt),
                    y: .value("Level", entry.socialActivity)
                )
                .foregroundStyle(by: .value("Social Activity", "Social"))
                PointMark(
                    x: .value("Date", entry.createdAt),
                    y: .value("Level", entry.mentalActivity)
                )
                .foregroundStyle(by: .value("Mental Activity", "Mental"))
                
                PointMark(
                    x: .value("Date", entry.createdAt),
                    y: .value("Level", entry.physicalActivity)
                )
                .foregroundStyle(by: .value("Physical Activity", "Physical"))
                PointMark(
                    x: .value("Date", entry.createdAt),
                    y: .value("Level", entry.emotionalActivity)
                )
                .foregroundStyle(by: .value("Emotional Activity", "Emotional"))
            }
        }
        .animation(.easeOut(duration: 0.3), value: refreshed)
        .chartForegroundStyleScale([
            "Physical": .green, "Emotional": .purple, "Mental": .pink, "Social": .yellow
        ])
        .chartYAxisLabel("Symptoms strength")
        
        
    }
}


struct SymptomsChart: View {
    var seriesArray: FetchedResults<Entry>
    var body: some View {
//        ScrollView(.horizontal){
            Chart {
                ForEach(seriesArray) { entry in
                    LineMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.fatigue)
                    )
                    .foregroundStyle(by: .value("Fatigue level", "Fatigue"))
                    PointMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.fatigue)
                    )
                    .foregroundStyle(by: .value("Fatigue level", "Fatigue"))
                    LineMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.gutPain)
                    )
                    .foregroundStyle(by: .value("Gut Symptoms level", "Gut"))
                    PointMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.gutPain)
                    )
                    .foregroundStyle(by: .value("Gut Symptoms level", "Gut"))
                    
                    LineMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.neurologicalPain)
                    )
                    .foregroundStyle(by: .value("Gut Symptoms level", "Neurological"))
                    PointMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.neurologicalPain)
                    )
                    .foregroundStyle(by: .value("Gut Symptoms level", "Neurological"))
                    
                    LineMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.globalPain)
                    )
                    .foregroundStyle(by: .value("Gut Symptoms level", "Global"))
                    PointMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.globalPain)
                    )
                    .foregroundStyle(by: .value("Gut Symptoms level", "Global"))
                }
            }
            .chartForegroundStyleScale([
                "Fatigue": .green, "Gut": .purple, "Global": .pink, "Neurological": .yellow
            ])
            .chartYAxisLabel("Symptoms strength")
//        }
    }
}
