//
//  RegisterView.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var viewModel: RegisterViewModel?
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        Group {
            if let viewModel = viewModel {
                contentView(viewModel: viewModel)
            } else {
                loadingView
                    .task {
                        viewModel = await RegisterViewModel.create()
                    }
            }
        }
    }

    private func contentView(viewModel: RegisterViewModel) -> some View {
        ScrollView {
            VStack(spacing: 30) {
                headerView

                if !viewModel.generalError.isEmpty {
                    errorView(message: viewModel.generalError)
                }

                formView(viewModel: viewModel)

                registerButton(viewModel: viewModel)

                loginLink
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: viewModel.registerSuccess) {
            if viewModel.registerSuccess {
                coordinator.popToPrevious()
            }
        }
        .navigationBarBackButtonHidden(false)
    }

    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            Text("Cargando...")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    private var headerView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.badge.plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.bottom, 20)

            Text("Crear Cuenta")
                .font(.largeTitle.bold())

            Text("Ingresa tus datos para registrarte")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }

    private func errorView(message: String) -> some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(0.8))
            .cornerRadius(8)
    }

    private func formView(viewModel: RegisterViewModel) -> some View {
        VStack(spacing: 16) {
            AppTextField(
                title: "Correo Electrónico",
                text: Binding(
                    get: { viewModel.email },
                    set: { viewModel.email = $0; viewModel.validateEmail() }
                ),
                placeholder: "ejemplo@correo.com",
                keyboardType: .emailAddress,
                errorMessage: viewModel.emailError
            )

            AppTextField(
                title: "Contraseña",
                text: Binding(
                    get: { viewModel.password },
                    set: {
                        viewModel.password = $0
                        viewModel.validatePassword()
                        if !viewModel.confirmPassword.isEmpty {
                            viewModel.validateConfirmPassword()
                        }
                    }
                ),
                placeholder: "Mínimo 6 caracteres",
                isSecure: true,
                errorMessage: viewModel.passwordError
            )

            AppTextField(
                title: "Confirmar Contraseña",
                text: Binding(
                    get: { viewModel.confirmPassword },
                    set: { viewModel.confirmPassword = $0; viewModel.validateConfirmPassword() }
                ),
                placeholder: "Repite tu contraseña",
                isSecure: true,
                errorMessage: viewModel.confirmPasswordError
            )
        }
    }

    private func registerButton(viewModel: RegisterViewModel) -> some View {
        PrimaryButton(
            title: "Registrarse",
            action: {
                hideKeyboard()
                viewModel.register()
            },
            isLoading: viewModel.isLoading,
            disabled: !viewModel.isRegisterButtonEnabled
        )
    }

    private var loginLink: some View {
        HStack {
            Text("¿Ya tienes cuenta?")
                .foregroundColor(.secondary)

            Button("Inicia sesión") {
                coordinator.popToPrevious()
            }
            .foregroundColor(.blue)
            .fontWeight(.semibold)
        }
        .padding(.top, 8)
    }
}
