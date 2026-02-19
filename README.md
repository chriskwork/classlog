# classlog

> Student learning tracker for attendance, grades,
> and course management
> Final project for the Multiplatform Application Development (DAM) course.

> Sistema de seguimiento académico para estudiantes.
> Último proyecto para la asignatura de DAM.

# Aprendizajes del Proceso de Desarrollo

Por primera vez, he creado una aplicación Flutter que se comunica con un backend a través de la API de FacturaScripts, integrando múltiples pantallas.

Inicialmente, planifiqué crear una aplicación para que los estudiantes gestionaran su asistencia, exámenes, entregas de tareas y otros estados. Después de esbozar las funcionalidades y diseñar la interfaz, comencé el desarrollo. Sin embargo, mientras trabajaba, surgieron decisiones como "esta función no es esencial, la agregaré después" o "sería bueno tener esto", lo que hizo que el plan inicial se desviara. Con el tiempo, perdí la visión general del proyecto y terminé trabajando de manera improvisada, resultando en código innecesariamente extenso y complejo.

Por ejemplo, inicialmente pasaba el estado entre widgets, pero a medida que aumentaron las pantallas y las solicitudes repetidas del ID de usuario, decidí refactorizar usando Riverpod, lo que consumió mucho tiempo. Además, al implementar el dashboard antes que el login, la API se volvió inestable. Hacia el final, solo me enfocaba en resolver errores inmediatos. A través de esta experiencia aprendí que **no invertir suficiente tiempo en la fase de diseño antes de codificar resulta en costos mucho mayores después**.

Debo admitir que, debido a circunstancias personales y falta de tiempo disponible, habría sido imposible completar este proyecto sin utilizar IA. Dependí bastante de ella en muchas partes. Sin embargo, al analizar el código repetidamente, pude aprender aspectos importantes como:

- El flujo completo de funcionamiento de la aplicación
- El uso de dependencias y widgets que desconocía anteriormente
- Cómo instalar un backend en un servidor de hosting real (Hostinger) e integrarlo mediante API
- Cómo separar y almacenar el estado, compartiendo datos entre widgets en la jerarquía inferior
- El uso de almacenamiento local
- Cómo compilar la aplicación para web, probarla y desplegarla en GitHub, entre otros

Gracias a esto, aprendí muchas cosas nuevas que no hubiera podido descubrir por mí solo, ampliando significativamente mi base de conocimientos.

==============================

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

| Pestaña | Pantalla        |
| ------- | --------------- |
| 0       | DashboardScreen |
| 1       | CalendarScreen  |
| 2       | MyCoursesScreen |
| 3       | ConfigScreen    |

### 3. Dashboard (`features/dashboard/`)

Un `FutureProvider.autoDispose` llama a `cl-student?action=dashboard&id={userId}` y devuelve un `AsyncValue` con tres estados:

- `loading` → indicador de carga
- `error` → mensaje + botón de reintento
- `data` → horario de hoy, estadísticas de asistencia y próximos eventos

### 4. Comunicación con la API (`shared/network/api_service.dart`)

`ApiService` usa el patrón **Singleton**: una sola instancia en toda la app. Lee `API_URL` y `API_KEY` del `.env` y añade el token en la cabecera de cada petición GET/POST.

---

## Gestión de Estado con Riverpod

| Tipo                         | Uso                                                        |
| ---------------------------- | ---------------------------------------------------------- |
| `NotifierProvider`           | `authProvider` – login, logout, estado de sesión           |
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
