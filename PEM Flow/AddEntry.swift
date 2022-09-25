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
    
    @Binding var dataRefreshed : Bool
    
    private let todayDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Image(systemName: "calendar.badge.plus")
                    Text(Date(), formatter: todayDateFormat)
                }
            } header: {
                Text("Aujourd'hui")
            }

            
            Section("Activités ⚡️") {
                VStack(alignment: .leading) {
                   Label("Physique", systemImage: "figure.walk.circle.fill")
                        .labelStyle(ColoredIconLabelStyle())
                        
                    HStack {
                        Slider(value: $entryManager.physicalActivity, in: 0...10, step: 1)
                        
                        Text(entryManager.physicalActivity.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
                VStack(alignment: .leading) {
                    Label("Social", systemImage: "figure.wave.circle.fill")
                         .labelStyle(ColoredIconLabelStyle())
                    HStack {
                        Slider(value: $entryManager.socialActivity, in: 0...10, step: 1)
                        
                        Text(entryManager.socialActivity.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                    
                }
                VStack(alignment: .leading) {
                    Label("Cognitive", systemImage: "graduationcap.circle.fill")
                         .labelStyle(ColoredIconLabelStyle())

                    HStack {
                        Slider(value: $entryManager.mentalActivity, in: 0...10, step: 1)
                        
                        Text(entryManager.mentalActivity.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
                VStack(alignment: .leading) {
                    Label("Émotionnelle", systemImage: "heart.circle.fill")
                         .labelStyle(ColoredIconLabelStyle())
                    
                    HStack {
                        Slider(value: $entryManager.emotionalActivity, in: 0...10, step: 1)
                        
                        Text(entryManager.emotionalActivity.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
            }
            Section("Symptômes ❤️‍🩹") {
                VStack(alignment: .leading) {
                    Text("🛌 Sommeil réparateur ?")
                        .modifier(DataElementTitleTextStyle())
                    Picker("", selection: $entryManager.goodSleep, content: {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    Text("Réponse simple oui ou non si votre nuit à été reposante ou non")
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
                    Text("🤕 Douleurs")
                        .modifier(DataElementTitleTextStyle())
                    HStack {
                        Slider(value: $entryManager.globalPain, in: 0...10, step: 1)
                        Text(entryManager.globalPain.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
                VStack(alignment: .leading) {
                    Text("😵‍💫 Problèmes digestifs")
                        .modifier(DataElementTitleTextStyle())
                    HStack {
                        Slider(value: $entryManager.gutPain, in: 0...10, step: 1)
                        
                        Text(entryManager.gutPain.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
                VStack(alignment: .leading) {
                    Text("😶‍🌫️ Brouillard mental")
                        .modifier(DataElementTitleTextStyle())
                    HStack {
                        Slider(value: $entryManager.neurologicalPain, in: 0...10, step: 1)
                        Text(entryManager.neurologicalPain.formatted(.number))
                            .modifier(NumberTextStyle())
                    }
                }
            }
            Section("Votre journée") {
                VStack(alignment: .leading) {
                    Text("😖 Avez vous eu un crash ?")
                        .modifier(DataElementTitleTextStyle())
                    Picker("", selection: $entryManager.crash, content: {
                        Text("Oui")
                            .tag(true)
                        Text("Non").tag(false)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    Spacer()
                    Text("Un crash fait référence à un recul significatif de la capacité à effectuer les tâches quotidiennes. Elle représente une aggravation temporaire des symptômes. Réponse simple oui ou non.")
                        .modifier(DescriptionTextStyle())
                    Divider().padding(.bottom)
                    Text("🌈 Journal")
                        .modifier(DataElementTitleTextStyle())
                    
                    TextEditor(text: $entryManager.notes)
                        .padding(.leading, 8)
                        .padding(.top, 8)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        
                        
                    Spacer()
                    Text("Libérez votre esprit avant de vous coucher en écrivant comment vous sentez-vous ? Que s'est-il passé de spécial (ou pas) aujourd'hui ? Reconnaître les bons moments aide aussi à récupérer.")
                        .modifier(DescriptionTextStyle())
                        
                }.padding(.vertical)
            }
            Section("Enregistrer") {
                VStack(alignment: .leading) {
                    Button(action: {
                        entryManager.saveEntry(moc: viewContext)
                        dataRefreshed.toggle()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Spacer()
                            Image(systemName: "pin.square.fill")
                            Text("Sauvegarder pour aujourd'hui")
                                .font(.headline)
                            Spacer()
                        }.padding(.vertical, 6)
                    })
                    .buttonStyle(BorderedProminentButtonStyle())
                    Spacer()
                    Text("Cela ajoutera une entrée pour aujourd'hui, vous pouvez ajouter une entrée par jour, si nécessaire vous pouvez supprimer cette entrée dans la section historique et en recréer une")
                        .modifier(DescriptionTextStyle())
                }.padding(.vertical)
            }
        }
        
    }
    
    
}

struct AddEntry_Previews: PreviewProvider {
     
    static var previews: some View {
        AddEntry(entryManager: EntryManager(), dataRefreshed: .constant(true))
            
    }
}
