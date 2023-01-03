//
//  ActivityChart.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 24/12/2022.
//

import SwiftUI
import Charts

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
