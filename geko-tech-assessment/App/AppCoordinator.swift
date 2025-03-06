//
//  AppCoordinator.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import SwiftUI

enum AppRoute: Hashable {
    case login
    case register
    case home
}

@Observable
class AppCoordinator {
    var path = NavigationPath()

    func navigate(to route: AppRoute) {
        path.append(route)
    }

    func popToPrevious() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
