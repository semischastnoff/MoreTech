//
//  MapFactory.swift
//  MoreTechSwiftUI
//
//  Created by Danila Semischastnov on 13.10.2023.
//

import Foundation

enum MapFactory {
    static func make() -> MapView {
        MapView(viewModel: MapViewModel())
    }
}
