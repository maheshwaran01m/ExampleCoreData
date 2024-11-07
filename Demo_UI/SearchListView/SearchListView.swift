//
//  SearchListView.swift
//  Demo_UI
//
//  Created by Maheshwaran on 07/11/24.
//

import CoreData
import SwiftUI

struct SearchListView<T: Hashable>: View {
  
  @Environment(\.dismiss) private var dismiss
  
  @ObservedObject private var viewModel: SearchListVM<T>
  @Binding var selectedItem: T?
  @State private var selectionItem: T?
  
  init(_ viewModel: some SearchListVM<T>, selectedItem: Binding<T?>) {
    self.viewModel = viewModel
    _selectedItem = selectedItem
  }
  
  var body: some View {
    List(viewModel.records, id: \.self) { record in
      
      ListDetailView(
        title: viewModel.title(for: record),
        desc: viewModel.desc(for: record),
        isSelected: record == selectedItem) {
          selectedItem = record
          dismiss()
        }

    }
    .listStyle(.plain)
  }
  
  struct ListDetailView: View {
    
    let title: String, desc: String, isSelected: Bool
    let action: () -> Void
    
    var body: some View {
      LabeledContent(title, value: desc)
      .padding(.horizontal, 10)
      .clipShape(.rect(cornerRadius: 16))
      .listRowSeparator(.hidden)
      .listRowBackground(backgroundView)
      .listRowInsets(.init(top: 4,leading: 8, bottom: 4, trailing: 8))
      .contentShape(.rect)
      .onTapGesture(perform: action)
    }
    
    private var backgroundView: some View {
      (isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding([.vertical, .horizontal], 4)
    }
  }
}
