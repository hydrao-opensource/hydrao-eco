import 'package:dio/dio.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/repositories/api/auth_repository.dart';

class ApiRepository {
  final AuthRepository _authRepository;
  late final Dio _dio;

  ApiRepository(this._authRepository) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiUrl,
        headers: {
          'x-api-key':
              AppConstants.apiKey, // Ta clé d'API injectée par CodeMagic
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 5),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // On récupère le token depuis ton AuthService (via ton provider)
          final token = await _authRepository.getValidAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Si erreur 401 (Unauthorized), on tente de refresh
          if (e.response?.statusCode == 401) {
            final success = await _authRepository.refreshTokens();

            if (success) {
              // On récupère le nouveau token et on rejoue la requête
              final newToken = await _authRepository.getValidAccessToken();
              e.requestOptions.headers['Authorization'] = 'Bearer $newToken';

              // On relance la requête originale
              final response = await _dio.fetch<ResponseType>(e.requestOptions);
              return handler.resolve(response);
            } else {
              // Refresh échoué -> L'utilisateur doit se reconnecter
              _authRepository.logout();
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  // --- Méthodes CRUD ---

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    return await _dio.get(path, queryParameters: query);
  }

  Future<Response<dynamic>> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response<dynamic>> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response<dynamic>> delete(String path) async {
    return await _dio.delete(path);
  }
}
