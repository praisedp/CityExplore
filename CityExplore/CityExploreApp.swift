//
//  CityExploreApp.swift
//  CityExplore
//
//  Created by Pasan Perera on 2025-11-21.
//

import SwiftUI
internal import CoreData

@main
struct CityExplorerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

