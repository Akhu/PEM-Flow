//
//  SymptomsComparisonChart.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 25/09/2022.
//

import SwiftUI
import Charts

//LinearGradient(colors: [.purple, .red], startPoint: .bottom, endPoint: .top)
//LinearGradient(colors: [.purple, .red], startPoint: .bottom, endPoint: .top)
struct SymptomsComparisonChart: View {
//    var items: FetchedResults<Entry>
    var items: [Entry]
    @State var displayCrash: Bool
    
    var seriesData: [(painType: String, data: [(day: Date, level: Int16)])]
    
    init(items: [Entry], displayCrash: Bool)
    {
        self.items = items
        self.displayCrash = displayCrash
        seriesData = [
            (painType: "Neuro", data: items.map { ($0.createdAt, $0.neurologicalPain) } ),
            (painType: "Digestive", data: items.map { ($0.createdAt, $0.gutPain) } ),
            (painType: "Fatigue", data: items.map { ($0.createdAt, $0.fatigue) } )
        ]
    }
    var body: some View {
        Chart {
            ForEach(seriesData, id: \.painType) { entry in
                ForEach(entry.data, id: \.day) {
                    LineMark(
                        x: .value("Date", $0.day, unit: .day),
                        y: .value("Level", $0.level)
                    )
                }
                .symbol(by: .value("Type", entry.painType))
                .interpolationMethod(InterpolationMethod.catmullRom(alpha: 0.2))
                .foregroundStyle(by: .value("Type", entry.painType))
                .position(by: .value("Type", entry.painType))
                //.foregroundStyle(by: .value("Fatigue level", "Fatigue"))
            }
        }.chartYScale(domain: 0...10)
        
    }
}
