# 🎓 ParikshaPrep — Government Exam Preparation Platform

> A modern, scalable, and feature-rich Flutter application designed to provide a unified digital learning experience for government exam aspirants.

ParikshaPrep is a comprehensive **exam preparation and e-learning platform** built with Flutter. The application provides students with an organized ecosystem for discovering courses, accessing learning materials, attending live classes, practicing through mock tests and daily quizzes, tracking their learning journey, and staying updated with current affairs.

The project follows a clean, modular, and feature-driven architecture to ensure maintainability, scalability, and a smooth user experience.

---

## ✨ Features

### 🔐 Authentication & Onboarding

* Splash screen experience
* User login
* User registration
* Personalized exam onboarding
* Structured application entry flow

### 🏠 Smart Home Experience

* Personalized learning dashboard
* Course discovery
* Exam-based learning exploration
* Global search functionality
* Quick access to important learning resources

### 📚 Learning Management

* My Learning dashboard
* Course details and learning content
* Video learning experience
* Notes viewer
* Downloadable study materials
* Learning progress tracking

### 🎓 Courses & Exams

* Course discovery
* Exam-specific content
* Detailed course information
* Free courses
* Structured learning journeys

### 🔴 Live Learning

* Live classes section
* Access to ongoing and upcoming learning sessions
* Integrated live learning workflow

### 📝 Tests & Practice

* Test series
* Mock test engine
* Test attempt management
* Test results
* Daily quizzes
* Practice-focused learning experience

### 📰 Current Affairs

* Dedicated current affairs section
* Easy access to relevant educational updates
* Integrated learning and awareness experience

### 👤 Student Profile

* User profile
* Certificates
* Bookmarks
* Notifications
* Application settings

---

# 🏗️ Architecture

The application follows a **feature-based modular architecture**, separating business domains and shared application components.

```text
lib/
│
├── core/
│   ├── constants/
│   ├── models/
│   ├── repositories/
│   ├── routing/
│   ├── services/
│   ├── theme/
│   └── widgets/
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── courses/
│   ├── learning/
│   ├── live/
│   ├── tests/
│   ├── current_affairs/
│   ├── profile/
│   └── navigation/
│
└── main.dart
```

This architecture helps maintain:

* Separation of concerns
* Code reusability
* Feature scalability
* Easier testing and maintenance
* Cleaner project organization

---

# 🛠️ Tech Stack

| Technology         | Purpose                                |
| ------------------ | -------------------------------------- |
| Flutter            | Cross-platform application development |
| Dart               | Application programming language       |
| Riverpod           | State management                       |
| GoRouter           | Declarative navigation and routing     |
| Shared Preferences | Local data persistence                 |
| Google Fonts       | Typography                             |
| Flutter Animate    | UI animations                          |
| FL Chart           | Data visualization                     |
| Percent Indicator  | Progress visualization                 |
| Path Provider      | File and storage access                |

---

# 🧭 Navigation Architecture

The application uses **GoRouter** for scalable and structured navigation.

The main application experience includes a persistent bottom navigation system with four primary sections:

```text
🏠 Home
📚 My Learning
🔴 Live
👤 Profile
```

Additional routes support the complete learning ecosystem, including:

* Authentication
* Course discovery
* Course details
* Exam details
* Video learning
* Notes
* Downloads
* Mock tests
* Test results
* Daily quizzes
* Current affairs
* Certificates
* Bookmarks
* Notifications
* Settings

---

# 🎨 Design System

The application uses centralized design components for consistency across the platform.

The shared design system includes:

* Application color configuration
* Typography styles
* Centralized theme configuration
* Custom scroll behavior
* Reusable UI components

Reusable widgets include:

* Course cards
* Exam cards
* Test cards
* Live class cards
* Section headers
* Custom buttons
* Custom text fields
* Loading skeletons
* Empty state components
* Badge widgets

This approach improves UI consistency and reduces duplicated code.

---

# 📦 Core Domain Models

The application is structured around reusable domain models, including:

* Course Model
* User Model
* Exam Model
* Test Model
* Live Class Model
* Certificate Model
* Notification Model
* Current Affairs Model

These models provide a scalable foundation for future backend and API integration.

---

# 🚀 Getting Started

## Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or Xcode
* An Android Emulator or physical device

Verify your Flutter installation:

```bash
flutter doctor
```

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/vijayg3063/exam_prep.git
```

### 2. Navigate to the project directory

```bash
cd exam_prep
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```

---

# 📱 Supported Platforms

Flutter enables the application to support multiple platforms, including:

* Android
* iOS
* Web
* macOS
* Windows
* Linux

---

# 🔮 Future Improvements

The current architecture is designed to support future enhancements such as:

* 🔥 Firebase authentication
* ☁️ Cloud database integration
* 🌐 REST API integration
* 🎥 Real-time live classes
* 🤖 AI-powered personalized learning recommendations
* 📊 Advanced performance analytics
* 🧠 Adaptive mock tests
* 🏆 Gamification and achievements
* 📈 Personalized learning insights
* 🔔 Push notifications
* 💳 Course payments and subscriptions
* 📥 Offline learning support

---

# 🎯 Project Vision

The goal of ParikshaPrep is to build a centralized digital learning ecosystem where government exam aspirants can:

> **Learn. Practice. Analyze. Improve. Succeed.**

By combining structured courses, live learning, practice tests, current affairs, and progress tracking into one platform, ParikshaPrep aims to provide a modern and engaging learning experience for competitive exam preparation.

---

# 👨‍💻 Developer

**Vijay Gurjar**

Flutter Developer | Full-Stack Developer | AI Enthusiast

---

## ⭐ Support

If you found this project useful, consider giving the repository a **⭐ Star**.

It helps motivate continued development and future improvements.

---

### Built with ❤️ using Flutter




