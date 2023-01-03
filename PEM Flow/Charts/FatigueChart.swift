//
//  FatigueChart.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 25/09/2022.
//

import SwiftUI
import Charts

struct FatigueChart: View {
    var items: FetchedResults<Entry>
    
    @State var displayAverageSymptoms = false
    @State var displayAverageActivity = false
    @State var displaySleep = false
    @State var highlightedSymptoms = true
    @Binding var displayCrash: Bool
    
    var averageFatigue: Double {
        var total:Double = 0.0
        items.forEach { entry in
            total += Double(entry.fatigue)
        }
        return Double(total / Double(items.count))
    }
    
    var body: some View {
        VStack {
            Chart {
                ForEach(items) { entry in
                    BarMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.fatigue),
                        width: 12
                    )
                    .foregroundStyle(displayAverageSymptoms || displayAverageActivity ? .gray.opacity(0.5) : .pink)
                    if displayAverageSymptoms {
                        LineMark(
                            x: .value("Date", entry.createdAt),
                            y: .value("Average Symptoms", entry.averageSymptomsWithoutFatigue)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 3))
//                        .annotation(position: .top) {
//                            Text("Fatigue moyenne : \(averageFatigue, specifier: "%.1f") / 10")
//                        }
                        .foregroundStyle(.yellow)
                        PointMark(
                            x: .value("Date", entry.createdAt),
                            y: .value("Average Symptoms", entry.averageSymptomsWithoutFatigue)
                        ).foregroundStyle(.yellow)
                    }
                    if displayAverageActivity {
                        LineMark(
                            x: .value("Date", entry.createdAt),
                            y: .value("Average Activity", entry.averageActivity)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 3))
//                        .annotation(position: .top) {
//                            Text("Fatigue moyenne : \(averageFatigue, specifier: "%.1f") / 10")
//                        }
                        .foregroundStyle(by: .value("Average Activity", "Average Activity"))
                        PointMark(
                            x: .value("Date", entry.createdAt),
                            y: .value("Average Activity", entry.averageActivity)
                        ).foregroundStyle(.green)
                    }
                    
                    //.foregroundStyle(by: .value("Fatigue level", "Fatigue"))

                    if entry.crash && displayCrash {
                        PointMark(
                            x: .value("Date", entry.createdAt), y: .value("Crash", entry.fatigue)
                        )
                        .annotation(content: {
                            Text("💥")
                                .font(.system(size: 12))
                        })
                        .opacity(0)
                        .foregroundStyle(by: .value("Crash 💥", "Crash 💥"))
                    }
                }.interpolationMethod(InterpolationMethod.catmullRom(alpha: 0.2))
            }
            
            .chartYScale(domain: 0...10)
            .chartForegroundStyleScale([
                "Fatigue": .pink, "Crash 💥": .red, "Average Symptoms": .yellow, "Average Activity": .green
        ])
            
            VStack {
                Button {
                    displayAverageActivity.toggle()
                } label: {
                    HStack {
                        Image(systemName: "figure.walk.circle.fill")
                        Spacer()
                        Text("Activité")
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                }.buttonStyle( BorderedProminentButtonStyle())
                    .tint(displayAverageActivity ? .green : .gray)
                .frame(maxWidth: .infinity)
                
                Button {
                    displayAverageSymptoms.toggle()
                } label: {
                    HStack {
                        Image(systemName: "cross.case.fill")
                        Spacer()
                        Text("Symptômes")
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                }.buttonStyle( BorderedProminentButtonStyle())
                    .tint(displayAverageSymptoms ? .yellow : .gray)
                .frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity)
        }
    }
}

//https://medium.com/swiftcommmunity/canvas-previews-for-swiftui-with-coredata-5c47ef7f012d
