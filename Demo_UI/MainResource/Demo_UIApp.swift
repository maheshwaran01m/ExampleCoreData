//
//  Demo_UIApp.swift
//  Demo_UI
//
//  Created by Maheshwaran on 07/11/24.
//

import SwiftUI

@main
struct Demo_UIApp: App {
  let coreDataService = CoreDataService.shared
  
  var body: some Scene {
    WindowGroup {
      let _ = print("Path: \(URL.libraryDirectory.path())")
      
      NavigationStack {
        ContentView()
          .environment(\.managedObjectContext, coreDataService.mainContext)
      }
    }
  }
}
