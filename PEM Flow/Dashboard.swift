//
//  Dashboard.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 25/09/2022.
//

import SwiftUI

struct Dashboard: View {
    @FetchRequest var items: FetchedResults<Entry>
    @Binding var displayCrash: Bool
    @State var dataRefreshing = false
    private var mocDidSaved = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    init(startInterval: Date, displayCrash: Binding<Bool>) {
        _displayCrash = displayCrash
        _items = FetchRequest<Entry>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: true)], predicate: NSPredicate(format:"(createdAt >= %@) AND (createdAt < %@)", startInterval as NSDate, Date() as NSDate),
            animation: .easeInOut(duration: 0.4))
    }
    
    var body: some View {
        VStack {
            EmptyView()
                .onChange(of: mocDidSaved, perform: { newValue in
                    dataRefreshing.toggle()
                })
            if items.count > 0 {
                Button {
                    displayCrash.toggle()
                } label: {
                    HStack {
                        Text("💥")
                        Spacer()
                        Text("Afficher mes crashs")
                            .padding(.vertical, 4)
                    }
                }
                .listRowSeparator(.hidden)
                .buttonStyle( BorderedProminentButtonStyle())
                .tint(displayCrash ? .red : .secondary)
                Section("Fatigue") {
                    FatigueChart(items: items, displayCrash: $displayCrash)
                        .frame(height: 300)
                }
                Section("Douleurs") {
                    SymptomsComparisonChart(items: items, displayCrash: $displayCrash)
                        .frame(height: 230)
                        .padding(.horizontal)
                        .padding(.top, 24)
                }
                if items.count > 2 {
                    Section("Symptômes et Activités") {
                        AverageSymptomsActivityChart(seriesArray: items)
                            .frame(height: 450)
                            .padding(.horizontal)
                    }
                } else {
                    Text("Ajoutez encore des données pour afficher plus de graphiques")
                }
            }
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        Dashboard(startInterval: calendar.date(byAdding: .day, value: -14, to: Date())!, displayCrash: .constant(false))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
