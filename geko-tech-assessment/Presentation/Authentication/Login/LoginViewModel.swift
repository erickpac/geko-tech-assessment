//
//  LoginViewModel.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import Foundation
import SwiftUI

@Observable
class LoginViewModel {
    var email: String = ""
    var password: String = ""

    var emailError: String = ""
    var passwordError: String = ""

    var isLoading: Bool = false
    var generalError: String = ""
    var loginSuccess: Bool = false

    var isLoginButtonEnabled: Bool {
        !email.isEmpty && !password.isEmpty && emailError.isEmpty && passwordError.isEmpty
    }

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    static func create() async -> LoginViewModel {
        return LoginViewModel(loginUseCase: await DIContainer.shared.loginUseCase)
    }

    func validateEmail() {
        emailError = email.isEmpty ? "" : (Validators.isValidEmail(email) ? "" : "Formato de correo electrónico inválido")
    }

    func validatePassword() {
        passwordError = password.isEmpty ? "" : (Validators.isValidPassword(password) ? "" : "La contraseña debe tener al menos 6 caracteres")
    }

    func resetForm() {
        email = ""
        password = ""
        emailError = ""
        passwordError = ""
        generalError = ""
    }

    func login() {
        isLoading = true
        generalError = ""

        Task {
            do {
                let success = try await loginUseCase.execute(email: email, password: password)

                await MainActor.run {
                    self.isLoading = false

                    if success {
                        self.loginSuccess = success
                        self.resetForm()
                    } else {
                        self.generalError = "Credenciales incorrectas. Inténtalo de nuevo."
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.generalError = error.localizedDescription
                }
            }
        }
    }
}
