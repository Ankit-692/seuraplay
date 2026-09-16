# SeuraPlay

SeuraPlay is a modern TV Show and Movie tracker built with Flutter. It allows you to track your favorite shows, discover upcoming movies, maintain a personalized library, and keep your data safe with Google Drive backups.

## Screenshots
*(Screenshots will be added here soon)*

## Features
* **Track TV Shows & Movies**: Keep a detailed log of your watched shows, movies, and current progress.
* **Personalized Library**: Organize what you want to watch and what you have already finished.
* **Google Drive Backup & Restore**: Securely backup your local library to your personal Google Drive (using the restricted `drive.appdata` scope) so you never lose your data across devices.
* **Dark Mode First**: Beautiful, custom dark theme designed for optimal viewing.
* **Background Sync**: Automated background workers to keep your library and metadata up to date.

## Tech Stack
* **Framework**: [Flutter](https://flutter.dev/) (Dart)
* **State Management**: [Riverpod](https://riverpod.dev/) (`flutter_riverpod`, `riverpod_annotation`)
* **Local Database**: [Drift](https://drift.simonbinder.eu/) (SQLite)
* **Networking**: [Dio](https://pub.dev/packages/dio) & [HTTP](https://pub.dev/packages/http)
* **Cloud Backup**: `googleapis` (Google Drive AppData API)
* **Authentication**: `google_sign_in`

## Installation (For Users)
The easiest way to use SeuraPlay is to download the compiled application:
1. Go to the [Releases page](#) *(link will be added soon when the APK is uploaded)*.
2. Download the latest `.apk` file.
3. Install it on your Android device and enjoy!

## Build from Source (For Developers)
If you want to build the project yourself or contribute to the code:

### Prerequisites
- Flutter SDK (v3.12.2 or higher)
- Android Studio / Xcode
- A Google Cloud Platform (GCP) project with the Google Drive API and Google Sign-in enabled.

### Steps
1. **Clone the repository**
   ```bash
   git clone https://github.com/Ankit-692/seuraplay.git
   cd seuraplay
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Google Sign-In**
   To enable Google Drive backups, you need a Google OAuth Client ID. 
   When building or running the app, pass your Web Client ID as a dart environment variable:
   ```bash
   flutter run --dart-define=WEB_CLIENT_ID=your_client_id.apps.googleusercontent.com
   ```

## Privacy
Your data belongs to you. SeuraPlay does not collect personal information or use tracking analytics. Database backups are strictly stored in your personal Google Drive account's hidden AppData folder. For more information, please read our [Privacy Policy](PRIVACY_POLICY.md).

## License
This project is provided under a **Non-Commercial License** (Creative Commons Attribution-NonCommercial 4.0 International or similar). 

You are completely free to:
* **Download** the code and application.
* **Modify** the codebase to suit your needs.
* **Share** and distribute the code for personal or educational purposes.

You **cannot**:
* Use this code, the application, or any of its derivatives for **commercial purposes**.