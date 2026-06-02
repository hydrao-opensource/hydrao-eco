import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';

class AuthRepository {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = AppConstants.apiUrl;

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserEmail = 'user_email';
  static const _keyExpirationDate = 'token_expiration_date';

  /// Login initial
  Future<bool> login(String email, String password) async {
    try {
      appLogger.d('login : url=$_baseUrl/sessions, login=$email');
      final response = await http.post(
        Uri.parse('$_baseUrl/sessions'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': AppConstants.apiKey,
        },
      );
      appLogger.d('login response : ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        await _saveAuthData(data, email);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Sauvegarde sécurisée des données avec calcul de la date d'expiration
  Future<void> _saveAuthData(Map<String, dynamic> data, [String? email]) async {
    await _storage.write(
      key: _keyAccessToken,
      value: data['access_token'] as String,
    );
    await _storage.write(
      key: _keyRefreshToken,
      value: data['refresh_token'] as String,
    );

    if (email != null) {
      await _storage.write(key: _keyUserEmail, value: email);
    }

    // Calcul de la date d'expiration : maintenant + expires_in secondes
    final int expiresIn = data['expires_in'] as int; // ex: 3600
    final expiryDate = DateTime.now().add(Duration(seconds: expiresIn));
    await _storage.write(
      key: _keyExpirationDate,
      value: expiryDate.toIso8601String(),
    );
  }

  /// Vérifie si le token actuel est expiré (ou va l'être dans moins d'une minute)
  Future<bool> isTokenExpired() async {
    final expiryStr = await _storage.read(key: _keyExpirationDate);
    if (expiryStr == null) return true;

    final expiryDate = DateTime.parse(expiryStr);
    // On prend une marge de sécurité de 60 secondes pour éviter les micro-coupures
    return DateTime.now().isAfter(
      expiryDate.subtract(const Duration(seconds: 60)),
    );
  }

  /// Récupère le token valide (le rafraîchit si nécessaire)
  Future<String?> getValidAccessToken() async {
    if (await isTokenExpired()) {
      bool success = await refreshTokens();
      if (!success) return null; // L'utilisateur doit se reconnecter
    }
    return await _storage.read(key: _keyAccessToken);
  }

  /// Rafraîchir les tokens
  Future<bool> refreshTokens() async {
    final refreshToken = await _storage.read(key: _keyRefreshToken);
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sessions/refresh'),
        body: jsonEncode({'refresh_token': refreshToken}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        await _saveAuthData(
          data,
        ); // On met à jour les tokens et la nouvelle date
        return true;
      }
    } catch (_) {}

    await logout(keepEmail: true);
    return false;
  }

  Future<void> logout({bool keepEmail = true}) async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyExpirationDate);
    if (!keepEmail) {
      await _storage.delete(key: _keyUserEmail);
    }
  }

  Future<String?> getStoredEmail() async =>
      await _storage.read(key: _keyUserEmail);
}
