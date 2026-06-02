import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/user_state.dart';
import 'package:hydrao_flutter_offline/models/backup.dart';
import 'package:hydrao_flutter_offline/repositories/api/api_repository.dart';
import 'package:hydrao_flutter_offline/repositories/api/auth_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

const _logTag = "[USER_DOMAIN] ";

class UserDomain extends StateNotifier<UserState> {
  final AuthRepository _authRepository;
  final ApiRepository _apiRepository;

  // --- life cycle methods

  UserDomain(this._authRepository, this._apiRepository)
    : super(const UserState()) {
    checkAuthStatus();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  // --- domain methods

  /// Vérifie si l'utilisateur est déjà connecté ou si sa session a expiré
  Future<void> checkAuthStatus() async {
    // On passe en mode "chargement" via le statut logging
    state = state.copyWith(authStatus: AuthStatus.logging);

    final token = await _authRepository.getValidAccessToken();
    final email = await _authRepository.getStoredEmail();

    if (token != null) {
      // Token présent et valide
      state = state.copyWith(
        authStatus: AuthStatus.logged,
        email: email,
        authFailed: false,
      );
    } else if (email != null) {
      // On a un email stocké mais pas de token valide -> Session expirée
      state = state.copyWith(
        authStatus: AuthStatus.expired,
        email: email,
        authFailed: false,
      );
    } else {
      // Aucun email, aucune session
      state = state.copyWith(
        authStatus: AuthStatus.unlogged,
        authFailed: false,
      );
    }
  }

  void clearAuthFailed() {
    state = state.copyWith(authFailed: false);
  }

  /// Méthode de Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(authStatus: AuthStatus.logging);

    final success = await _authRepository.login(email, password);

    if (success) {
      state = state.copyWith(
        authStatus: AuthStatus.logged,
        email: email,
        authFailed: false,
      );
    } else {
      // En cas d'échec de login, on revient généralement à unlogged
      state = state.copyWith(authStatus: AuthStatus.unlogged, authFailed: true);
    }
  }

  /// Déconnexion manuelle
  Future<void> logout() async {
    await _authRepository.logout();
    // Après un logout manuel, on efface l'email ou on reste en unlogged
    state = state.copyWith(
      authStatus: AuthStatus.unlogged,
      email: null,
      authFailed: false,
    );
  }

  Future<void> forgotPassword(String email) async {
    try {
      final emailForUrl = base64Url
          .encode(utf8.encode(email))
          .replaceAll('=', '');
      final url = "${AppConstants.apiUrl}/users/$emailForUrl/forgot-password";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': AppConstants.apiKey,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          "Failed to begin 'forgot password' process : ${response.statusCode} => ${response.body}",
        );
      }
    } on Exception catch (e) {
      // Ici, tu peux gérer les erreurs spécifiques (404, 500, etc.)
      throw Exception("Failed to begin 'forgot password' process : $e");
    }
  }

  Future<void> forgotPasswordConfirmation(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final emailForUrl = base64Url
          .encode(utf8.encode(email))
          .replaceAll('=', '');
      final url =
          "${AppConstants.apiUrl}/users/$emailForUrl/forgot-password-confirmation";

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'code': code, 'password': newPassword}),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': AppConstants.apiKey,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          "Failed to end 'forgot password' process : ${response.statusCode} => ${response.body}",
        );
      }
    } on Exception catch (e) {
      // Ici, tu peux gérer les erreurs spécifiques (404, 500, etc.)
      throw Exception("Failed to end 'forgot password' process : $e");
    }
  }

  Future<HydraoBackup?> downloadBackup() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    final url = '/user-stats/v2/appBackup?appVersion=$appVersion';
    appLogger.d('$_logTag downloadBackup : $url');

    return _handleGet(url, (json) => HydraoBackup.fromJsonMap(json));
  }

  // ---- private methods

  /// Une méthode générique pour gérer les GET et la conversion
  Future<T> _handleGet<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await _apiRepository.get(path);
      appLogger.d('$_logTag response : ${response.data}');
      // On applique la fonction de conversion passée en paramètre
      return fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // Ici, tu peux gérer les erreurs spécifiques (404, 500, etc.)
      throw Exception("Erreur lors de la récupération : ${e.message}");
    }
  }
}
