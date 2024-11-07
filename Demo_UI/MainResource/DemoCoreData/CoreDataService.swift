//
//  CoreDataService.swift
//  Demo_UI
//
//  Created by Maheshwaran on 07/11/24.
//

import CoreData

final class CoreDataService {
  
  static let shared = CoreDataService()
  
  let container: NSPersistentContainer
  
  private var viewContext: NSManagedObjectContext!
  
  var inMemory = false
  
  private init() {
    container = NSPersistentContainer(name: "Demo_UI")
    
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
      
    } else {
      container.loadPersistentStores { [weak self] store, error in
        
        guard let self, error == nil else {
          fatalError("Unable to load store, Reason: \(error?.localizedDescription ?? "")")
        }
        
        self.viewContext = container.viewContext
        self.container.viewContext.automaticallyMergesChangesFromParent = true
      }
    }
  }
  
  var mainContext: NSManagedObjectContext {
    viewContext!
  }
}

// MARK: - Preview

extension CoreDataService {
  
  @MainActor
  static let preview: CoreDataService = {
    let result = CoreDataService()
    result.inMemory = true
    
    let context = result.container.viewContext
    
    for i in 0..<100 {
      let newItem = UserItem(context: context)
      newItem.privateID = i.description
      newItem.title = "Title " + i.description
      newItem.desc = "Desc " + i.description
      newItem.timestamp = Date()
    }
    try? context.save()
    
    return result
  }()
}

// MARK: - Main Context

extension NSManagedObjectContext {
  
  static var main: NSManagedObjectContext {
    CoreDataService.shared.mainContext
  }
}
