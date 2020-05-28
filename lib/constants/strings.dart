class Strings {
  Strings._();

  // General
  static const String appName = "星琯直播";

  static const String website = "http://9daye.com.cn/";

  // widget
  static const String modal_popup_wrap_widget_btn_cancel = "取消";
  static const String modal_popup_wrap_widget_btn_confirm = "确定";

  // 其它通用的tips
  static const String tips_paging_loading_text = "加载中...";
  static const String tips_paging_finished_text = "我是有底线的~";
  static const String tips_plz_login = "请先登录";
  static const String tips_go_back = "返回";

  // 符号
  static const String symbol_rmb = '¥';                   // 金额：¥200.00
  static const String symbol_count_prefix = 'x';          // 个数：x10

  // 所有页面的Title
  static const String title_create_live = "创建直播";
  static const String title_edit_live = "直播详情";
  static const String title_live_create_wx_code = "创建直播";
  static const String title_fund = "资金管理";
  static const String title_order_list = "订单管理";
  static const String title_order_detail = "订单详情";
  static const String title_order_logistics_form = "物流填写";
  static const String title_order_logistics_company = "物流选择";
  static const String title_link_product = "关联商品";
  static const String title_live_preview = "直播详情";
  static const String title_product_search_list = "搜索商品";
  static const String title_product_detail = "商品详情";
  static const String title_product_add_form = "添加产品";
  static const String title_product_manage = "商品管理";
  static const String title_edit_product_detail = "编辑产品";
  static const String title_product_sku_detail = "产品参数详情";
  static const String title_product_graphic_desc = "商品图文描述";

  // 登录页（Login）
  static const String login_doc_title = "请登录";
  static const String login_doc_tips = "请输入账号/手机号";
  static const String login_doc_loading_tips = "登录中...";
  static const String login_btn_sign_in = "登录";
  static const String login_btn_temp_not_sign_in = "暂不登录";
  static const String login_et_phone_label = "九大爷账号";
  static const String login_et_phone_placeholder = "请输入您的账号/手机号";
  static const String login_et_password_label = "密码";
  static const String login_et_password_placeholder = "请输入密码";
  static const String login_et_empty_msg = "请输入九大爷账号及密码";

  // 创建直播页
  static const String live_create_et_banner_tag = "封面图";
  static const String live_create_et_banner_desc =
      "添加后，图片将裁剪为1:1与16:9规格，可点击图片进行微调";
  static const String live_create_form_title_label = "直播标题";
  static const String live_create_form_title_placeholder = "给直播取个名称吧";
  static const String live_create_form_time_label = "直播时间";
  static const String live_create_form_time_tips = "请选择";
  static const String live_create_form_desc_label = "内容简介";
  static const String live_create_form_desc_placeholder = "介绍直播内容或注意事项";
  static const String live_create_form_link_product_label = "关联产品";
  static const String live_create_et_create_preview_btn = "创建直播预览";
  static const String live_create_et_save_edit_btn = "保存";

  // 添加链接商品页
  static const String live_link_product_tab_relevance = "在售";
  static const String live_link_product_tab_irrelevance = "已关联";
  static const String live_link_product_btn_continue_adding = "继续添加";
  static const String live_link_product_btn_adding = "去添加";
  static const String live_link_product_btn_selected = "选好了";

  // 直播预览页
  static const String live_create_preview_et_share = "分享";
  static const String live_create_preview_et_product_title = "本场直播产品";

  // 直播创建_小程序分享页
  static const String live_create_wx_code_doc_loading_tips = '保存图片中...';
  static const String live_create_wx_code_doc_create_success = '创建直播成功';
  static const String live_create_wx_code_doc_share_tips = '分享上方小程序码，用户扫码进入后可查看直播';
  static const String live_create_wx_code_btn_save = '保存小程序码';
  static const String live_create_wx_code_btn_back_to_list = '返回直播列表';
  static const String live_create_wx_code_doc_saving_success = '保存图片成功';
  static const String live_create_wx_code_doc_saving_fail = '保存图片失败';

  // 添加商品详情页
  static const String product_detail_btn_add = "添加产品";

  // 添加编辑页
  static const String product_add_form_btn_shelves = "上架出售";
  static const String product_add_form_btn_warehousing = "放入仓库";
  static const String product_add_form_et_desc_title = "商品图文描述";
  static const String product_add_form_et_desc_tips = "查看";
  static const String product_add_form_et_price_title = "价格";
  static const String product_add_form_et_price_placeholder = "请填写价格";
  static const String product_add_form_et_stock_title = "库存";
  static const String product_add_form_et_stock_placeholder = "请填写库存";

  // 资金管理
  static const String fund_et_account_balance = "账户余额 (元)";
  static const String fund_et_account_available_balance = "可提现余额（元）：";


  ///  通道名称
  static const String react_channelname = "com.czh.tvmerchantapp/plugin";
  static const String flutter_sharename = "com.czh.tvmerchantapp/shareplugin";


  /// 原生  flutter 交互
  /// 直播推流
  static const String alilive = "jumpToBoard";
  /// 拉流播放
  static const String alilive_play = "jumpToLivePlay";
  ///
  static const String getprimarylanguage = 'getPrimaryLanguage';

}
