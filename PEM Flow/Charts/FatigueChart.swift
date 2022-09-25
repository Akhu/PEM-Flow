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
    
    @State var displayAverage = false
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
                    if displayAverage {
                        RuleMark(
                            y: .value("Average", averageFatigue)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .annotation(position: .top) {
                            Text("Fatigue moyenne : \(averageFatigue, specifier: "%.1f") / 10")
                        }
                        .foregroundStyle(by: .value("Average", "Average"))
                    }
                    BarMark(
                        x: .value("Date", entry.createdAt),
                        y: .value("Level", entry.fatigue),
                        width: 12                        
                    )
                    .foregroundStyle(displayAverage ? .gray.opacity(0.5) : .purple)
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
                }
            }
            
            .chartYScale(domain: 0...10)
            .chartForegroundStyleScale([
                "Fatigue": .purple, "Crash 💥": .red, "Average": .purple
        ])
            
            VStack {
                
                
                Button {
                    displayAverage.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus.forwardslash.minus")
                        Spacer()
                        Text("Moyenne")
                            .padding(.vertical, 4)
                    }
                }.buttonStyle( BorderedProminentButtonStyle())
                    .tint(displayAverage ? .purple : .purple.opacity(0.3))
                .frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity)
        }
    }
}

//https://medium.com/swiftcommmunity/canvas-previews-for-swiftui-with-coredata-5c47ef7f012d
