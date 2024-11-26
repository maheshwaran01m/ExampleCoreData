//
//  SearchListVM.swift
//  Demo_UI
//
//  Created by Maheshwaran on 07/11/24.
//

import CoreData
import SwiftUI

class SearchListVM<T: Hashable>: ObservableObject {
  
  @Published var records = [T]()
    
  init(_ records: [T] = []) {
    self.records = records
    fetchRecords()
  }
  
  func fetchRecords() {}
  
  func updateUI(_ records: [T]) {
    self.records = records
  }
  
  // MARK: - Style
  
  func title(for record: T) -> String {
    ""
  }
  
  func desc(for record: T) -> String {
    ""
  }
}

// MARK: - SyncSearchListVM

class SyncSearchListVM<T: Hashable & NSManagedObject>: SearchListVM<T> {
    
  private var fetchResults: FetchResults<T>
  
  init(_ predicate: NSPredicate? = nil, sort: [NSSortDescriptor] = []) {
    fetchResults = .init(predicate: predicate, sort: sort)
    super.init()
    observeResultsOnChangeEvent()
  }
  
  override func fetchRecords() {
    do {
      try fetchResults.performFetch { [weak self] records in
        self?.updateUI(records)
      }
    } catch {
      print("Error While fetch UserItem, Reason: \(error.localizedDescription)")
    }
  }
  
  override func updateUI(_ records: [T]) {
    self.records = records
  }
  
  func observeResultsOnChangeEvent() {
    self.fetchResults.onChange = { [weak self] records in
      guard let self else { return }
      self.updateUI(records)
    }
  }
}
