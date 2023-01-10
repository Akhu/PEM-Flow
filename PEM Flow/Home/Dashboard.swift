//
//  Dashboard.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 25/09/2022.
//

import SwiftUI

struct Dashboard: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            switch viewModel.dataState {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            case .fetched:
                Text("\(viewModel.entries.count)")
                Button {
                    viewModel.displayCrash.toggle()
                } label: {
                    HStack {
                        Text("💥")
                        Spacer()
                        Text("Afficher mes crashs")
                            .padding(.vertical, 4)
                    }
                }
                .listRowSeparator(.hidden)
                .buttonStyle( BorderedProminentButtonStyle())
                .tint(viewModel.displayCrash ? .red : .secondary)
                Section("Fatigue") {
                    FatigueChart(items: viewModel.entries, displayCrash: $viewModel.displayCrash)
                        .frame(height: 300)
                }
                Section("Douleurs") {
                    SymptomsComparisonChart(items: viewModel.entries, displayCrash: viewModel.displayCrash)
                        .frame(height: 230)
                        .padding(.horizontal)
                        .padding(.top, 24)
                }
                Section("Activities") {
                    ActivityChart(seriesArray: viewModel.entries)
                        .frame(height: 300)
                        .padding(.horizontal)
                }
                if viewModel.entries.count > 2 {
                    Section("Symptômes et Activités") {
                        AverageSymptomsActivityChart(seriesArray: viewModel.entries)
                            .frame(height: 450)
                            .padding(.horizontal)
                    }
                } else {
                    Text("Ajoutez encore des données pour afficher plus de graphiques")
                }
            case .noData:
                EmptyView()
            case .error(_):
                EmptyView()
            case .unfetched:
                EmptyView()
            }
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
            .environmentObject(HomeViewModel(dataManager: CoreDataManager.preview))
            //.environment(\.managedObjectContext, CoreDataManager.preview.managedObjectContext)
    }
}
