//
//  AverageSymptomsActivityChart.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 25/09/2022.
//

import SwiftUI
import Charts
struct AverageSymptomsActivityChart: View {
    var seriesArray: FetchedResults<Entry>
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
                .interpolationMethod(InterpolationMethod.catmullRom(alpha: 0.2))
            }
            .animation(.easeOut(duration: 0.3))
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
