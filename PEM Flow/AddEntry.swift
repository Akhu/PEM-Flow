//
//  AddEntry.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 26/08/2022.
//

import SwiftUI

struct AddEntry: View {
    
    @StateObject private var entryManager = EntryManager()
    
    private let todayDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        Form {
            HStack {
                Image(systemName: "calendar.badge.plus")
                Text(Date(), formatter: todayDateFormat)
            }
            Section("Activities ⚡️") {
                VStack(alignment: .leading) {
                    Text("💪 Physical Activity")
                    HStack {
                        Slider(value: $entryManager.physicalActivity, in: 0...5, step: 1)
                        
                        Text(entryManager.physicalActivity.formatted(.number))
                            .font(.largeTitle)
                            .frame(width: 28)
                    }
                }
                VStack(alignment: .leading) {
                    Text("🙋‍♀️ Social Activity")
                    HStack {
                        Slider(value: $entryManager.socialActivity, in: 0...5, step: 1)
                        
                        Text(entryManager.socialActivity.formatted(.number))
                            .font(.largeTitle)
                            .frame(width: 28)
                    }
                    
                }
                VStack(alignment: .leading) {
                    Text("🧠 Mental Activity")
                    HStack {
                        Slider(value: $entryManager.mentalActivity, in: 0...5, step: 1)
                        
                        Text(entryManager.mentalActivity.formatted(.number))
                            .font(.largeTitle)
                            .frame(width: 28)
                    }
                }
                VStack(alignment: .leading) {
                    Text("❣️Emotional Activity")
                    HStack {
                        Slider(value: $entryManager.emotionalActivity, in: 0...5, step: 1)
                        
                        Text(entryManager.emotionalActivity.formatted(.number))
                            .font(.largeTitle)
                            .frame(width: 28)
                    }
                }
            }
            Section("Symptoms ❤️‍🩹") {
                VStack(alignment: .leading) {
                    Text("🛌 Good night sleep")
                    Picker("", selection: $entryManager.goodSleep, content: {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    Text("Simple yes or no response pertaining to the night of sleep the evening prior")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                VStack(alignment: .leading) {
                    Text("🤕 Pain")
                    HStack {
                        Slider(value: $entryManager.globalPain, in: 0...5, step: 1)
                        Text(entryManager.globalPain.formatted(.number))
                            .font(.largeTitle)
                            .frame(width: 28)
                    }
                }
                VStack(alignment: .leading) {
                    Text("😵‍💫 Gut and Digestive issues")
                    HStack {
                        Slider(value: $entryManager.gutPain, in: 0...5, step: 1)
                        
                        Text(entryManager.gutPain.formatted(.number))
                            .font(.largeTitle)
                            .frame(width: 28)
                    }
                }
                VStack(alignment: .leading) {
                    Text("😶‍🌫️ Neurological issues")
                    HStack {
                        Slider(value: $entryManager.neurologicalPain, in: 0...5, step: 1)
                        Text(entryManager.neurologicalPain.formatted(.number))
                            .font(.largeTitle)
                            .frame(width: 28)
                    }
                }
            }
            Section("Crash 🔥") {
                VStack(alignment: .leading) {
                    Text("Having a crash / Had a crash today ?")
                    Picker("", selection: $entryManager.goodSleep, content: {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    Text("A crash refers to a significant set-back in ability to perform daily functions. It represents a temporary worsening of symptoms. Simple yes or no response.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Section("Save") {
                VStack(alignment: .leading) {
                    Button(action: {
                        entryManager.saveEntry()
                    }, label: {
                        HStack {
                            Spacer()
                            Image(systemName: "pin.square.fill")
                            Text("Save entry for today")
                                .font(.headline)
                            Spacer()
                        }.padding(.vertical, 6)
                    })
                    .buttonStyle(BorderedProminentButtonStyle())
                    Text("This will add an entry for today, you can add one entry per day, if necessary you can delete this entry in the history section and re-recrate one")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct AddEntry_Previews: PreviewProvider {
    static var previews: some View {
        AddEntry()
    }
}
