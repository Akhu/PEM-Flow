//
//  HistoryView.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 14/09/2022.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: true)],
//        animation: .default) var items: FetchedResults<Entry>
    var items: FetchedResults<Entry>
    var body: some View {
        List {
            Text("Items Count \(items.count)")
            ForEach(items) { item in
                Text(item.unwrappedId.uuidString)
            }
            .onDelete(perform: removeRows)
        }.toolbar {
            EditButton()
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        let iterator = offsets.makeIterator()
        for i in iterator {
            let itemToRemove = items[i]
            moc.delete(itemToRemove)
        }
        try? moc.save()
    }
}

//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryView(items: <#T##FetchedResults<Entry>#>)
//    }
//}
