# 🗓️ Calendar App

This repository contains the source code for a **Calendar App**, built using **Flutter**. The app offers a simple and intuitive calendar interface, integrated with Firebase for data storage and synchronization.

## 📅 Features
- **📒 Event Creation & Management**: Add, edit, and delete events seamlessly.
- **💾 Firebase Integration**: Sync event data across devices.
- **🔐 User Authentication**: Secure login and registration.
- **📢 Notifications**: Set reminders for events.
- **💻 Responsive UI**: Compatible with Android and iOS.

---

## 📚 Getting Started

### 🛠️ Prerequisites
Ensure you have the following installed:
- 💻 Flutter SDK (version 3.0+)
- 📝 Dart SDK
- 📺 Android Studio or Visual Studio Code with Flutter extensions
- 💡 Firebase CLI (for backend integration)

### 🔄 Installation Steps
1. **🔄 Clone the repository**:
   ```bash
   git clone https://github.com/username/Calendar_BOA.git
   cd Calendar_BOA-main/calendar
   ```
2. **📁 Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **📃 Configure Firebase**:
   - Add your Firebase project configuration in `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`.
   - Ensure Firebase authentication and Firestore database are enabled.
4. **💾 Run the application**:
   ```bash
   flutter run
   ```

---

## 📂 Firebase Setup
1. Log in to Firebase console and create a new project.
2. Register your app and download the `google-services.json` and `GoogleService-Info.plist`.
3. Replace the files in the respective directories (`android/app/` and `ios/Runner/`).
4. Enable Firestore and Authentication in Firebase.

---

## 📁 Folder Structure
```
calendar/
  ├── lib/                   # Application code
  │   ├── models/            # Data models
  │   ├── screens/           # UI screens
  │   ├── services/          # Firebase services
  │   ├── widgets/           # Reusable widgets
  ├── android/               # Android specific code
  ├── ios/                   # iOS specific code
  ├── pubspec.yaml           # Dependency manager
  └── README.md              # Documentation
```

---

## 💼 Contributing
Contributions are welcome! Feel free to submit a pull request or open an issue.

---

## 📄 License
This project is licensed under the [MIT License](LICENSE).

