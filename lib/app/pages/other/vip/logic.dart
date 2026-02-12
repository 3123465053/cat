import 'dart:async';
import 'dart:io';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/Widget/app_tips_widget.dart';
import '../../../common/constant/constant.dart';
import '../../../common/constant/sp_key.dart';
import '../../../common/network/api/api.dart';
import '../../../common/network/request/app_common_api.dart';
import '../../../common/network/request/app_request.dart';
import '../../../common/utils/sp_utils.dart';
import '../../../routes/app_pages.dart';

class VipLogic extends GetxController {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> products = <ProductDetails>[];
  List<String> _kProductIds = <String>[];

  List<String> descList = [
    //   "三天免费试用".tr,
    "支持多个视频分析同时进行".tr,
    "解锁视频分析时长".tr,
    "分析记录无限保存".tr,
  ];

  RxInt selectIndex = 1.obs;

  //价格列表
  RxList priceList = [].obs;

  opTapPriceItem(int index) {
    selectIndex.value = index;
  }

  @override
  void onInit() async {
    iosPayListen();
    await getPriceList();
    if (Platform.isIOS) {
      initStoreInfo();
    }
    super.onInit();
  }

  //获取价格列表
  getPriceList() async {
    EasyLoading.show(status: "loading...");
    try {
      //套餐列表
      var res = await AppRequest.instance.post(
        VipApi.GetPriceList,
        data: {
          "productPlatform": "APPLE",
          "appId": Constant.appBundleID,
          "productType": "SUBSCRIPTION",
          "productClassify": "CATANALYSISPAY",
        },
      );
      print("sfddddss");
      print(res);
      if (res['code'] != 200) {
        AppTipsWidget.showToast("获取价格列表失败".tr);
        return;
      }
      priceList.value = res['data'];

      res["data"].forEach((item) {
        _kProductIds.add(item["productId"]);
      });
      print("asfdss");
      print(_kProductIds);
      EasyLoading.dismiss();
    } catch (e) {
      print("getPrice Error $e");
      AppTipsWidget.showToast("获取价格列表失败".tr);
      EasyLoading.dismiss();
    }
  }

  //初始化苹果(ios)支付
  Future<bool> initStoreInfo() async {
    //判断应用商店是否可用 (是否有谷歌支付 和Appstroe)
    final bool _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) {
      products = <ProductDetails>[];
      return false;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    //todo:
    print("_kProductIds.toSet()${_kProductIds.toSet()}");
    final ProductDetailsResponse productDetailResponse = await _inAppPurchase
        .queryProductDetails(_kProductIds.toSet());
    print("productDetailResponse.error:${productDetailResponse.error}");

    // 报错情况
    if (productDetailResponse.error != null) {
      print("商品详情报错返回:${productDetailResponse.error!.message}");
      products = productDetailResponse.productDetails;
      AppTipsWidget.showToast("会员列表报错，请联系客服反馈！".tr);
      EasyLoading.dismiss();
      return false;
    }

    // 空情况
    if (productDetailResponse.productDetails.isEmpty) {
      products = productDetailResponse.productDetails;
      EasyLoading.dismiss();
      AppTipsWidget.showToast("未查询到会员套餐，请联系客服反馈！".tr);
      return false;
    }

    //处理查询到的商品列表(匹配产品)
    products = productDetailResponse.productDetails;
    //  priceList.first["product"] = products.first;
    for (var itemV in priceList) {
      for (var itemP in products) {
        if (itemV["productId"] == itemP.id) {
          itemV["product"] = itemP;
          break;
        }
      }
    }

    EasyLoading.dismiss();
    return true;
  }

  //苹果支付监听
  iosPayListen() {
    //监听购买事件
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (Object error) {
        //购买失败
        print("error:${error}");
      },
    );
  }

  /// 监听购买结果
  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    final sortedList = List.from(purchaseDetailsList);
    sortedList.sort(
      (a, b) => (int.tryParse(b.transactionDate ?? '') ?? 0).compareTo(
        int.tryParse(a.transactionDate ?? '') ?? 0,
      ),
    );
    for (final PurchaseDetails purchaseDetails in sortedList) {
      if (purchaseDetails.status == PurchaseStatus.canceled) {
        print("取消支付");
        EasyLoading.dismiss();
      } else if (purchaseDetails.status == PurchaseStatus.pending) {
        //等待支付完成
        EasyLoading.show(status: 'loading...'.tr);
        print("loading");
      } else {
        bool valid = false;
        if (purchaseDetails.status == PurchaseStatus.error) {
          //支付错误
          print("purchaseDetails.error:${purchaseDetails.error!}");
          //优惠已不再提供
          // AppTipsWidget.showToast("支付出错".tr + '：${purchaseDetails.error!}');
          EasyLoading.dismiss();
          var errorDetail = purchaseDetails
              .error
              ?.details?["NSUnderlyingError"]?["userInfo"]?["NSLocalizedFailureReason"];
          if (purchaseDetails.error?.details?["NSUnderlyingError"]?["code"] ==
                  3904 &&
              (errorDetail.toString().contains("优惠已不再提供") ||
                  errorDetail.toString().contains("Offer Not Available"))) {
            applePay(useDiscount: false);
          }
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          EasyLoading.dismiss();
          //购买成功  到服务器验证
          valid = await _verifyIosPurchase(purchaseDetails);

          if (!valid) {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }

          if (valid) {
            EasyLoading.show(status: "loading...");
            //等待4秒 确保后台数据更新成功
            // await Future.delayed(Duration(seconds: 4));
            await AppCommonApi.getUserInfo();
            EasyLoading.dismiss();

            //当前不是main可以跳转
            if (Get.currentRoute != "/main") {
              //支付完成都应该跳转到主页面
              Get.offAllNamed(AppRoutes.MAIN);
            }
            print("dfddd");
            //未绑定苹果id
            Future.delayed(const Duration(seconds: 1)).then((value) {
              if (Constant.userInfo.value.appAccountToken != null &&
                  Constant.userInfo.value.appAccountToken!.contains("custom")) {
                AppTipsWidget.showToast("绑定苹果ID，以便跨设备使用".tr);
                //没有在登录页面才去登录页
                if (Get.currentRoute != AppRoutes.LOGIN) {
                  Get.toNamed(AppRoutes.LOGIN, arguments: {"loginType": 0,"showClose":true});
                }
              }
            });
          }
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          EasyLoading.dismiss();
        }
        //校验成功之后执行消耗
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// 验证购买失败（ios）
  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    print("购买失败");
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  /// 后端验证,（ios 同步到自己到vip购买）
  Future<bool> _verifyIosPurchase(PurchaseDetails purchaseDetails) async {
    EasyLoading.show(status: 'loading...');
    print(
      "purchaseID:${purchaseDetails.purchaseID},productID:${purchaseDetails.productID},transactionDate:${purchaseDetails.transactionDate}",
    );
    Map<String, dynamic> data = Map();
    data.putIfAbsent("app_id", () => Constant.appBundleID);
    data.putIfAbsent("product_id", () => purchaseDetails.productID);
    data.putIfAbsent(
      "receipt_data",
      () => purchaseDetails.verificationData.serverVerificationData,
    );

    return await AppRequest.instance
        .post(VipApi.BuyVipByApplePay, data: data)
        .then((res) {
          EasyLoading.dismiss();
          print("asdfdd");
          print(res);
          if (res["code"] == 200 || res["code"] == 409 || res["code"] == 201) {
            AppTipsWidget.showToast("订阅成功".tr);
            return true;
          } else {
            EasyLoading.dismiss();
            return false;
          }
        });
  }

  //用户协议和隐私政策
  toPrivacy({required int type}) async {
    final Uri _url;
    if (type == 1) {
      _url = Uri.parse(UserApi.agreement);
      if (!await launchUrl(_url)) {
        throw 'Could not launch $_url';
      }
    } else if (type == 2) {
      _url = Uri.parse(UserApi.privacy);
      if (!await launchUrl(_url)) {
        throw 'Could not launch $_url';
      }
    }
  }

  close() {
    String backRouter = Get.arguments?["backTo"] ?? "";
    if (backRouter.isNotEmpty) {
      Get.offAllNamed(backRouter);
    } else {
      Get.back();
    }
  }

  //购买
  payHandle() async {
    ///防止连续点击
    EasyDebounce.debounce(
      'pay', // <-- An ID for this particular debounce
      const Duration(milliseconds: 300), // <-- The debounce duration
      () => applePay(), // <-- The target method
    );
  }

  //ios苹果支付
  //当优惠不在提供的时候 不适用优惠
  applePay({bool useDiscount = true}) async {
    late PurchaseParam purchaseParam;
    //有优惠标识就要添加签名
    if (priceList[selectIndex.value]["trialPeriod"] != null && useDiscount) {
      try {
        EasyLoading.show(status: "loading...");
        Map<String, dynamic> data = {
          "productId": priceList[selectIndex.value]["productId"],
          "promoCode": priceList[selectIndex.value]["trialPeriod"],
        };
        var res = await AppRequest.instance.post(VipApi.GetSign, data: data);
        EasyLoading.dismiss();
        print("dsfddss");
        print(res);
        print(Constant.userInfo.value.appAccountToken);
        if (res["code"] == 200) {
          purchaseParam = AppStorePurchaseParam(
            productDetails: priceList[selectIndex.value]["product"],
            applicationUserName: Constant.userInfo.value.appAccountToken ?? "",
            discount: SKPaymentDiscountWrapper(
              identifier: res["data"]["offerIdentifier"],
              keyIdentifier: res["data"]["keyIdentifier"],
              nonce: res["data"]["nonce"],
              signature: res["data"]["signature"],
              timestamp: int.tryParse(res["data"]["timestamp"]) ?? 0,
            ),
          );
        } else {
          purchaseParam = PurchaseParam(
            productDetails: priceList[selectIndex.value]["product"],
            applicationUserName: SpUtils.getString(SpKey.token),
          );
        }
      } catch (e) {
        EasyLoading.dismiss();
        purchaseParam = PurchaseParam(
          productDetails: priceList[selectIndex.value]["product"],
          applicationUserName: SpUtils.getString(SpKey.token),
        );
      }
    } else {
      purchaseParam = PurchaseParam(
        productDetails: priceList[selectIndex.value]["product"],
        applicationUserName: Constant.userInfo.value.appAccountToken,
      );
    }

    //清理掉“未完成”的历史交易，
    var paymentWrapper = SKPaymentQueueWrapper();
    var transactions = await paymentWrapper.transactions();
    transactions.forEach((transaction) async {
      await paymentWrapper.finishTransaction(transaction);
    });

    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }


  @override
  void onClose() {
    try {
      if (Platform.isIOS) {
        _subscription.cancel();
        print("safdssss");
      }
    } catch (e) {}
    super.onClose();
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
