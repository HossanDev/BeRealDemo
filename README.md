# 📱 Instagram Story-like Feature

## 📌 Project Overview

This project implements an **Instagram story-like feature** using SwiftUI, following clean architecture, dependency injection, unit testing, and modern iOS development practices. It provides a list of stories with seen/unseen indicators, infinite pagination, and story viewing with like/unlike functionality.

---

## ✅ Task Requirements and Expectations

- Build a **Story List Screen** that:
  - Displays a list of stories.
  - Supports **pagination with infinite scrolling** (loads more stories on demand).
  - Shows stories visually identifiable as **seen or unseen**.

- Implement **Story View Scene** where:
  - Users can navigate between the story list and individual story views.
  - Users can **like and unlike** stories.
  - Liked stories are visually highlighted.

- Ensure **state persistence** so that:
  - Seen/unseen status and like/unlike interactions are maintained across app state.

---

## API Integration

- Uses [RandomUser.me API](https://randomuser.me):
  - Returns random user data: username, profile image, location, gender, etc.
  - API returns **10 records per request**.
  - API does **not provide seen/unseen or like/unlike flags**; this logic is handled internally.

---

## Technical Choices

- Development Environment: **Xcode 16.2**
- Language: **Swift**
- UI Framework: **SwiftUI** for declarative and maintainable UI.
- Concurrency: Uses **Swift structured concurrency (`async`/`await`)** with `@MainActor` for safe UI updates.
- Reactive Framework: **Minimal Combine** usage for state publishing.

---

## Architecture Overview

- Follows **Clean Architecture with MVVM for view** principles.
- Codebase structured into layers with clear responsibilities.

### Layers and Responsibilities

- **Network Layer**
  - Responsible for URL requests and raw data retrieval.
  - Defines protocols (`NetworkServiceProtocol`).
  - Implements network error handling.
  - Uses dependency injection with default parameters.

- **Repository Layer**
  - Implements repository protocols.
  - Responsible for:
    - Calling network layer.
    - Decoding JSON to models.
    - Returning models to ViewModel.
  - Uses protocol injection for network dependency.
  
- **Endpoint Definitions**
  - All API URLs and parameters are defined in a dedicated **Endpoints** file.
  - Promotes maintainability and modularity.

- **Shared UI Components**
  - Contains reusable UI elements like image caching and rendering logic.
  - Shared across multiple views to maintain consistency and reduce duplication.

- **ViewModel**
  - Manages UI state and business logic.
  - Responsibilities:
    - Fetch initial stories (10 records).
    - Implement pagination by loading more stories.
    - Manage seen/unseen status.
    - Handle like/unlike logic.
  - Publishes state for UI with defined view states:
    - `.loading`
    - `.loaded`
    - `.loadingMore`
    - `.error`
  - Uses Combine to publish changes.
  - Uses async/await to fetch data concurrently.

- **Views**
  - SwiftUI views built reactively based on ViewModel state.
  - Main views:
    - Story List View with seen/unseen indicators.
    - Story Viewer View with like/unlike and dismiss.
    - Reaction View for emojis or quick responses.
  - Includes gesture recognizers and Instagram-like animations.

---

## Concurrency and Thread Management

- Uses Swift’s **structured concurrency** (`async`/`await`) for asynchronous calls.
- `@MainActor` ensures UI updates happen safely on the main thread.
- Removes need for manual thread management like `DispatchQueue.main.async`.

---

## SOLID Principles

- **Single Responsibility Principle**
  - Network Layer fetches data.
  - Repository Layer decodes and maps data.
  - ViewModel manages business logic and state.
- **Dependency Inversion Principle**
  - High-level modules depend on protocols, not concrete implementations.
  - Promotes modularity and testability.

---

## Dependency Injection

- Uses **constructor-based dependency injection** throughout:
  - Network Layer accepts `NetworkServiceProtocol` with a default concrete implementation.
  - Repository Layer injects the network service protocol.
  - ViewModel injects repository protocol.
- Benefits:
  - Loose coupling.
  - Easy mocking for unit tests.
  - Enhances maintainability and flexibility.

---

## Testing

- **Unit Tests written for:**
  - Network Layer: Validates request execution and error handling.
  - Repository Layer: Tests JSON decoding and data mapping.
  - ViewModel: Tests state changes, pagination, and like/unlike logic.

- **Snapshot Testing**
  - Currently not included to avoid increasing dependencies.
  - Could be added later using third-party libraries with caution.

---

## Improvements and Future Enhancements

- Modularize network and repository layers into a **Swift Package Manager (SPM) package** for reusability across projects.

- Add support for **richer story content**:
  - Video stories (e.g., MP4 files).
  - Multiple images or GIFs.

- Enhance UI/UX:
  - Smooth animations and Instagram-style micro-interactions.
  - Emoji reactions and quick replies.
  - Custom story progress indicators.

- Persist seen/unseen and like/unlike states using **Core Data, Realm, or other local storage**.

- Integrate with APIs offering **richer story data** like captions, timestamps, or videos.

---

## Summary

This implementation delivers a maintainable, scalable Instagram story-like feature using SwiftUI, clean architecture, dependency injection, and modern concurrency features. With comprehensive unit testing and a solid architectural foundation, it’s primed for future enhancements toward a fully featured social media story experience.

---
