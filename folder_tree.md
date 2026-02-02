lib/
├── main.dart
├── app/
│ ├── home_screen.dart
│ └── theme/
│ ├── app_colors.dart
│ ├── app_spacing.dart ← (app_settings.dart)
│ └── app_theme.dart ← (theme_style.dart)
├── features/
│ ├── auth/
│ │ ├── provider/auth_provider.dart
│ │ ├── screens/
│ │ │ ├── login_screen.dart
│ │ │ └── register_screen.dart
│ │ └── widgets/auth_wrapper.dart
│ ├── dashboard/
│ │ ├── provider/dashboard_provider.dart
│ │ ├── screens/dashboard_screen.dart
│ │ ├── models/dashboard_res.dart
│ │ └── widgets/circular_percentage.dart
│ ├── calendar/
│ │ ├── provider/calendar_provider.dart
│ │ ├── screens/calendar_screen.dart
│ │ └── models/calendar_event.dart
│ ├── courses/
│ │ ├── provider/courses_provider.dart
│ │ ├── screens/my_courses_screen.dart
│ │ ├── models/course.dart
│ │ └── widgets/course_detail_sheet.dart
│ └── config/
│ └── screens/
│ ├── config_screen.dart
│ ├── config_edit_profile.dart
│ └── config_security.dart
└── shared/
├── models/user.dart
├── network/api_service.dart
├── widgets/
│ ├── course_card.dart
│ ├── custom_form_field.dart
│ └── role_toggle_btn.dart
└── constants/
├── app_decorations.dart
├── appbar_notification.dart
├── bottom_navbar.dart
└── custom_appbar.dart
