//
//  Home.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 26/08/2022.
//

import SwiftUI
import Charts
struct Home: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var isAddItemOpen = false
    
    var body: some View {
        NavigationStack {
            Chart {
                ForEach(stackedBarData) { shape in
                        BarMark(
                            x: .value("Shape Type", shape.type),
                            y: .value("Total Count", shape.count)
                        )
                        .foregroundStyle(by: .value("Shape Color", shape.color))
                    }
                ForEach(stackedBarData) { shape in
                        PointMark(
                            x: .value("Shape Type", shape.type),
                            y: .value("Total Count", shape.count)
                        )
                        .foregroundStyle(by: .value("Shape Color", shape.color))
                    }
            }
            .frame(height: 300)
            .padding(.horizontal)
            .toolbar {
                Button("Add entry for today") {
                    isAddItemOpen.toggle()
                }
            }
            .sheet(isPresented: $isAddItemOpen) {
                AddEntry()
            }
        
            List() {
                ForEach(items) { item in
                    Text(item.timestamp!, formatter: itemFormatter)
                }
            }
        }
        .navigationTitle("Home")
    }
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
