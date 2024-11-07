//
//  FetchResults.swift
//  Demo_UI
//
//  Created by Maheshwaran on 07/11/24.
//

import CoreData

class FetchResults<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
  
  var fetchedResults: NSFetchedResultsController<T>
  
  var onChange: (([T]) -> Void)?
  
  var objects: [T] = [] {
    didSet {
      onChange?(objects)
    }
  }
  
  private var fetchContext: NSManagedObjectContext
  
  init(_ store: CoreDataService = .shared,
       context: NSManagedObjectContext = .main,
       predicate: NSPredicate? = nil,
       sort: [NSSortDescriptor] = []) {
    
    let fetchRequest = NSFetchRequest<T>(
      entityName: T.entity().name ?? String(describing: T.self))
    fetchRequest.includesPendingChanges = false
    fetchRequest.fetchBatchSize = 20
          
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sort
    
    fetchedResults = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil)
    fetchContext = context
    
    super.init()
    setupOnChange()
  }
  
  private func setupOnChange() {
    fetchedResults.delegate = self
  }
  
  func performFetch(_ onChange: @escaping ([T]) -> Void) throws {
    self.onChange = onChange
    
    try fetchedResults.performFetch()
    
    fetchContext.perform {
      self.objects = self.fetchedResults.fetchedObjects ?? []
    }
  }
  
  public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    objects = controller.fetchedObjects as? [T] ?? []
  }
}
