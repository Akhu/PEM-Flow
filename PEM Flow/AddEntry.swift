//
//  AddEntry.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 26/08/2022.
//

import SwiftUI

struct AddEntry: View {
    
    @ObservedObject var entryManager = EntryManager()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    
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
                   Label("Physical Activity", systemImage: "figure.walk.circle.fill")
                        .labelStyle(ColoredIconLabelStyle())
                        
                    HStack {
                        Slider(value: $entryManager.physicalActivity, in: 0...10, step: 1)
                        
                        Text(entryManager.physicalActivity.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
                VStack(alignment: .leading) {
                    Label("Social Activity", systemImage: "figure.wave.circle.fill")
                         .labelStyle(ColoredIconLabelStyle())
                    HStack {
                        Slider(value: $entryManager.socialActivity, in: 0...10, step: 1)
                        
                        Text(entryManager.socialActivity.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                    
                }
                VStack(alignment: .leading) {
                    Label("Cognitive Activity", systemImage: "graduationcap.circle.fill")
                         .labelStyle(ColoredIconLabelStyle())

                    HStack {
                        Slider(value: $entryManager.mentalActivity, in: 0...10, step: 1)
                        
                        Text(entryManager.mentalActivity.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
                VStack(alignment: .leading) {
                    Label("Emotional Activity", systemImage: "heart.circle.fill")
                         .labelStyle(ColoredIconLabelStyle())
                    
                    HStack {
                        Slider(value: $entryManager.emotionalActivity, in: 0...10, step: 1)
                        
                        Text(entryManager.emotionalActivity.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
            }
            Section("Symptoms ❤️‍🩹") {
                VStack(alignment: .leading) {
                    Text("🛌 Good night sleep")
                        .modifier(DataElementTitleTextStyle())
                    Picker("", selection: $entryManager.goodSleep, content: {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    Text("Simple yes or no response pertaining to the night of sleep the evening prior")
                        .modifier(DescriptionTextStyle())
                }
                VStack(alignment: .leading) {
                    Text("🫥 Fatigue")
                        .modifier(DataElementTitleTextStyle())
                    HStack {
                        Slider(value: $entryManager.fatigue, in: 0...10, step: 1)
                        Text(entryManager.fatigue.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
                VStack(alignment: .leading) {
                    Text("🤕 Pain")
                        .modifier(DataElementTitleTextStyle())
                    HStack {
                        Slider(value: $entryManager.globalPain, in: 0...10, step: 1)
                        Text(entryManager.globalPain.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
                VStack(alignment: .leading) {
                    Text("😵‍💫 Gut and Digestive issues")
                        .modifier(DataElementTitleTextStyle())
                    HStack {
                        Slider(value: $entryManager.gutPain, in: 0...10, step: 1)
                        
                        Text(entryManager.gutPain.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
                VStack(alignment: .leading) {
                    Text("😶‍🌫️ Neurological issues")
                        .modifier(DataElementTitleTextStyle())
                    HStack {
                        Slider(value: $entryManager.neurologicalPain, in: 0...10, step: 1)
                        Text(entryManager.neurologicalPain.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
            }
            Section("How was your day?") {
                VStack(alignment: .leading) {
                    Text("😖 Had a crash today ?")
                        .modifier(DataElementTitleTextStyle())
                    Picker("", selection: $entryManager.crash, content: {
                        Text("Yes")
                            .tag(true)
                        Text("No").tag(false)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    Spacer()
                    Text("A crash refers to a significant set-back in ability to perform daily functions. It represents a temporary worsening of symptoms. Simple yes or no response.")
                        .modifier(DescriptionTextStyle())
                    Divider().padding(.bottom)
                    Text("🌈 Notes")
                        .modifier(DataElementTitleTextStyle())
                    
                    TextEditor(text: $entryManager.notes)
                        .padding(.leading, 8)
                        .padding(.top, 8)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        
                        
                    Spacer()
                    Text("Set your mind free before bed by writing how do you feel? What happened special (or not) today? Being grateful for the good moments also help recovering.")
                        .modifier(DescriptionTextStyle())
                        
                }.padding(.vertical)
            }
            Section("Save") {
                VStack(alignment: .leading) {
                    Button(action: {
                        entryManager.saveEntry(moc: viewContext)
                        presentationMode.wrappedValue.dismiss()
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
                    Spacer()
                    Text("This will add an entry for today, you can add one entry per day, if necessary you can delete this entry in the history section and re-recrate one")
                        .modifier(DescriptionTextStyle())
                }.padding(.vertical)
            }
        }
        
    }
    
    
}

struct AddEntry_Previews: PreviewProvider {
     
    static var previews: some View {
        AddEntry(entryManager: EntryManager())
            
    }
}
