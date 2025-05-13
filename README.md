# TVmaze

## 1. Running the App

- No third-party libraries are used — just run the app in Xcode.
- The goal is to avoid third-party dependencies to keep the app binary lightweight.
- The app was developed in **Xcode 16.3** and supports a **minimum iOS version of 16.0**.

## 2. Architecture

- The app follows **Clean Architecture**, with a **Composition Root** to manage dependencies.
- The **Presentation Layer** is implemented using **MVVM** with **SwiftUI**.
- **Persistence** is handled using **Core Data**.
- **Networking** is performed using **URLSession**.
- **Unit tests** are implemented for the persistence and networking layers.

## 3. To Be Implemented

- Caching for people data.
- Image caching to replace `AsyncImage` and store images locally.
- Unit tests for:
  - `URLSessionHTTPClient`
  - `CoreDataTVMazeStore`
  - `InMemoryStore`
- Acceptance and integration tests.
- UI tests.
- A **Settings** tab to manage: PIN change, PIN reset and Biometric authentication configuration
