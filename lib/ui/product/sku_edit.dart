
import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/constants/strings.dart';
import 'package:app/entry/routes.dart';
import 'package:app/models/vo/product/product_detail_vo.dart';
import 'package:app/services/product_service.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/widgets/common/loading_wrap_widget.dart';
import 'package:app/widgets/form/input_format/number_text_input_formatter.dart';
import 'package:app/widgets/form/input_row_widget.dart';
import 'package:app/widgets/layout/action_box_widget.dart';
import 'package:app/widgets/layout/action_row_widget.dart';
import 'package:app/widgets/layout/column_flex_layout_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:app/widgets/overwrite/custom_single_child_scroll_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductSkuEditScreen extends StatefulWidget {
  ProductSkuEditScreen({Key key, this.id}) : super(key: key);

  final id;

  @override
  _ProductSkuEditStatus createState() => new _ProductSkuEditStatus();
}

class _ProductSkuEditStatus extends State<ProductSkuEditScreen> {
  final ProductService _productService = ProductService();

  bool _loading = false;
  bool _saving = false;
  ProductDetailVO _productDetail = ProductDetailVO();

  @override
  void initState() {
    _loading = true;
    _productService.getProductDetail(widget.id.toString()).then((data) {
      this.setState(() {
        _productDetail = data.toVO();
        _loading = false;
      });
    });

    super.initState();
  }

  String get pageTitle {
    return Strings.title_product_sku_detail;
  }

  Widget _buttonBuild(text, textColor, bgColor, onPressed) {
    return MaterialButton(
      minWidth: ScreenAdapter.width(187.5),
      height: ScreenAdapter.height(49.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: ScreenAdapter.fontSize(14.0),
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      color: bgColor,
      onPressed: onPressed,
    );
  }

  final _padding = EdgeInsets.only(
    left: ScreenAdapter.width(12.0),
    right: ScreenAdapter.width(12.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          pageTitle,
        ),
      ),
      body: LoadingWrap(
        loading: _loading,
        saving: _saving,
        savingTips: '保存中...',
        child: ColumnFlexLayout(
          body: CustomSingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: ScreenAdapter.height(55.0),
                  alignment: Alignment.centerLeft,
                  color: AppColors.white,
                  padding: _padding,
                  child: Text(
                    _productDetail.title,
                    style: TextStyle(
                      color: AppColors.black43,
                      fontSize: ScreenAdapter.fontSize(17.0),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenAdapter.height(1.0),
                ),
                Container(
                  color: AppColors.white,
                  padding: _padding,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          top: ScreenAdapter.height(7.5),
                          bottom: ScreenAdapter.height(7.5),
                        ),
                        width: double.infinity,
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _productDetail.images.map((item) {
                              return Container(
                                padding: EdgeInsets.only(
                                  right: ScreenAdapter.width(5.0),
                                ),
                                child: Image(
                                  fit: BoxFit.cover,
                                  width: ScreenAdapter.width(84.0),
                                  height: ScreenAdapter.width(84.0),
                                  image: NetworkImage(item),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Visibility(
                        child: ActionRow(
                          padding: EdgeInsets.all(0),
                          tipsOffset: EdgeInsets.all(0),
                          title: Strings.product_add_form_et_desc_title,
                          tips: Strings.product_add_form_et_desc_tips,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              Routes.product_graphic_desc,
                              arguments: {'html': _productDetail.detail},
                            );
                          },
                        ),
                        visible: _productDetail.detail.isNotEmpty,
                      ),
                    ],
                  ),
                )
              ]..addAll(
                  _productDetail.productSkuPrice.map(
                    (item) {
                      return Column(
                        key: Key(item.skuDisplay),
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: ScreenAdapter.height(44.0),
                            alignment: FractionalOffset(0.0, 0.6),
                            padding: _padding,
                            child: Row(
                              textBaseline: TextBaseline.ideographic,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Visibility(
                                  child: GestureDetector(
                                    child: Image.asset(
                                      Images.product_add_form_delete_sku_btn,
                                      width: ScreenAdapter.width(19.0),
                                    ),
                                    onTap: () => _deleteSku(item),
                                  ),
                                  visible: true,
                                ),
                                SizedBox(
                                  width: ScreenAdapter.width(6.0),
                                ),
                                Text(
                                  item.skuDisplay,
                                  style: TextStyle(
                                    color: AppColors.black43,
                                    fontSize: ScreenAdapter.fontSize(14.0),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ActionBox(
                            children: <Widget>[
                              InputRow(
                                padding: _padding,
                                label: Strings.product_add_form_et_price_title,
                                decoration: InputDecoration(
                                  hintText: Strings
                                      .product_add_form_et_price_placeholder,
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                  signed: false,
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  NumberTextInputFormatter(
                                    max: 999999.00,
                                  )
                                ],
                                onChanged: (newValue) {
                                  try {
                                    item.price = num.parse(newValue);
                                  } catch (e) {
                                    item.price = null;
                                  }
                                },
                                initValue: item.price.toString(),
                              ),
                              InputRow(
                                padding: _padding,
                                label: Strings.product_add_form_et_stock_title,
                                decoration: InputDecoration(
                                  hintText: Strings
                                      .product_add_form_et_stock_placeholder,
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                  signed: false,
                                  decimal: false,
                                ),
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  NumberTextInputFormatter(
                                    digits: 0,
                                    defaultValue: 0,
                                    max: 999,
                                  )
                                ],
                                onChanged: (newValue) {
                                  try {
                                    item.stock = int.parse(newValue);
                                  } catch (e) {
                                    item.stock = null;
                                  }
                                },
                                initValue: item.stock == null
                                    ? ""
                                    : item.stock.toString(),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
            ),
          ),
          bottom: Container(
                  width: double.infinity,
                  child: _buttonBuild(
                    Strings.tips_go_back,
                    AppColors.white,
                    AppColors.primaryRed,
                    () => Navigator.of(context).pop(),
                  ),
                ),
        ),
      ),
    );
  }

  /// 删除sku
  void _deleteSku(item) {
    _productDetail.productSkuPrice.remove(item);
    setState(() {});
  }

}
