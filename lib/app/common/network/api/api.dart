
//基础api
class Api{
  static String BASE_URL="https://api.douring.cn/";

  //海外新增
  static const String FOREIGN_NEW_BASE_URL = 'https://api.ai-face.ai';
}

class AnalyseApi{
  //运动分析接口
  static String AnalyseMotion = Api.FOREIGN_NEW_BASE_URL + "/couple/video/analyze";

  //获取历史记录
  static String getHistory = Api.FOREIGN_NEW_BASE_URL + "/couple/video/history";
}

class UserApi {
  ///登录接口
  static String ThreeLogin =
      "${Api.FOREIGN_NEW_BASE_URL}/couple/user/thirdparty/login";

  ///获取用户信息
  static String GetUserInfo = '${Api.FOREIGN_NEW_BASE_URL}/couple/user/info';

  ///更新用户信息
  static String uploadUserInfo =
      Api.FOREIGN_NEW_BASE_URL + '/couple/user/update';

  ///绑定Apple 账户
  static String bindApple = Api.FOREIGN_NEW_BASE_URL + '/couple/user/bind';

  ///删除账户
  static String DeleteAccount =
      '${Api.FOREIGN_NEW_BASE_URL}/couple/user/deleteAccess';

  ///官网
  static String official =
      'https://cattranslator.ai-face.ai';

  ///用户协议
  static String agreement =
      'https://cattranslator.ai-face.ai/pages/catTranslator/catTranslatorText1';

  ///隐私政策
  static String privacy =
      'https://cattranslator.ai-face.ai/pages/catTranslator/catTranslatorText2';
}




class VipApi {
  ///购买会员（服务器验证）
  static String BuyVipByApplePay =
      Api.FOREIGN_NEW_BASE_URL + '/couple/payment/apple/receipt';

  ///获取价格列表
  static String GetPriceList =
      Api.FOREIGN_NEW_BASE_URL + '/couple/product/query';

  ///3天免费试用 获取签名
  static String GetSign =
      Api.FOREIGN_NEW_BASE_URL + '/couple/payment/promotional-offer/signature';
}