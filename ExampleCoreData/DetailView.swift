//
//  DetailView.swift
//  Demo_UI
//
//  Created by Maheshwaran on 07/11/24.
//
import SwiftUI

struct DetailView: View {
    
  @State private var selectedItem: UserItem?
  
  init(selectedItem: UserItem? = nil) {
    _selectedItem = .init(initialValue: selectedItem)
  }
  
  var body: some View {
    List {
      NavigationLink(destination: { LazyView(destinationView) }, label: detailView)
        .padding(.horizontal, 10)
        .clipShape(.rect(cornerRadius: 16))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .listRowInsets(.init(top: 4,leading: 8, bottom: 4, trailing: 8))
        .contentShape(.rect)
    }
    .listStyle(.plain)
  }
  
  private func detailView() -> some View {
    VStack(alignment: .leading) {
      Text("Get Details - \(selectedItem?.title ?? "")")
    }
    .padding()
    .padding(.top, 10)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.blue.opacity(0.2), in: .rect(cornerRadius: 16))
    .navigationTitle("Detail \(selectedItem?.title ?? "")")
  }
  
  private func destinationView() -> some View {
    UserItemSearchListView(for: $selectedItem)
  }
}
