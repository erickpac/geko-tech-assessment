//
//  geko_tech_assessmentApp.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import SwiftUI
import SwiftData

@main
struct geko_tech_assessmentApp: App {
    @State private var coordinator = AppCoordinator()
    @State private var sessionManager: SessionManager?

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                LoginView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .login:
                            LoginView()
                        case .register:
                            RegisterView()
                        case .home:
                            HomeView()
                        }
                    }
            }
            .environment(coordinator)
            .overlay {
                if sessionManager?.isCheckingSession == true {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()

                        ProgressView("Comprobando sesión...")
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(10)
                    }
                }
            }
            .task {
                if sessionManager == nil {
                    sessionManager = await SessionManager.create()

                    if let manager = sessionManager {
                        await manager.checkActiveSession(coordinator: coordinator)
                    }
                }
            }
        }
    }
}
