import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classlog/shared/network/api_service.dart';
import 'package:classlog/shared/models/user.dart';
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
    return AuthState(isLoading: true);
  }

  // Check user isLogin?
  Future<void> _checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // cargar user data para web app
      if (kIsWeb) {
        await prefs.reload();
      }

      // datos de localStorage
      final userJson = prefs.getString('user_data');

      if (userJson != null) {
        try {
          final userData = json.decode(userJson) as Map<String, dynamic>;
          final user = User.fromJson(userData);

          state = state.copyWith(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
        } catch (e) {
          await prefs.remove('user_data');
          state = state.copyWith(isLoading: false);
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // cargar datos de API
  Future<void> loadUser(int userId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response =
          await _apiService.get('cl-auth?action=profile&id=$userId');

      if (response['success'] == true) {
        final user = User.fromJson(response['data']);

        // actualizar localstorage
        final prefs = await SharedPreferences.getInstance();
        final userJson = json.encode(response['data']);
        await prefs.setString('user_data', userJson);

        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response['message'] ?? 'Error al cargar usuario',
          isLoading: false,
        );
      }
    } catch (e) {
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

        // guardar user datos en localstorage
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

  // Registrar
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

  // Update
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

  // Update email/password
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
      // logout
    }

    // vaciar local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');

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
