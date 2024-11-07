//
//  ContentView.swift
//  Demo_UI
//
//  Created by Maheshwaran on 07/11/24.
//

import SwiftUI

struct ContentView: View {
  
  typealias Item = ContentViewModel.Item
  
  @StateObject private var viewModel = ContentViewModel()
  
  var body: some View {
    mainView
      .navigationTitle("Home")
  }
  
  private var mainView: some View {
    List(content: listView)
      .toolbar(content: addButton)
      .navigationDestination(
        isPresented: $viewModel.isPresented,
        destination: destinationView)
  }
  
  private func listView() -> some View {
    ForEach(viewModel.records, id: \.id, content: detailView)
      .onDelete(perform: viewModel.deleteItems)
  }
  
  private func detailView(for record: Item) -> some View {
    LabeledContent("Title - \(record.title ?? "")",
                   value: record.desc ?? "Desc")
    .contentShape(.rect)
    .onTapGesture { viewModel.showDetails(for: record) }
  }
  
  @ViewBuilder
  private func destinationView() -> some View {
    DetailView(selectedItem: viewModel.selectedItem)
  }
}

extension ContentView {
  
  private func addButton() -> some ToolbarContent {
    ToolbarItem(placement: .topBarTrailing) {
      Button(role: .none, action: viewModel.addItem) {
        Image(systemName: "plus")
      }
    }
  }
}

#Preview {
  NavigationStack {
    ContentView()
  }
}

