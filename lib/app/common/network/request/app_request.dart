import "dart:convert";
import "package:dio/dio.dart";
import "../api/api.dart";
import "app_Interceptor.dart";

late Dio dio;

class AppRequest{
  static AppRequest get instance =>_getInstance();
  static AppRequest? _appRequest;

  static AppRequest _getInstance() {
    return _appRequest ?? AppRequest();
  }

  getHeader() {
    return {
      'Accept': 'application/json, text/plain, */*',
      'Content-Type': 'application/json',
      'Authorization': "*",
      'User-Aagent': "4.1.0;android;6.0.1;default;A001",
      "HZUID": "2",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": true
    };
  }

  AppRequest() {
    dio = Dio();
    dio.options
      ..baseUrl = Api.BASE_URL
      ..sendTimeout = const Duration(seconds: 30)
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..validateStatus = (int? status) {
        return status != null && status > 0;
      }
      ..headers = getHeader();

    //添加拦截器
    dio.interceptors
      .add(AppInterceptor());
  }

  Future get(String url,{Map<String,dynamic>? parameters})async{
  Response response;
   if(parameters!=null){
     response =await dio.get(url,queryParameters: parameters);
   }else{
     response=await dio.get(url);
   }
  return json.decode(response.toString());
  }

  Future post(String url,{Map<String,dynamic>? parameters,Map<String,dynamic>? data,BaseOptions ? options})async{
    Response response;
    if(options !=null){
      dio.options = options;
    }
    response=await dio.post(url,data: data,queryParameters: parameters);
    return json.decode(response.toString());
  }

}