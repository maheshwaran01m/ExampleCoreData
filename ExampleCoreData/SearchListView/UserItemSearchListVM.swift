//
//  UserItemSearchListVM.swift
//  Demo_UI
//
//  Created by Maheshwaran on 07/11/24.
//

import SwiftUI

class UserItemSearchListVM: SyncSearchListVM<UserItem> {
  
  init() {
    super.init(sort: [NSSortDescriptor(keyPath: \UserItem.privateID, ascending: true)])
  }
  
  override func title(for record: UserItem) -> String {
    record.title ?? ""
  }
  
  override func desc(for record: UserItem) -> String {
    record.desc ?? ""
  }
}

// MARK: - UserItemSearchListView

struct UserItemSearchListView: View {
  
  @StateObject private var viewModel = UserItemSearchListVM()
  @Binding var selectedItem: UserItem?
  
  init(for selectedItem: Binding<UserItem?>) {
    _selectedItem = selectedItem
  }
  
  var body: some View {
    SearchListView(viewModel, selectedItem: $selectedItem)
  }
}

// MARK: - LazyView

extension View {
  
  func navigationTextRow(destination: @escaping () -> some View,
                         @ViewBuilder label: () -> some View) -> some View {
    NavigationLink(destination: { LazyView(destination) }) {
      label()
    }
  }
}

public struct LazyView<V: View>: View {
  public let build: () -> V
  
  public init(@ViewBuilder _ build: @escaping () -> V) {
    self.build = build
  }
  
  public var body: some View {
    build()
  }
}
