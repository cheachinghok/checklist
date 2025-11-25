# Checklist App

A modern Flutter checklist application with task management, prioritization, and analytics dashboard.

## Features

- ✅ Create, edit, and delete tasks
- 🎯 Set task priorities (Low, Medium, High)
- 📊 Personal dashboard with completion analytics
- 🔄 Drag & drop reordering
- 🏷️ Filter and sort tasks
- 📱 Modern Material Design 3 UI
- 💾 Local data persistence

## Tech Stack

- **Flutter** 3.16.0+
- **BLoC** for state management
- **Hive** for local storage
- **Fl Chart** for data visualization
- **Mocktail** for testing

## Getting Started

### Prerequisites

- Flutter SDK 3.16.0 or later
- Dart 3.0.0 or later

### Installation

1. Clone the repository
```bash
git clone https://github.com/your-username/checklist_app.git
cd checklist_app

# Run all test in a directory
flutter test

# Run unit tests in a directory
flutter test test/feature/task_bloc_test.dart