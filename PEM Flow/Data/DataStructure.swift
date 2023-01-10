//
//  DataStructure.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 26/08/2022.
//

import Foundation

struct ToyShape: Identifiable {
    var color: String
    var type: String
    var count: Double
    var id = UUID()
}

struct Series: Identifiable {
    let createdAt: Date
    
    let gutPain: Int16
    let physicalActivity: Int16
    let socialActivity: Int16
    let mentalActivity: Int16
    let emotionalActivity: Int16
    
    let fatigue: Int16
    let goodSleep: Bool
    let globalPain: Int16
    let neurologicalPain: Int16
    
    let crash: Bool
    
    let notes: String?
    var id: Date { createdAt }
}

var stackedBarData: [ToyShape] = [
    .init(color: "Green", type: "Cube", count: 2),
    .init(color: "Green", type: "Sphere", count: 0),
    .init(color: "Green", type: "Pyramid", count: 1),
    .init(color: "Purple", type: "Cube", count: 1),
    .init(color: "Purple", type: "Sphere", count: 1),
    .init(color: "Purple", type: "Pyramid", count: 1),
    .init(color: "Pink", type: "Cube", count: 1),
    .init(color: "Pink", type: "Sphere", count: 2),
    .init(color: "Pink", type: "Pyramid", count: 0),
    .init(color: "Yellow", type: "Cube", count: 1),
    .init(color: "Yellow", type: "Sphere", count: 1),
    .init(color: "Yellow", type: "Pyramid", count: 2)
]
