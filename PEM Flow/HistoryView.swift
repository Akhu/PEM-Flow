//
//  HistoryView.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 14/09/2022.
//

import SwiftUI

struct HistoryView: View {

    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        List {
            Text("Items Count \(viewModel.entries.count)")
            ForEach(viewModel.entries) { item in
                VStack {
                    Text(item.unwrappedId.uuidString)
                    Text(item.createdAt.ISO8601Format())
                }
            }
            .onDelete(perform: removeRows)
        }.toolbar {
            EditButton()
        }
        .toolbar {
            ToolbarItem(id: "removeAll") {
                Button("Remove All") {
                    viewModel.deleteAllEntries()
                }
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        let iterator = offsets.makeIterator()
        for i in iterator {
            let itemToRemove = viewModel.entries[i]
            viewModel.deleteEntry(itemToRemove)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) var moc
    static var previews: some View {
        HistoryView()
            .environment(\.managedObjectContext, CoreDataManager.preview.managedObjectContext)
    }
}
