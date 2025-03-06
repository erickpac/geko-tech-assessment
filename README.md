# Modern iOS Authentication App

A complete iOS authentication application showcasing modern Swift development practices with Swift Concurrency and the Observation framework.

## Project Details

- **Swift Version:** 6.0
- **Platform:** iOS
- **License:** MIT

## Overview

This project demonstrates a modern approach to iOS application development using Swift's latest features for asynchronous programming and state management. It includes a complete authentication flow (login, registration, and home screen) built with Swift Concurrency (async/await) and the Observation framework.

## Features

- 🔒 Complete authentication flow (login, register, logout)
- 🔄 Swift Concurrency with async/await
- 📊 SwiftData for local persistence
- 🏗️ MVVM + Clean Architecture
- 🧩 Dependency Injection with Actors
- 📱 Modern SwiftUI interfaces
- 🔍 Input validation with real-time feedback
- 🧪 Testable architecture

## Architecture

The application follows Clean Architecture principles with MVVM pattern:

### Layers

1. Domain Layer:
   - Models (User)
   - Repository interfaces
   - Use Cases (Login, Register)
2. Data Layer:
   - Repository implementations
   - SwiftData integration
   - Local data sources
3. Presentation Layer:
   - ViewModels with @Observable
   - SwiftUI Views
   - Navigation coordination
4. App Core:
   - Dependency injection container
   - Session management
   - App coordination

## Technical Highlights

- _Swift Concurrency:_ Using async/await for asynchronous operations
- _@Observable:_ Leveraging the new Observation framework for reactive UI updates
- _Actors:_ Thread-safe dependency injection with Swift actors
- _Factory Methods:_ Clean ViewModel initialization
- _SwiftData:_ Modern persistence layer for user data
- _Composable UI:_ Reusable SwiftUI components
- _MainActor:_ Ensuring UI updates on the main thread

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/erickpac/geko-tech-assessment
   ```

2. Open the project in Xcode:

   ```bash
   cd geko-tech-assessment
   open geko-tech-assessment.xcodeproj
   ```

3. Build and run the project in the Xcode simulator or on a physical device.

## Future Enhancements

- [ ] Unit and UI tests
- [ ] Remote authentication integration
- [ ] Biometric authentication
- [ ] Multiple themes support
- [ ] Localization
- [ ] Deep linking support

## License

This project is available under the MIT license. See the LICENSE file for more info.
