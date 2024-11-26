//
//  UserItem+CoreDataProperties.swift
//  Demo_UI
//
//  Created by Maheshwaran on 07/11/24.
//
//

import Foundation
import CoreData

extension UserItem {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserItem> {
    return NSFetchRequest<UserItem>(entityName: "UserItem")
  }
  
  @NSManaged public var desc: String?
  @NSManaged public var timestamp: Date?
  @NSManaged public var title: String?
  @NSManaged public var privateID: String
  
}

extension UserItem : Identifiable {}
