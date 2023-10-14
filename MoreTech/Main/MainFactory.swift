//
//  MainFactory.swift
//  MoreTechSwiftUI
//
//  Created by Danila Semischastnov on 13.10.2023.
//

import Foundation

enum MainFactory {
    static func make() -> MainView {
        MainView(viewModel: MainViewModel())
    }
}
