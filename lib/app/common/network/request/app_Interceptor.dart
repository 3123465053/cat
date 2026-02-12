import 'package:dio/dio.dart';

import '../../constant/sp_key.dart';
import '../../utils/sp_utils.dart';

//拦截器
class AppInterceptor extends InterceptorsWrapper{

  //请求拦截
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? token=SpUtils.getString(SpKey.token);
    print("dsfasddsdd");
    print(token);
    if(token!=null){
      options.headers["couple-token"]=token;
    }
    super.onRequest(options, handler);
  }

  //响应拦截
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

}