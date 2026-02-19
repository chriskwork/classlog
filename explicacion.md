# ClassLog – Explicación del Proyecto

## Descripción General

ClassLog es una aplicación móvil desarrollada con **Flutter** para la gestión de estudiantes.

- **Estado**: Riverpod
- **Red**: paquete `http`
- **Almacenamiento local**: SharedPreferences
- **Arquitectura**: Feature-first (módulos por funcionalidad)

---

## Flujo Principal

```
Inicio (main.dart)
  → Inicializa SharedPreferences y carga variables de entorno (.env)
  → Lanza la app con ProviderScope (Riverpod)
  → AuthWrapper comprueba si hay sesión guardada
      ├─ Hay sesión  → HomeScreen
      └─ No hay sesión → LoginScreen
```

---

## Módulos Principales

### 1. Autenticación (`features/auth/`)

- **AuthWrapper**: Al arrancar, lee `user_data` de SharedPreferences. Si existe, navega a HomeScreen; si no, a LoginScreen.
- **Login**: Envía email y contraseña al endpoint `cl-auth` mediante POST. Si la respuesta es `success: true`, guarda el usuario en SharedPreferences y actualiza el estado global.
- **Logout**: Elimina `user_data` de SharedPreferences y resetea el estado.

### 2. Pantalla principal (`app/home_screen.dart`)

Usa `IndexedStack` con `BottomNavigationBar` para mantener el estado de las 4 pestañas sin destruirlas al cambiar:

| Pestaña | Pantalla |
|---|---|
| 0 | DashboardScreen |
| 1 | CalendarScreen |
| 2 | MyCoursesScreen |
| 3 | ConfigScreen |

### 3. Dashboard (`features/dashboard/`)

Un `FutureProvider.autoDispose` llama a `cl-student?action=dashboard&id={userId}` y devuelve un `AsyncValue` con tres estados:
- `loading` → indicador de carga
- `error` → mensaje + botón de reintento
- `data` → horario de hoy, estadísticas de asistencia y próximos eventos

### 4. Comunicación con la API (`shared/network/api_service.dart`)

`ApiService` usa el patrón **Singleton**: una sola instancia en toda la app. Lee `API_URL` y `API_KEY` del `.env` y añade el token en la cabecera de cada petición GET/POST.

---

## Gestión de Estado con Riverpod

| Tipo | Uso |
|---|---|
| `NotifierProvider` | `authProvider` – login, logout, estado de sesión |
| `FutureProvider.autoDispose` | `dashboardProvider`, `coursesProvider`, `calendarProvider` |

- `ref.watch()` → suscribe el widget al provider (se reconstruye al cambiar)
- `ref.read()` → lectura puntual sin suscripción (usado en eventos)
- `ref.invalidate()` → fuerza la recarga del provider

---

## Estructura de Carpetas

```
lib/
├── main.dart
├── app/
│   ├── theme/
│   └── home_screen.dart
├── features/
│   ├── auth/         (provider, screens, widgets)
│   ├── dashboard/    (provider, models, screens, widgets)
│   ├── calendar/
│   ├── courses/
│   └── config/
└── shared/
    ├── models/
    ├── network/      (api_service.dart)
    ├── widgets/
    └── constants/
```

---

## Decisiones de Diseño

- **Singleton en ApiService**: evita múltiples instancias y centraliza la configuración de red.
- **IndexedStack**: conserva el estado de cada pestaña (posición de scroll, datos cargados) sin recrear los widgets.
- **FutureProvider.autoDispose**: libera memoria al salir de la pantalla y garantiza datos frescos al volver.
- **SharedPreferences**: persiste la sesión del usuario entre reinicios de la app.
