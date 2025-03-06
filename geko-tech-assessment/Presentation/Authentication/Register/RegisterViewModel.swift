//
//  RegisterViewModel.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import Foundation
import SwiftUI

@Observable
class RegisterViewModel {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    var emailError: String = ""
    var passwordError: String = ""
    var confirmPasswordError: String = ""

    var isLoading: Bool = false
    var generalError: String = ""
    var registerSuccess: Bool = false

    var isRegisterButtonEnabled: Bool {
        !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty &&
        emailError.isEmpty && passwordError.isEmpty && confirmPasswordError.isEmpty
    }

    private let registerUseCase: RegisterUseCase

    init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
    }

    static func create() async -> RegisterViewModel {
        return RegisterViewModel(registerUseCase: await DIContainer.shared.registerUseCase)
    }

    func validateEmail() {
        emailError = email.isEmpty ? "" : (Validators.isValidEmail(email) ? "" : "Formato de correo electrónico inválido")
    }

    func validatePassword() {
        passwordError = password.isEmpty ? "" : (Validators.isValidPassword(password) ? "" : "La contraseña debe tener al menos 6 caracteres")
    }

    func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = ""
        } else {
            confirmPasswordError = password == confirmPassword ? "" : "Las contraseñas no coinciden"
        }
    }

    func register() {
        isLoading = true
        generalError = ""

        Task {
            do {
                let success = try await registerUseCase.execute(email: email, password: password)

                await MainActor.run {
                    self.isLoading = false
                    self.registerSuccess = success
                    if !success {
                        self.generalError = "No se pudo completar el registro. Inténtalo de nuevo."
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
