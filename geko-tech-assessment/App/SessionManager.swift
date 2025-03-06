//
//  SessionManager.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import Foundation

@Observable
class SessionManager {
    var isCheckingSession: Bool = false
    var hasCheckedSession: Bool = false

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    static func create() async -> SessionManager {
        let repository = await DIContainer.shared.authRepository
        return SessionManager(authRepository: repository)
    }

    func checkActiveSession(coordinator: AppCoordinator) async {
        if isCheckingSession || hasCheckedSession { return }

        isCheckingSession = true

        do {
            let isLoggedIn = try await authRepository.isUserLoggedIn()

            // Return to the main thread to update the UI
            await MainActor.run {
                if isLoggedIn {
                    coordinator.navigate(to: .home)
                }
                self.isCheckingSession = false
                self.hasCheckedSession = true
            }
        } catch {
            await MainActor.run {
                print("Error checking session: \(error.localizedDescription)")
                self.isCheckingSession = false
                self.hasCheckedSession = true
            }
        }
    }
}
