//
//  MoreTechApp.swift
//  MoreTech
//
//  Created by Danila Semischastnov on 14.10.2023.
//

import SwiftUI

@main
struct MoreTechApp: App {
    var body: some Scene {
        WindowGroup {
            MainFactory.make()
        }
    }
}
