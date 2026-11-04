# Authify: Flutter Login & Registration Module

A functional, secure, and responsive authentication module built with Flutter & Dart, following Clean Architecture, Provider state management, and modern UI/UX design standards.

---

## 🎥 Live Demonstration & Screen Recording

- **Release APK**: [Download app-release.apk (44.9 MB) on Google Drive](https://drive.google.com/file/d/1ftPdkT6_OI_FFAmJ1U1Lzoe-BFebiCXT/view?usp=drivesdk)
- **Google Drive Folder**: [Flutter-Login-Registration-Demo](https://drive.google.com/drive/folders/1kXZM0iNdsdBe81k1ElYlWnq_X88B8I6G)
- **Direct Video Stream**: [demo_recording.mp4 on Google Drive](https://drive.google.com/file/d/1OYaj5_t2nDIaN6rctgSc2TlwbynuaApu/view?usp=drivesdk)
- **Local Assets**: All video and screenshot files are stored in [`screenshots/`](./screenshots/).

---

## 🌟 Key Features

### 1. Login Screen
- **Flexible Identifier**: Enter either an **Email address** or a **Mobile phone number**.
- **Password Input**: Secure password input with a real-time **Show/Hide password toggle**.
- **Remember Me Option**: Persists the user's login preference across sessions via `SharedPreferences`.
- **Forgot Password Workflow**: Modal dialog allowing password reset requests with simulated feedback.
- **Loading State**: Primary action button transitions smoothly into an inline loading indicator while authenticating.
- **Quick Demo Autofill**: One-click autofill banner to instantly populate valid seeded demo credentials for reviewers.

### 2. Registration Screen
- **Comprehensive Fields**: Full Name, Email Address, Mobile Phone Number, Password, and Confirm Password.
- **Dynamic Password Strength Checklist**: Real-time visual feedback checklist monitoring:
  - Minimum 8 characters
  - At least 1 uppercase letter (`A-Z`)
  - At least 1 lowercase letter (`a-z`)
  - At least 1 numeric digit (`0-9`)
  - At least 1 special character (`!@#$%^&*...`)
- **Matching Passwords Validation**: Real-time equality checking between password and confirmation fields.
- **Loading State & Error Feedback**: Displays clear animated error banners or success notifications upon submission.

### 3. Responsive & Adaptive UI
- **Mobile Phones (< 600px)**: Compact, single-column scrollable layout with touch-friendly controls (minimum 48dp tap targets) and zero keyboard overflow issues.
- **Tablets & Medium Screens (600px - 899px)**: Centered, elevated card layout constrained to an optimal reading width (`460px`).
- **Desktop & Widescreen (>= 900px)**: Modern side-by-side split-screen layout featuring a branded gradient hero banner on the left and form controls on the right.

### 4. State Management (Provider)
- Clean separation of business logic from UI using `AuthProvider` (`ChangeNotifier`).
- Handles reactive loading states, error messaging, password visibility toggles, and session lifecycle.

### 5. Mock API & Service Layer
- `AuthServiceInterface` defines an abstract contract for authentication operations.
- `MockAuthService` simulates real-world network latency (1.2 seconds), credential verification, duplicate user detection, token generation, and session caching.

---

## 🔑 Demo Credentials

To test the application immediately, you can either click the **Autofill** button on the Login screen or manually enter:

| Field | Seeded Demo Value |
| :--- | :--- |
| **Email Identifier** | `user@example.com` |
| **Mobile Identifier** | `0771234567` |
| **Password** | `Pass@1234` |

---

## 🏗️ Architecture & Project Structure

The project follows clean architecture principles, keeping data, business logic, presentation, and design tokens strictly decoupled:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Material 3 color system (brand, neutrals, states)
│   │   ├── app_strings.dart        # Centralized UI copy & error messages
│   │   └── breakpoints.dart        # Responsive width thresholds (600px, 900px)
│   ├── theme/
│   │   └── app_theme.dart          # M3 light theme, button styles, input borders
│   └── utils/
│       └── validators.dart         # Email, phone, name, password & match validators
├── models/
│   ├── user_model.dart             # User profile entity with JSON serialization
│   └── auth_response.dart          # Structured API response envelope
├── services/
│   ├── auth_service_interface.dart # Abstract contract for authentication service
│   └── mock_auth_service.dart      # Mock backend simulation with delay & error scenarios
├── providers/
│   └── auth_provider.dart          # State management via ChangeNotifier (Provider)
├── widgets/
│   ├── custom_text_field.dart      # Reusable text field with validation, toggle & autofill
│   ├── custom_button.dart          # Elevated & outlined button with loading indicator
│   ├── auth_header.dart            # Branded header icon, title & subtitle
│   ├── password_requirements.dart  # Interactive live password checklist widget
│   ├── responsive_auth_layout.dart # Adaptive split / centered / mobile container
│   └── feedback_snackbar.dart      # Floating success and error feedback banners
├── screens/
│   ├── login_screen.dart           # Login form with email/mobile, remember me & forgot pass
│   ├── register_screen.dart        # Register form with validation & live password indicator
│   ├── forgot_password_dialog.dart # Password reset request modal dialog
│   └── home_screen.dart            # Authenticated user dashboard & sign-out
└── main.dart                       # App entry point, MultiProvider & route definitions
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version `>=3.10.0` or later)
- Dart SDK (version `>=3.0.0`)

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/sandun-synotec/Flutter-Login-Registration-Module.git
   cd Flutter-Login-Registration-Module
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on your preferred platform**:
   - **Chrome / Web**:
     ```bash
     flutter run -d chrome
     ```
   - **Android / iOS**:
     ```bash
     flutter run
     ```
   - **Windows / Desktop**:
     ```bash
     flutter run -d windows
     ```

---

## 🧪 Testing

The codebase includes comprehensive unit and widget tests covering all validators, authentication services, provider state flows, and screen interactions:

```bash
# Run all unit and widget tests
flutter test

# Verify code analysis
flutter analyze

# Verify code formatting
dart format --output=none --set-exit-if-changed .
```

### Test Coverage Highlights:
- **Validators Test (`test/unit/validators_test.dart`)**: Strict email validation, international mobile phone formats, Unicode full names, individual password rules, and confirm password matching.
- **Mock Auth Service Test (`test/unit/mock_auth_service_test.dart`)**: Success scenarios, wrong password, non-existent user, duplicate registration rejection, and remember-me persistence.
- **Auth Provider Test (`test/unit/auth_provider_test.dart`)**: Authentication lifecycle, state notifications, password visibility toggles, and logout cleanup.
- **Login Screen Test (`test/widget/login_screen_test.dart`)**: UI rendering, input validation, show/hide password toggle, demo autofill, and forgot-password dialog.
- **Register Screen Test (`test/widget/register_screen_test.dart`)**: Field rendering, dynamic password rules checklist, password mismatch detection, and successful registration navigation.

---

## 📋 Acceptance Criteria Verification

| Requirement | Implementation Details | Status |
| :--- | :--- | :---: |
| **All input fields must be validated** | Custom validators for email/phone, password strength, matching passwords, and full name. | ✅ |
| **UI must work on different screen sizes** | `ResponsiveAuthLayout` adapts to mobile (<600px), tablet (600-899px), and desktop (>=900px). | ✅ |
| **No major UI overflow issues** | Scrollable containers, adaptive `Wrap` rows, and `Text.rich` prevent any RenderFlex overflow. | ✅ |
| **Navigation must work correctly** | Named routes (`/login`, `/register`, `/home`) with clean transitions and session logout. | ✅ |
| **Provider State Management** | Centralized `AuthProvider` handling loading, authentication state, and visibility toggles. | ✅ |
| **Code must be readable and reusable** | Clean layered architecture separating UI, Models, Services, and Providers. | ✅ |
| **Application must run without critical errors** | 42 unit and widget tests pass, 0 static analysis errors (`flutter analyze`). | ✅ |

---

## 📄 License
This project is licensed under the MIT License.
