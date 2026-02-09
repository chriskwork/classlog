# ClassLog 앱 전체 워크플로우

## 🚀 프로젝트 개요

ClassLog는 Flutter로 개발된 학생 관리 앱입니다.
- **상태관리**: Riverpod
- **HTTP 통신**: http 패키지
- **로컬 저장소**: SharedPreferences
- **아키텍처**: Feature-first 구조

---

## 1️⃣ 앱 시작 (main.dart)

### 실행 흐름
```
앱 실행
  ↓
main() 함수 실행
  ↓
SharedPreferences 초기화 (로컬 저장소 준비)
  ↓
.env 파일 로드 (API URL, API KEY)
  ↓
ProviderScope로 앱 감싸기 (Riverpod 상태관리 시작)
  ↓
ClassLogApp 실행
  ↓
AuthWrapper로 이동 (인증 체크)
```

### 코드 설명
**lib/main.dart:10-21**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences 초기화
  await SharedPreferences.getInstance();

  // .env 파일 로드 (API_URL, API_KEY 등)
  await dotenv.load(fileName: ".env");

  // Riverpod으로 앱 전체 상태관리 시작
  runApp(const ProviderScope(
    child: ClassLogApp(),
  ));
}
```

### 주요 설정
- **ResponsiveApp**: 웹용 최대 너비를 600px로 제한
- **테마 설정**: 색상, 폰트, 버튼 스타일 등 모두 여기서 적용
- **초기 화면**: AuthWrapper (인증 상태에 따라 화면 분기)

---

## 2️⃣ 인증 확인 (AuthWrapper)

### 실행 흐름
```
AuthWrapper 시작
  ↓
authProvider 감시 시작
  ↓
AuthProvider의 build() 메서드 자동 실행
  ↓
_checkAuth() 실행
  ↓
SharedPreferences에서 'user_data' 찾기
  ↓
경우 1: 저장된 유저 있음 → HomeScreen으로
경우 2: 저장된 유저 없음 → LoginScreen으로
경우 3: 로딩 중 → CircularProgressIndicator 표시
```

### 코드 설명
**lib/features/auth/widgets/auth_wrapper.dart**
```dart
class AuthWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider); // 상태 감시

    // 로딩 중
    if (authState.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 로그인 됨
    if (authState.isAuthenticated && authState.user != null) {
      return HomeScreen();
    }

    // 로그인 안됨
    return LoginScreen();
  }
}
```

### _checkAuth() 로직
**lib/features/auth/provider/auth_provider.dart:48-80**
1. SharedPreferences에서 'user_data' 키로 저장된 JSON 문자열 읽기
2. JSON을 User 객체로 변환
3. 성공하면 `isAuthenticated: true`, 실패하면 저장된 데이터 삭제

---

## 3️⃣ 로그인 과정 (LoginScreen)

### 실행 흐름
```
LoginScreen 표시
  ↓
유저가 이메일/비밀번호 입력
  ↓
"Iniciar sesión" 버튼 클릭
  ↓
_formKey.currentState!.validate() - 폼 유효성 검사
  ↓
authProvider.notifier.login() 호출
  ↓
ApiService로 POST 요청: 'cl-auth' 엔드포인트
  {
    "action": "login",
    "email": "...",
    "password": "..."
  }
  ↓
서버 응답 대기
  ↓
경우 1: 성공 (success: true)
  → User 객체 생성
  → SharedPreferences에 user_data 저장
  → authState 업데이트 (isAuthenticated: true)
  → HomeScreen으로 이동

경우 2: 실패 (success: false)
  → SnackBar로 에러 메시지 표시
```

### 핵심 코드
**로그인 버튼 로직 (lib/features/auth/screens/login_screen.dart:121-131)**
```dart
onPressed: () async {
  if (_formKey.currentState!.validate()) {
    final success = await ref
      .read(authProvider.notifier)
      .login(
        _emailContoller.text.trim(),
        _passwordController.text,
      );

    if (success) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // 에러 표시
      messenger.showSnackBar(SnackBar(...));
    }
  }
}
```

**login 메서드 (lib/features/auth/provider/auth_provider.dart:118-157)**
```dart
Future<bool> login(String email, String password) async {
  state = state.copyWith(isLoading: true, error: null);

  final response = await _apiService.post('cl-auth', {
    'action': 'login',
    'email': email,
    'password': password,
  });

  if (response['success'] == true) {
    final user = User.fromJson(response['data']['user']);

    // SharedPreferences에 저장
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(response['data']['user']);
    await prefs.setString('user_data', userJson);

    state = state.copyWith(
      user: user,
      isAuthenticated: true,
      isLoading: false,
    );
    return true;
  } else {
    state = state.copyWith(error: response['message'], isLoading: false);
    return false;
  }
}
```

---

## 4️⃣ 홈 화면 구조 (HomeScreen)

### 실행 흐름
```
HomeScreen 시작
  ↓
_currentIndex = 0 (초기값)
  ↓
IndexedStack으로 4개 화면 동시에 생성 (상태 유지)
  ├─ index 0: DashboardScreen
  ├─ index 1: CalendarScreen
  ├─ index 2: MyCoursesScreen
  └─ index 3: ConfigScreen
  ↓
CustomBottomNavBar에서 탭 클릭
  ↓
setState(() { _currentIndex = 새로운index; })
  ↓
_getAppBar()로 현재 탭에 맞는 AppBar 제목 변경
  ↓
IndexedStack이 해당 index 화면 표시
```

### 핵심 코드
**lib/app/home_screen.dart**
```dart
class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // 탭마다 다른 AppBar 제목
  PreferredSizeWidget _getAppBar() {
    switch (_currentIndex) {
      case 0: return AppBar(title: Text('Dashboard'));
      case 1: return AppBar(title: Text('Calendario'));
      case 2: return AppBar(title: Text('Mis Cursos'));
      case 3: return AppBar(title: Text('Configuración'));
      default: return AppBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),

      // IndexedStack: 모든 화면을 동시에 생성하고 index에 해당하는 것만 표시
      // 장점: 탭 전환시 스크롤 위치, 데이터 상태 유지
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DashboardScreen(),
          CalendarScreen(),
          MyCoursesScreen(),
          ConfigScreen(),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index; // 탭 변경
        }),
      ),
    );
  }
}
```

### IndexedStack의 장점
- 모든 화면을 메모리에 유지
- 탭 전환시 스크롤 위치가 유지됨
- 화면 전환이 빠름 (재생성 안함)

---

## 5️⃣ 대시보드 데이터 로딩 (DashboardScreen)

### 실행 흐름
```
DashboardScreen 빌드
  ↓
ref.watch(dashboardProvider) 실행
  ↓
dashboardProvider (FutureProvider) 자동 실행
  ↓
authProvider에서 userId 가져오기
  ↓
ApiService.get('cl-student?action=dashboard&id=userId')
  ↓
서버에서 JSON 응답
  ↓
DashboardResponse.fromJson(response) - 데이터 파싱
  ↓
AsyncValue 상태 변경
  ├─ loading: CircularProgressIndicator
  ├─ error: 에러 메시지 + 재시도 버튼
  └─ data: 실제 UI 렌더링
       ├─ 오늘의 수업 (todaySchedule)
       ├─ 출석률 (attendanceStats)
       └─ 다가오는 이벤트 (upcomingEvents)
```

### 핵심 코드
**Provider 정의 (lib/features/dashboard/provider/dashboard_provider.dart)**
```dart
final dashboardProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  final apiService = ApiService();

  // authProvider에서 userId 가져오기
  final authState = ref.watch(authProvider);
  final userId = authState.user?.id;

  if (userId == null) {
    throw Exception('No hay usuario');
  }

  // API 호출
  final response = await apiService.get('cl-student?action=dashboard&id=$userId');
  final dashboardResponse = DashboardResponse.fromJson(response);

  return dashboardResponse.data;
});
```

**UI에서 사용 (lib/features/dashboard/screens/dashboard_screen.dart)**
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final dashboardAsync = ref.watch(dashboardProvider);

  // AsyncValue의 상태에 따라 다른 UI 표시
  return dashboardAsync.when(
    // 로딩 중
    loading: () => Center(child: CircularProgressIndicator()),

    // 에러 발생
    error: (error, stack) => Center(
      child: Column(
        children: [
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(dashboardProvider); // 다시 로드
            },
            child: Text('Reintentar'),
          ),
        ],
      ),
    ),

    // 데이터 로드 완료
    data: (dashboardData) => SingleChildScrollView(
      child: Column(
        children: [
          // 오늘의 수업
          ...dashboardData.todaySchedule.map((schedule) => CourseCard(...)),

          // 출석률
          CircularPercentage(percentage: dashboardData.attendanceStats?.percentage ?? 0),

          // 다가오는 이벤트
          ...dashboardData.upcomingEvents.map((event) => EventCard(...)),
        ],
      ),
    ),
  );
}
```

### FutureProvider의 autoDispose
- `autoDispose`: 화면을 벗어나면 자동으로 provider 제거
- 다시 화면에 들어오면 API를 다시 호출
- 항상 최신 데이터를 보여줌

---

## 6️⃣ API 통신 구조 (ApiService)

### 실행 흐름
```
Provider에서 ApiService() 호출
  ↓
Singleton 인스턴스 반환 (앱 전체에서 하나만 존재)
  ↓
baseUrl과 apiKey를 .env에서 로드
  ↓
GET 또는 POST 메서드 호출
  ↓
http 패키지로 실제 네트워크 요청
  ↓
headers에 'Content-Type'과 'Token' 추가
  ↓
응답 statusCode 확인
  ├─ 200/201: json.decode(response.body) 반환
  └─ 그 외: Exception 발생
  ↓
catch로 네트워크 에러 처리
```

### 핵심 코드
**lib/shared/network/api_service.dart**
```dart
class ApiService {
  // Singleton 패턴
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // .env에서 로드
  final String baseUrl = dotenv.env['API_URL'] ?? dotenv.env['API_LOCAL_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? dotenv.env['API_LOCAL_KEY'] ?? '';

  // 모든 요청에 공통으로 사용되는 헤더
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Token': apiKey,
  };

  // GET 요청
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST 요청
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
```

### Singleton 패턴이란?
- 앱 전체에서 ApiService 인스턴스를 **하나만** 생성
- 어디서 `ApiService()`를 호출해도 같은 인스턴스 반환
- 메모리 절약 + baseUrl, apiKey를 한 곳에서만 관리

---

## 7️⃣ 상태 관리 (Riverpod)

### Riverpod의 역할
```
Provider 선언
  ↓
ref.watch(provider) - UI에서 감시
  ↓
Provider 값 변경되면
  ↓
자동으로 해당 위젯만 리빌드 (효율적!)
```

### 사용 방식 1: NotifierProvider (AuthProvider)
**선언**
```dart
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkAuth();
    return AuthState(isLoading: true);
  }

  Future<bool> login(String email, String password) async {
    // 로그인 로직
    state = state.copyWith(user: user, isAuthenticated: true);
    return true;
  }

  Future<void> logout() async {
    // 로그아웃 로직
    state = AuthState();
  }
}
```

**사용**
```dart
// 상태 읽기 (자동 리빌드)
final authState = ref.watch(authProvider);
if (authState.isAuthenticated) { ... }

// 상태 한 번만 읽기 (리빌드 안됨)
final currentUser = ref.read(authProvider).user;

// 메서드 호출
await ref.read(authProvider.notifier).login(email, password);
await ref.read(authProvider.notifier).logout();
```

### 사용 방식 2: FutureProvider (DashboardProvider)
**선언**
```dart
final dashboardProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  final apiService = ApiService();
  final userId = ref.watch(authProvider).user?.id;

  final response = await apiService.get('cl-student?action=dashboard&id=$userId');
  return DashboardResponse.fromJson(response).data;
});
```

**사용**
```dart
final dashboardAsync = ref.watch(dashboardProvider);

// AsyncValue의 상태에 따라 분기
dashboardAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
  data: (data) => Text('Data: $data'),
);

// 수동으로 새로고침
ref.invalidate(dashboardProvider);
```

### Riverpod의 장점
1. **자동 리빌드**: Provider 값이 변경되면 `ref.watch()`를 사용한 위젯만 자동 업데이트
2. **타입 안전성**: 컴파일 타임에 타입 체크
3. **테스트 용이**: Provider를 쉽게 mocking 가능
4. **메모리 관리**: `autoDispose`로 사용하지 않는 provider 자동 제거

---

## 8️⃣ 전체 데이터 흐름 다이어그램

```
┌─────────────────────────────────────────────────────────┐
│                       앱 시작                            │
│                       main()                             │
│  - SharedPreferences 초기화                              │
│  - .env 로드 (API URL, KEY)                             │
│  - ProviderScope로 상태관리 시작                         │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                   AuthWrapper                            │
│  - authProvider 감시                                     │
│  - SharedPreferences에서 user_data 확인                 │
└───────────┬─────────────────────────┬───────────────────┘
            │                         │
    로그인 안됨                    로그인 됨
            │                         │
            ▼                         ▼
┌─────────────────┐         ┌─────────────────────────────┐
│  LoginScreen    │         │      HomeScreen             │
│                 │         │  - BottomNavBar로 탭 전환   │
│  - 폼 입력      │         │  - IndexedStack으로 상태유지│
│  - 유효성 검사  │         └─────────┬───────────────────┘
│  - login() 호출 │                   │
└────────┬────────┘                   │
         │                            ▼
         │                 ┌───────────────────────┐
         │                 │   4개 화면 (탭)        │
         │                 ├───────────────────────┤
         │                 │ 0. DashboardScreen    │
         │                 │ 1. CalendarScreen     │
         │ 회원가입 클릭    │ 2. MyCoursesScreen    │
         │                 │ 3. ConfigScreen       │
         ▼                 └───────────┬───────────┘
┌─────────────────┐                   │
│ RegisterScreen  │                   │
│  - register()   │                   │
└─────────────────┘                   │
                                      │
         ┌────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────┐
│                  Riverpod Providers                      │
│  - authProvider: 인증 상태 관리                          │
│  - dashboardProvider: 대시보드 데이터                    │
│  - coursesProvider: 코스 목록                            │
│  - calendarProvider: 캘린더 이벤트                       │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                   ApiService                             │
│  - Singleton 패턴                                        │
│  - GET/POST 메서드                                       │
│  - 공통 헤더 관리 (Token)                                │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  Backend API                             │
│  - cl-auth: 로그인/회원가입/프로필                       │
│  - cl-student: 대시보드/코스/캘린더                      │
└─────────────────────────────────────────────────────────┘
```

---

## 9️⃣ 주요 폴더 구조

```
lib/
├── main.dart                   # 앱 진입점
│
├── app/                        # 앱 전체 설정
│   ├── theme/                  # 테마 (색상, 폰트, 간격)
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── app_spacing.dart
│   └── home_screen.dart        # 메인 화면 (BottomNavBar)
│
├── features/                   # 기능별 모듈
│   ├── auth/                   # 인증 기능
│   │   ├── provider/           # 상태 관리
│   │   │   └── auth_provider.dart
│   │   ├── screens/            # UI 화면
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   └── widgets/            # 재사용 위젯
│   │       └── auth_wrapper.dart
│   │
│   ├── dashboard/              # 대시보드
│   │   ├── provider/
│   │   ├── models/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── calendar/               # 캘린더
│   ├── courses/                # 내 코스
│   └── config/                 # 설정
│
└── shared/                     # 공유 리소스
    ├── models/                 # 데이터 모델 (User 등)
    ├── network/                # API 통신
    │   └── api_service.dart
    ├── widgets/                # 공통 위젯
    │   ├── course_card.dart
    │   └── custom_form_field.dart
    └── constants/              # 상수 (AppBar, BottomNav 등)
```

---

## 🔟 핵심 개념 정리

### 1. Riverpod Provider
- 앱의 상태를 관리하고 자동으로 UI 업데이트
- `ref.watch()`: 값이 변경되면 자동 리빌드
- `ref.read()`: 한 번만 읽기 (이벤트 핸들러에서 사용)

### 2. ApiService Singleton
- 앱 전체에서 하나의 API 클라이언트만 사용
- baseUrl, apiKey를 중앙에서 관리
- 모든 요청에 공통 헤더 자동 추가

### 3. SharedPreferences
- 로컬 저장소 (Key-Value 저장)
- 로그인 정보(user_data)를 JSON 문자열로 저장
- 앱 재시작 시에도 데이터 유지

### 4. IndexedStack
- 여러 위젯을 동시에 생성하고 하나만 표시
- 탭 전환 시 상태 유지 (스크롤 위치, 입력값 등)
- HomeScreen의 BottomNav에서 사용

### 5. FutureProvider
- 비동기 데이터를 자동으로 관리
- `AsyncValue<T>`로 loading/error/data 상태 제공
- `autoDispose`로 메모리 자동 관리

### 6. ConsumerWidget
- Riverpod Provider를 감시하는 위젯
- `build(BuildContext context, WidgetRef ref)` 메서드 사용
- `ref`로 Provider 접근

---

## 💡 교수님께 설명할 때

### 프로젝트 구조
- "**Feature-first 구조**로 기능별로 폴더를 나눴습니다"
- "각 feature는 provider, models, screens, widgets로 구성됩니다"

### 상태 관리
- "**Riverpod**을 사용해서 상태를 관리합니다"
- "Provider가 변경되면 자동으로 UI가 업데이트됩니다"

### API 통신
- "**Singleton 패턴**으로 ApiService를 만들었습니다"
- "앱 전체에서 하나의 인스턴스만 사용해서 효율적입니다"

### 인증 처리
- "로그인 성공 시 **SharedPreferences**에 유저 정보를 저장합니다"
- "앱 재시작 시 자동 로그인이 됩니다"

### 화면 전환
- "**IndexedStack**으로 탭 상태를 유지합니다"
- "탭을 전환해도 스크롤 위치가 유지됩니다"

---

## 📚 참고 자료

### Riverpod 공식 문서
- https://riverpod.dev/

### Flutter 공식 문서
- https://flutter.dev/docs

### HTTP 패키지
- https://pub.dev/packages/http

### SharedPreferences
- https://pub.dev/packages/shared_preferences

---

**작성일**: 2026-02-09
**작성자**: ClassLog 개발팀
