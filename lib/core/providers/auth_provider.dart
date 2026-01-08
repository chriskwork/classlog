import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classlog/core/network/api_service.dart';
import 'package:classlog/core/models/user.dart';
import 'dart:convert';

// Auth state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth notifier
class AuthNotifier extends Notifier<AuthState> {
  final ApiService _apiService = ApiService();

  @override
  AuthState build() {
    _checkAuth();
    return AuthState(isLoading: true); // Start with loading state
  }

  // Check if user is already logged in
  Future<void> _checkAuth() async {
    try {
      // Always log on web for debugging
      if (kIsWeb) {
        print('[AUTH] ========== Starting _checkAuth ==========');
        print('[AUTH] Platform: Web');
      }

      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // On web, reload to ensure we get the latest data from localStorage
      if (kIsWeb) {
        print('[AUTH] Reloading from localStorage...');
        await prefs.reload();
      }

      // Try to get user data from localStorage (stored as JSON)
      final userJson = prefs.getString('user_data');

      if (kIsWeb) {
        print('[AUTH] Retrieved from storage:');
        print('[AUTH]   - user_data exists: ${userJson != null}');
        print('[AUTH]   - All keys: ${prefs.getKeys()}');
      }

      if (userJson != null) {
        try {
          // Parse user data from JSON
          final userData = json.decode(userJson) as Map<String, dynamic>;
          final user = User.fromJson(userData);

          if (kIsWeb) {
            print('[AUTH] User loaded from localStorage: ${user.email} (ID: ${user.id})');
          }

          state = state.copyWith(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
        } catch (e) {
          if (kIsWeb) {
            print('[AUTH] Error parsing user data: $e');
          }
          // Clear invalid data
          await prefs.remove('user_data');
          state = state.copyWith(isLoading: false);
        }
      } else {
        // No user found, stop loading
        if (kIsWeb) {
          print('[AUTH] No user_data found, showing login screen');
        }
        state = state.copyWith(isLoading: false);
      }
    } catch (e, stackTrace) {
      // Error checking auth, stop loading
      if (kIsWeb) {
        print('[AUTH] ERROR in _checkAuth: $e');
        print('[AUTH] Stack trace: $stackTrace');
      }
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Load user profile
  Future<void> loadUser(int userId) async {
    try {
      if (kIsWeb) {
        print('[AUTH] loadUser called with userId: $userId');
      }
      state = state.copyWith(isLoading: true, error: null);

      // Server expects GET with query parameters, not POST with body
      // The server's profile action only reads from $_GET, not $_POST
      final response =
          await _apiService.get('cl-auth?action=profile&id=$userId');

      if (kIsWeb) {
        print('[AUTH] API response: $response');
      }

      if (response['success'] == true) {
        final user = User.fromJson(response['data']);
        if (kIsWeb) {
          print('[AUTH] User loaded successfully: ${user.email}');
        }
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        if (kIsWeb) {
          print('[AUTH] Failed to load user: ${response['message']}');
        }
        state = state.copyWith(
          error: response['message'] ?? 'Error al cargar usuario',
          isLoading: false,
        );
      }
    } catch (e, stackTrace) {
      if (kIsWeb) {
        print('[AUTH] ERROR loading user: $e');
        print('[AUTH] Stack trace: $stackTrace');
      }
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _apiService.post('cl-auth', {
        'action': 'login',
        'email': email,
        'password': password,
      });

      if (response['success'] == true) {
        final user = User.fromJson(response['data']['user']);

        if (kIsWeb) {
          print('[AUTH] ========== Login Successful ==========');
          print('[AUTH] User: ${user.email} (ID: ${user.id})');
        }

        // Save user data to local storage as JSON
        final prefs = await SharedPreferences.getInstance();

        if (kIsWeb) {
          print('[AUTH] Saving to SharedPreferences...');
        }

        // Store complete user data as JSON string
        final userJson = json.encode(response['data']['user']);
        final saveResult = await prefs.setString('user_data', userJson);

        if (kIsWeb) {
          print('[AUTH] Save results:');
          print('[AUTH]   - user_data saved: $saveResult');

          // Immediate verification
          final savedUserJson = prefs.getString('user_data');
          print('[AUTH] Immediate verification:');
          print('[AUTH]   - Retrieved user_data: ${savedUserJson != null}');
          print('[AUTH]   - All keys in storage: ${prefs.getKeys()}');
        }

        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );

        return true;
      } else {
        state = state.copyWith(
          error: response['message'] ?? 'Error al iniciar sesión',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String nombre,
    required String apellidos,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _apiService.post('cl-auth', {
        'action': 'register',
        'email': email,
        'password': password,
        'nombre': nombre,
        'apellidos': apellidos,
      });

      if (response['success'] == true) {
        final user = User.fromJson(response['data']['user']);

        // Save user data to local storage as JSON
        final prefs = await SharedPreferences.getInstance();
        final userJson = json.encode(response['data']['user']);
        await prefs.setString('user_data', userJson);

        if (kIsWeb) {
          print('[AUTH] Register successful - user: ${user.email}');
          print('[AUTH] Saved user_data to localStorage');
        }

        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );

        return true;
      } else {
        state = state.copyWith(
          error: response['message'] ?? 'Error al registrar',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  // Update profile
  Future<bool> updateProfile({
    required String nombre,
    required String apellidos,
    String? telefono,
  }) async {
    if (state.user == null) return false;

    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _apiService.post('cl-auth', {
        'action': 'update-profile',
        'id': state.user!.id.toString(),
        'nombre': nombre,
        'apellidos': apellidos,
        'telefono': telefono ?? '',
      });

      if (response['success'] == true) {
        final user = User.fromJson(response['data']);

        state = state.copyWith(
          user: user,
          isLoading: false,
        );

        return true;
      } else {
        state = state.copyWith(
          error: response['message'] ?? 'Error al actualizar perfil',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  // Update security (email/password)
  Future<bool> updateSecurity({
    String? email,
    String? password,
  }) async {
    if (state.user == null) return false;

    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _apiService.post('cl-auth', {
        'action': 'update-security',
        'id': state.user!.id.toString(),
        if (email != null) 'email': email,
        if (password != null) 'password': password,
      });

      if (response['success'] == true) {
        // Reload user data
        await loadUser(state.user!.id);

        return true;
      } else {
        state = state.copyWith(
          error: response['message'] ?? 'Error al actualizar seguridad',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      if (state.user != null) {
        await _apiService.post('cl-auth', {
          'action': 'logout',
        });
      }
    } catch (e) {
      // Ignore errors on logout
    }

    // Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');

    if (kIsWeb) {
      print('[AUTH] Logout - cleared user_data from localStorage');
    }

    state = AuthState();
  }

  // Delete account
  Future<bool> deleteAccount() async {
    if (state.user == null) return false;

    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _apiService.post('cl-auth', {
        'action': 'delete-account',
        'id': state.user!.id.toString(),
      });

      if (response['success'] == true) {
        await logout();
        return true;
      } else {
        state = state.copyWith(
          error: response['message'] ?? 'Error al eliminar cuenta',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }
}

// Provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
