# 🎓 Student Community Hub

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![GetX](https://img.shields.io/badge/GetX-8A2BE2?style=for-the-badge&logo=getx&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**A production-quality Flutter application for student communities.**  
Anonymous discussions, interest-based groups, and real-time posts — all powered by Firebase.

[Features](#-features) · [Screenshots](#-screenshots) · [Getting Started](#-getting-started) · [Architecture](#-architecture) · [Firebase Setup](#-firebase-setup) · [Folder Structure](#-folder-structure)

</div>

---

## 📌 Overview

**Student Community Hub** is a mobile application that enables students to:

- Register and log in securely using Firebase Authentication
- Post thoughts **anonymously** in a real-time discussion feed
- Filter posts by **interest categories** (Technology, Career, Study Abroad, General Discussion)
- Manage their **profile and interests**
- Enjoy a **modern, recruiter-ready UI** built with Material 3, Google Fonts, and GetX

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔐 Authentication | Email/Password Register & Login via Firebase Auth |
| 👤 Anonymous Posts | Every post appears as "Anonymous Student" |
| 🗂️ Category Filter | Filter feed by Technology, Career, Study Abroad, General |
| 🔄 Real-time Feed | Firestore stream — posts appear instantly across devices |
| 👁️ Profile Management | Edit name, update interests, view account info |
| 📱 Beautiful UI | Material 3, Poppins + DM Sans fonts, shimmer loading, empty states |
| ✅ Form Validation | All inputs validated with meaningful error messages |
| 💬 GetX Snackbars | Contextual feedback for every user action |
| 🧩 Clean Architecture | Service → Repository → Controller → View |

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.0.0`
- [Dart SDK](https://dart.dev/get-dart) `>=3.0.0`
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- A [Firebase project](https://console.firebase.google.com/) (free Spark plan works)

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/yourusername/student_community_hub.git
cd student_community_hub
```

**2. Install Flutter dependencies**

```bash
flutter pub get
```

**3. Configure Firebase** *(see [Firebase Setup](#-firebase-setup) below)*

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

**4. Create the assets folder**

```bash
mkdir -p assets/images
```

**5. Run the app**

```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

---

## 🔥 Firebase Setup

### Step 1 — Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter project name: `student-community-hub`
4. Disable Google Analytics (optional) → **Create project**

### Step 2 — Enable Authentication

1. In Firebase Console → **Authentication** → **Get Started**
2. Click **Sign-in method** tab
3. Enable **Email/Password** → **Save**

### Step 3 — Create Firestore Database

1. Firebase Console → **Firestore Database** → **Create database**
2. Choose **"Start in test mode"** (for development)
3. Select a Cloud Firestore location → **Enable**

### Step 4 — Add Apps to Firebase

**For Android:**
1. Firebase Console → Project Overview → **Add app** → Android icon
2. Android package name: `com.example.student_community_hub`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

**For iOS:**
1. Firebase Console → **Add app** → iOS icon
2. iOS bundle ID: `com.example.studentCommunityHub`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

### Step 5 — Auto-generate firebase_options.dart

```bash
# Install FlutterFire CLI (one-time)
dart pub global activate flutterfire_cli

# Run from project root — auto-configures all platforms
flutterfire configure
```

This replaces the placeholder `lib/firebase_options.dart` with your real credentials.

### Step 6 — Firestore Security Rules

In Firebase Console → **Firestore Database** → **Rules**, replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users — only the owner can read/write their own document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Posts — any authenticated user can read/create;
    //          only the author can delete their post
    match /posts/{postId} {
      allow read:   if request.auth != null;
      allow create: if request.auth != null
                    && request.resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null
                    && resource.data.userId == request.auth.uid;
    }
  }
}
```

Click **Publish**.

### Firestore Data Structure

```
Firestore
├── users/
│   └── {uid}/
│       ├── uid:        "firebase-uid-string"
│       ├── name:       "Student Name"
│       ├── email:      "student@email.com"
│       ├── interests:  ["Technology", "Career"]
│       └── createdAt:  "timestamp"
│
└── posts/
    └── {postId}/
        ├── postId:     "auto-generated-id"
        ├── content:    "Post content"
        ├── category:   "Career"
        ├── timestamp:  Timestamp (server)
        └── userId:     "firebase-uid-string"
```

---

## 📁 Folder Structure

```
lib/
│
├── main.dart                            # Entry point, Firebase init, DI setup
├── firebase_options.dart                # Auto-generated by FlutterFire CLI
│
├── app/
│   ├── routes/
│   │   ├── app_routes.dart              # Route name constants
│   │   └── app_pages.dart              # GetPage list with bindings
│   │
│   ├── theme/
│   │   ├── app_colors.dart             # Color palette (primary, semantic, category)
│   │   ├── app_theme.dart              # Material 3 ThemeData configuration
│   │   └── text_styles.dart            # Syne + DM Sans + DM Mono text styles
│   │
│   └── constants/
│       └── app_constants.dart          # Categories, strings, dimensions
│
├── data/
│   ├── models/
│   │   ├── user_model.dart             # UserModel: uid, name, email, interests
│   │   └── post_model.dart             # PostModel: postId, content, category, timestamp
│   │
│   ├── services/
│   │   ├── auth_service.dart           # Firebase Auth wrapper
│   │   └── firestore_service.dart      # Firestore CRUD + streams
│   │
│   └── repositories/
│       ├── auth_repository.dart        # Register, login, logout, fetchUser
│       └── post_repository.dart        # createPost, getAllPosts, filterByCategory
│
├── modules/
│   ├── splash/
│   │   ├── controllers/splash_controller.dart    # Auth check + redirect
│   │   ├── views/splash_view.dart                # Gradient splash with progress
│   │   └── bindings/splash_binding.dart
│   │
│   ├── auth/
│   │   ├── controllers/auth_controller.dart      # Login + register logic + validation
│   │   ├── views/auth_view.dart                  # Tabbed login/register screen
│   │   └── bindings/auth_binding.dart
│   │
│   ├── home/
│   │   ├── controllers/home_controller.dart      # Tab management, post stream, filter
│   │   ├── views/home_view.dart                  # Bottom nav shell (IndexedStack)
│   │   ├── views/feed_view.dart                  # Header, chips, post list
│   │   └── bindings/home_binding.dart
│   │
│   ├── create_post/
│   │   ├── controllers/create_post_controller.dart  # Post submission + char count
│   │   ├── views/create_post_view.dart               # Anonymous banner + form
│   │   └── bindings/create_post_binding.dart
│   │
│   └── profile/
│       ├── controllers/profile_controller.dart   # Load user, edit interests, logout
│       ├── views/profile_view.dart               # Avatar, stats, interests, actions
│       └── bindings/profile_binding.dart
│
└── widgets/
    ├── custom_button.dart        # Primary / outlined / danger variants + loading
    ├── custom_textfield.dart     # Labelled input with prefix icon + validation
    ├── category_chip.dart        # Animated selected/unselected chip with emoji
    ├── post_card.dart            # Anonymous post card with category pill
    ├── loading_widget.dart       # Shimmer skeleton for feed loading
    └── empty_state_widget.dart   # Illustrated empty state with optional CTA
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management & Navigation
  get: ^4.6.6

  # Firebase
  firebase_core: ^3.3.0
  firebase_auth: ^5.1.2
  cloud_firestore: ^5.2.1
  firebase_analytics: ^11.2.1

  # Google Fonts
  google_fonts: ^6.2.1          # Syne, DM Sans, DM Mono

  # Utilities
  intl: ^0.19.0                 # Date formatting
  uuid: ^4.4.0                  # Unique post IDs
```

---
