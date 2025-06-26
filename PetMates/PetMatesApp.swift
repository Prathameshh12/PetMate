//
//  PetMatesApp.swift
//  PetMates
//
//  Created by Prathamesh Ahire on 26/6/2025.
//

import SwiftUI

@main
struct PetMatesApp: App {
    
    init() {
            // Clear saved task data on every fresh app launch
            UserDefaults.standard.removeObject(forKey: "taskList")
            UserDefaults.standard.removeObject(forKey: "taskProgress")
        }

    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
    }
}
