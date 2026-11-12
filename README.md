# lastname_navigation_app

Flutter activity: StatefulWidget and Bottom Navigation.

## Setup

```bash
flutter create lastname_navigation_app
cd lastname_navigation_app
```

Replace the generated `lib/` folder with the `lib/` folder from this project, then:

```bash
flutter pub get
flutter run
```

Default login: `admin` / `admin123`

## Structure

```
lastname_navigation_app/
├── README.md
└── lib/
    ├── main.dart                         # Entry point, theme, starts at LoginScreen
    ├── services/
    │   └── demo_auth.dart                # In-memory demo authentication
    ├── widgets/                          # Reusable UI components
    │   ├── app_text_field.dart
    │   ├── auth_header.dart
    │   ├── info_tile.dart
    │   ├── operator_button.dart
    │   ├── profile_header.dart
    │   ├── result_card.dart
    │   └── social_account_card.dart
    └── screens/
        ├── main_screen.dart              # NavigationBar + IndexedStack (keeps tab state)
        ├── auth/
        │   ├── login_screen.dart
        │   └── register_screen.dart
        └── tabs/
            ├── home_page.dart
            ├── calculator_screen.dart
            ├── profile_page.dart         # edit the TODO placeholders
            └── social_media_page.dart
```