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

## 3. Features

- All mandatory and bonus features are implemented.
- The app begins with a **PIN setup** screen, followed by three main tabs: **Shows**, **People**, and **Favorites**.
- You can **add shows to your favorites** and view detailed information by tapping on a show.
- The **Show Detail** screen displays additional info, including a list of episodes. Tapping on an episode opens the **Episode Detail** screen.
- In the **People** tab, you can tap on a person to view more detailed information.
- The **Favorites** tab displays all your favorited shows, and you can follow the same navigation flow as in the Shows tab.
- You can use **Face ID** or **Touch ID** to enter to the app as well.

## 4. To Be Implemented

- Caching for people data and for app images to replace `AsyncImage` and store images locally.
- Unit tests for: `URLSessionHTTPClient`, `CoreDataTVMazeStore` and `InMemoryStore`.
- Acceptance, UI and Integration tests.
- A **Settings** tab to manage: PIN change, PIN reset and Biometric authentication configuration
