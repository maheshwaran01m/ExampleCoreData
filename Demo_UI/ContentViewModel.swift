//
//  ContentViewModel.swift
//  Demo_UI
//
//  Created by Maheshwaran on 07/11/24.
//

import CoreData
import SwiftUI

class ContentViewModel: ObservableObject {
  
  private let moc = CoreDataService.shared.mainContext
  
  @Published var records = [Item]()
  @Published var isPresented = false {
    didSet {
      if !isPresented { selectedItem = nil }
    }
  }
  
  private(set) var selectedItem: UserItem?
  
  private var fetchResults: FetchResults<UserItem>
  
  init() {
    fetchResults = .init(sort: [NSSortDescriptor(keyPath: \UserItem.privateID, ascending: true)])
    fetchRecords()
    observeResultsOnChangeEvent()
  }
  
  func fetchRecords() {
    do {
      try fetchResults.performFetch { [weak self] records in
        self?.updateUI(records)
      }
    } catch {
      print("Error While fetch UserItem, Reason: \(error.localizedDescription)")
    }
  }
  
  private func updateUI(_ records: [UserItem]) {
    self.records = records.compactMap { Item($0) }
  }
  
  func observeResultsOnChangeEvent() {
    self.fetchResults.onChange = { [weak self] records in
      guard let self else { return }
      self.updateUI(records)
    }
  }
  
  func getUserItem(using item: Item) -> UserItem? {
    fetchResults.objects.first(where: { $0.privateID == item.id })
  }
  
  func showDetails(for item: Item) {
    guard let item = getUserItem(using: item) else { return }
    selectedItem = item
    isPresented = true
  }
}

// MARK: - DB Store

extension ContentViewModel {
  
  func addItem() {
    let item = UserItem(context: moc)
    item.privateID = UUID().uuidString
    item.title = Int.random(in: 0...20).description
    item.desc = Int.random(in: 21...40).description
    item.timestamp = Date()
    
    do {
      try moc.save()
    } catch {
      print("Error While Adding, Reason: \(error.localizedDescription)")
    }
  }
  
  func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { fetchResults.objects[$0] }.forEach(moc.delete)
      
      do {
        try moc.save()
      } catch {
        print("Error While Deleting, Reason: \(error.localizedDescription)")
      }
    }
  }
}

// MARK: - Item

extension ContentViewModel {
  
  struct Item {
    let id: String
    let title: String?
    let desc: String?
    let date: Date?
    
    init(id: String, title: String?, desc: String?, date: Date?) {
      self.id = id
      self.title = title
      self.desc = desc
      self.date = date
    }
    
    init(_ item: UserItem) {
      self.id = item.privateID
      self.title = item.title
      self.desc = item.desc
      self.date = item.timestamp
    }
  }
}
