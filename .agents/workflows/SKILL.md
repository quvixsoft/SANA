---
name: SANA Flutter Project Architecture
description: Architecture patterns, folder structure, translations, reusable widgets, and layered model for the SANA Flutter app.
---

# SANA Flutter Project Architecture Skill

This document defines the architecture, conventions, and patterns used in the **SANA** Flutter application. Follow these guidelines when creating new features, screens, or modules.

---

## 1. Tech Stack

| Tool                       | Purpose                                           |
| -------------------------- | ------------------------------------------------- |
| **Flutter**                | UI framework                                      |
| **Riverpod 3.x**           | State management (`Notifier`, `NotifierProvider`) |
| **Dio**                    | HTTP client                                       |
| **GoRouter**               | Navigation (`StatefulShellRoute` for layouts)     |
| **easy_localization**      | i18n — `'key'.tr()`, `.tr(args: [...])`           |
| **flutter_dotenv**         | Environment variables (`.env`)                    |
| **flutter_secure_storage** | Secure token/credential storage                   |
| **local_auth**             | Biometric authentication                          |
| **fluttertoast / FToast**  | Toast notifications via `CustomToast`             |

---

## 2. Folder Structure

```
lib/
├── core/                         # Cross-cutting concerns
│   ├── config/
│   │   ├── constants/            # Environment variables
│   │   ├── network/              # HTTP adapters (HttpImplementer)
│   │   ├── router/               # GoRouter config (app_router.dart)
│   │   └── theme/                # AppColors, AppTextStyles, AppRadius, AppShadows
│   ├── helpers/                  # Encryption, utilities
│   └── services/                 # SecureStorageService
│
├── domain/                       # Business rules (NO framework imports)
│   ├── entities/                 # Pure Dart classes (Login, User)
│   ├── datasources/              # Abstract datasource contracts
│   └── repositories/             # Abstract repository contracts
│
├── infrastructure/               # External world implementation
│   ├── datasources/              # API implementations (AuthApiSanaDatasource)
│   ├── models/                   # DTOs with fromJson/toJson
│   ├── mappers/                  # Model → Entity converters
│   └── repositories/             # Repository implementations
│
├── presentation/                 # UI layer
│   ├── layouts/                  # AuthLayout, AppLayout (shell routes)
│   ├── providers/                # Riverpod Notifiers + State classes
│   ├── screens/                  # Screen widgets organized by feature
│   │   ├── auth/                 # login, register, forgot_password
│   │   ├── dashboard/            # home, chat, history, labs, profile
│   │   └── onboarding/
│   └── widgets/                  # Reusable UI components
│       ├── buttons/              # PrimaryButton
│       ├── form/                 # CustomTextField
│       ├── navigations/          # BottomAppBar, etc.
│       └── share/                # Shared widgets
│           ├── toast/            # CustomToast (error, success, warning, info)
│           ├── snackBar/         # CustomSnackBar (legacy, prefer CustomToast)
│           └── selector/         # Language selector
│
├── data/                         # Local data layer
└── main.dart                     # App entry point
```

---

## 3. Layered Architecture Pattern

When adding a **new feature** that calls an API, follow these steps **in order**:

### Step 1 — Domain: Entity

Create the pure Dart class in `domain/entities/`.

```dart
// domain/entities/example.dart
class Example {
  final int id;
  final String name;
  Example({required this.id, required this.name});
}
```

### Step 2 — Domain: Datasource Contract

Add the abstract method in `domain/datasources/`.

```dart
abstract class ExampleDatasource {
  Future<Example> getById(int id);
}
```

### Step 3 — Domain: Repository Contract

Mirror it in `domain/repositories/`.

```dart
abstract class ExampleRepository {
  Future<Example> getById(int id);
}
```

### Step 4 — Infrastructure: Model (DTO)

Create the model with `fromJson`/`toJson` in `infrastructure/models/`.

```dart
class ExampleModel {
  final int id;
  final String name;

  ExampleModel({required this.id, required this.name});

  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
```

### Step 5 — Infrastructure: Mapper

Convert DTO → Entity in `infrastructure/mappers/`.

```dart
class ExampleMapper {
  static Example toEntity(ExampleModel model) {
    return Example(id: model.id, name: model.name);
  }
}
```

### Step 6 — Infrastructure: Datasource Implementation

Implement the API call in `infrastructure/datasources/`.

```dart
class ExampleApiDatasource extends ExampleDatasource {
  final String connection = 'api-sana';

  @override
  Future<Example> getById(int id) async {
    try {
      final response = await HttpImplementer.get<Map<String, dynamic>>(
        connection, '/examples/$id',
      );
      final model = ExampleModel.fromJson(response.data!);
      return ExampleMapper.toEntity(model);
    } on DioException catch (e) {
      // Use translated error keys (see Section 5)
      if (e.response != null) {
        throw Exception('errors.server_error'.tr());
      }
      throw Exception('errors.connection_error'.tr());
    } catch (e) {
      throw Exception('errors.unexpected_error'.tr(args: ['$e']));
    }
  }
}
```

### Step 7 — Infrastructure: Repository Implementation

Delegate to datasource in `infrastructure/repositories/`.

```dart
class ExampleRepositoryImpl implements ExampleRepository {
  final ExampleDatasource datasource;
  ExampleRepositoryImpl(this.datasource);

  @override
  Future<Example> getById(int id) async {
    try {
      return await datasource.getById(id);
    } catch (e) {
      rethrow;
    }
  }
}
```

### Step 8 — Presentation: State

Define sealed class states in `presentation/providers/`.

```dart
sealed class ExampleState {
  const ExampleState();
}
class ExampleStateInitial extends ExampleState { const ExampleStateInitial(); }
class ExampleStateLoading extends ExampleState { const ExampleStateLoading(); }
class ExampleStateLoaded extends ExampleState {
  final Example data;
  const ExampleStateLoaded(this.data);
}
class ExampleStateError extends ExampleState {
  final String message;
  const ExampleStateError(this.message);
}
```

### Step 9 — Presentation: Provider (Notifier)

Create the Riverpod Notifier in `presentation/providers/`.

```dart
class ExampleNotifier extends Notifier<ExampleState> {
  @override
  ExampleState build() => const ExampleStateInitial();

  Future<void> load(int id) async {
    state = const ExampleStateLoading();
    try {
      final repo = ref.read(exampleRepositoryProvider);
      final result = await repo.getById(id);
      state = ExampleStateLoaded(result);
    } catch (e) {
      state = ExampleStateError(e.toString().replaceAll('Exception: ', ''));
    }
  }
}

final exampleNotifierProvider = NotifierProvider<ExampleNotifier, ExampleState>(
  () => ExampleNotifier(),
);
```

### Step 10 — Presentation: Screen

Build the screen as `ConsumerStatefulWidget` using reusable widgets.

---

## 4. Reusable Widgets

Always use these instead of raw Flutter widgets:

| Widget            | Location                                | Usage                                                       |
| ----------------- | --------------------------------------- | ----------------------------------------------------------- |
| `CustomTextField` | `widgets/form/text_field.dart`          | All form inputs (supports password toggle, validation)      |
| `PrimaryButton`   | `widgets/buttons/primary_button.dart`   | All action buttons (supports `isLoading`, `icon`, `expand`) |
| `CustomToast`     | `widgets/share/toast/custom_toast.dart` | All user feedback messages                                  |

### CustomToast Usage

```dart
import 'package:sana/presentation/widgets/share/toast/custom_toast.dart';

// Error
CustomToast.show(context: context, message: 'Error message', type: ToastType.error);

// Success
CustomToast.show(context: context, message: 'Done!', type: ToastType.success);

// Warning
CustomToast.show(context: context, message: 'Watch out', type: ToastType.warning);

// Info
CustomToast.show(context: context, message: 'FYI', type: ToastType.info);
```

> **NEVER** use `ScaffoldMessenger.showSnackBar()` or raw `Fluttertoast.showToast()` directly.

---

## 5. Translations (i18n)

### File Locations

- `assets/translations/es.json` — Spanish (fallback)
- `assets/translations/en.json` — English

### Structure

Translations are organized by **feature/screen** as nested objects:

```json
{
  "app": { ... },
  "onboarding": { ... },
  "login": { ... },
  "register": { ... },
  "forgot-password": { ... },
  "errors": { ... }
}
```

### Rules

1. **Every user-visible string** must use a translation key — no hardcoded text.
2. **Keys use dot notation**: `'login.title'.tr()`.
3. **Dynamic parameters** use `{}` placeholders: `'errors.invalid_data'.tr(args: ['$message'])`.
4. **When adding a new screen**, create a new top-level object in **both** `es.json` and `en.json`.
5. **Error messages** from datasources go in the `"errors"` object.
6. **Keep both files in sync** — always add keys to both languages simultaneously.

### Existing Error Keys

```
errors.unknown, errors.invalid_data, errors.invalid_credentials,
errors.endpoint_not_found, errors.server_error, errors.http_error,
errors.timeout, errors.connection_error, errors.network_error,
errors.unexpected_error, errors.user_already_exists,
errors.connection_error_generic
```

---

## 6. Screen Conventions

### Screen class pattern:

- Use `ConsumerStatefulWidget` (for Riverpod access)
- Define `static const String routePath` and `routeName`
- Use `_isLoading` state to disable buttons during async operations
- Handle auth state after provider calls:

```dart
final authState = ref.read(authNotifierProvider);
if (authState is AuthStateAuthenticated) {
  // Navigate
} else if (authState is AuthStateError) {
  CustomToast.show(context: context, message: authState.message, type: ToastType.error);
}
```

### Route Registration

Add routes in `core/config/router/app_router.dart`:

- Auth screens inside `AuthLayout` shell
- Dashboard screens inside `AppLayout` shell

---

## 7. Error Handling in Datasources

All datasource HTTP methods follow this pattern:

```dart
try {
  // API call
} on DioException catch (e) {
  if (e.response != null) {
    final statusCode = e.response!.statusCode;
    final message = e.response!.data['message'] ?? 'errors.unknown'.tr();
    switch (statusCode) {
      case 400: throw Exception('errors.invalid_data'.tr(args: ['$message']));
      case 401: throw Exception('errors.invalid_credentials'.tr());
      case 404: throw Exception('errors.endpoint_not_found'.tr());
      case 500: throw Exception('errors.server_error'.tr());
      default:  throw Exception('errors.http_error'.tr(args: ['$statusCode', '$message']));
    }
  } else if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
    throw Exception('errors.timeout'.tr());
  } else if (e.type == DioExceptionType.connectionError) {
    throw Exception('errors.connection_error'.tr());
  } else {
    throw Exception('errors.network_error'.tr(args: ['${e.message}']));
  }
} catch (e) {
  throw Exception('errors.unexpected_error'.tr(args: ['$e']));
}
```

---

## 8. Naming Conventions

| Type             | Convention                      | Example                                    |
| ---------------- | ------------------------------- | ------------------------------------------ |
| Files            | `snake_case`                    | `auth_api_sana_datasource.dart`            |
| Classes          | `PascalCase`                    | `AuthApiSanaDatasource`                    |
| Providers        | `camelCase` + `Provider` suffix | `authNotifierProvider`                     |
| Route paths      | `/feature/action`               | `/auth/login`                              |
| Translation keys | `feature.key_name`              | `login.email_placeholder`                  |
| Widget files     | `snake_case`                    | `custom_toast.dart`, `primary_button.dart` |

---

## 9. Backend API Connection

- Base URL configured in `.env` via `Environment` class
- HTTP client: `HttpImplementer` (wraps Dio)
- Connection name: `'api-sana'`
- Auth endpoints: `POST /auth/login`, `POST /auth/forgot-password`
- User endpoints: `POST /users` (register)
