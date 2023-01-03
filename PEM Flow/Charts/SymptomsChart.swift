//
//  SymptomsChart.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 24/12/2022.
//

import SwiftUI
import Charts

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
