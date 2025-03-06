//
//  AppBackground.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import SwiftUI

struct AppBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                colorScheme == .dark ? Color.black : Color.white
            )
    }
}

extension View {
    func withAppBackground() -> some View {
        self.modifier(AppBackground())
    }
}
