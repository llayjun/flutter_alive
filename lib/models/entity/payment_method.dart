/// 支付平台
enum PaymentPlatform {
  PC,
  WEIXIN,
  WAP,
  APP,
  MINAPP,
}

/// 在线支付方式
enum OnlinePaymentType {
  weixin_app_pay, // 微信APP
  weixin_inner, // 微信内
  weixin_native, // 扫码支付
  alipay_app, // 支付宝APP
  alipay_pc, // 支付宝PC
  weixin_min_app, // 小程序支付
  cash_on_delivery, // 货到付款
  offline_payment, // 线下支付
}

/// 支付方式代码
enum PaymentMethodCode {
  cash_on_delivery,
  offline_payment,
}

class PaymentMethod {
  PaymentMethod._();
}
