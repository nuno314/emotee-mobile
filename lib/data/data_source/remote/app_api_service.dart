import 'dart:io';

import 'package:dio/dio.dart' as dio_p;
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pedantic/pedantic.dart';

import '../../../common/client_info.dart';
import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/utils.dart';
import '../../../di/di.dart';
import '../local/local_data_manager.dart';
import 'interceptor/auth_interceptor.dart';
import 'interceptor/header_interceptor.dart';
import 'interceptor/logger_interceptor.dart';
import 'rest_api_repository/rest_api_repository.dart';

part 'api_service_error.dart';

@Injectable()
class AppApiService {
  late dio_p.Dio dio;
  late RestApiRepository client;

  AppApiService() {
    _config();
  }

  LocalDataManager get localDataManager => injector.get();

  void _config() {
    _setupDioClient();

    _createRestClient();
  }

  Map<String, String> _getDefaultHeader() {
    final defaultHeader = <String, String>{
      HttpConstants.contentType: 'application/json',
      HttpConstants.device: 'mobile',
      HttpConstants.model: ClientInfo.model,
      HttpConstants.osversion: ClientInfo.osversion,
      HttpConstants.appVersion: ClientInfo.appVersionName,
      HttpConstants.appVersionFull: ClientInfo.appVersion,
      HttpConstants.language: ClientInfo.languageCode,
    };

    if (!kIsWeb) {
      defaultHeader[HttpConstants.osplatform] = Platform.operatingSystem;
    }
    return defaultHeader;
  }

  void _setupDioClient() {
    dio = dio_p.Dio(dio_p.BaseOptions(
      followRedirects: false,
      receiveTimeout: const Duration(seconds: 30), // 30s
      sendTimeout: const Duration(seconds: 30), //// 30s
    ));

    dio.options.headers.clear();

    dio.options.headers = _getDefaultHeader();

    /// Dio InterceptorsWrapper
    dio.interceptors.add(HeaderInterceptor(
      getHeader: _getDefaultHeader,
    ));
    dio.interceptors.add(
      AuthInterceptor(
        getToken: null /*localDataManager.getToken*/,
        refreshToken: (token, options) async {
          return refreshToken(token);
        },
        onLogoutRequest: () {
          unawaited(localDataManager.clearData());
        },
      ),
    );
    dio.interceptors.add(
      LoggerInterceptor(
        // implement ignore large logs if needed
        ignoreReponseDataLog: (response) {
          // return response.requestOptions.path == ApiContract.administrative;
          return false;
        },
      ),
    );
  }

  void _createRestClient() {
    client = RestApiRepository(
      dio,
      baseUrl: Config.instance.appConfig.baseApiLayer,
    );
  }

  Future<String?> refreshToken(String token, {bool saveToken = true}) async {
    // TODO : implement refresh token if needed
    // final res = await client.refreshToken({
    //   'token': token,
    //   'refreshToken': LocalDataManager.getUser().refreshToken,
    // });
    // if (res != null && saveToken) {
    //   await LocalDataManager.saveNewToken(res?.token);
    // }
    // return res?.token?.token;
    return token;
  }
}
