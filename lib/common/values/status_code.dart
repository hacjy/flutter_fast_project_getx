class StatusCode {
  ///****************************************
  ///***************** 通用 *****************
  ///****************************************

  ///成功
  static const int success = 0;

  ///泛失败
  static const int fail = 500;

  ///权限认证失败
  static const int notAuth = 401;

  ///****************************************
  ///*************** Login模块 ***************
  ///****************************************

  ///手机验证码输入错误
  static const int invalidSms = 1000003;

  ///手机验证码过期
  static const int expiredSms = 1000004;

  ///新用户
  static const int newUser = 1000002;

  ///該手機已注冊但并未綁定郵箱和用戶名
  static const int notRegister = 1000005;

  ///三方授权,但是沒有用戶信息
  static const int authNoInfo = 1000001;

  ///短信发送失败
  static const int sendSmsFail = 1000500;

  ///复购-全部不可购买
  static const int reorderAllFail = 1002002;

  ///复购-部分不可购买
  static const int reorderPartFail = 1002003;

  ///轮询
  static const int loop = 1004004;

  ///****************************************
  ///*************** 结算模块 ***************
  ///****************************************

  ///预下订单失败，存在售罄商品
  static const int outOfStock = 1004005;
  static const int validSku = 1004001;

  ///商品隐藏
  static const int hide = 1002001;
}
