//
//  PEM_FlowApp.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 26/08/2022.
//
import SwiftUI

@main
struct PEM_FlowApp: App {
    var body: some Scene {
        WindowGroup {
            Home()
                .environment(\.managedObjectContext, CoreDataManager.shared.managedObjectContext)
                .fontDesign(.rounded)
        }
    }
}
