import 'package:cripto_currency/model/app_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _baseUrl;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseUrl = _appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String _path) async {
    try {
      String _url = "$_baseUrl$_path";
      Response response = await dio.get(_url);
      return response;
    } catch (e) {
      print('Error: $e');
    }
  }
}
