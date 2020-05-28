import 'package:app/constants/app_theme.dart';
import 'package:app/constants/strings.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:flutter/material.dart';

enum ProductItemRowLayout { DEFAULT, ORDER }

// 占满整行的商品模块（ui）封装
class ProductItemRow extends StatelessWidget {
  ProductItemRow({
    Key key,
    this.layoutType = ProductItemRowLayout.DEFAULT,
    this.left,
    this.right,
    this.gap,
    this.padding,
    this.image,
    this.name,
    this.price,
    this.stock,
    this.loclStock,
    this.sales,
    this.attributes,
    this.count,
    this.onPressed,
  }) : super(key: key);

  final ProductItemRowLayout layoutType; // 布局方式

  final Widget left; // 左插槽
  final Widget right; // 右插槽

  final EdgeInsetsGeometry gap; // 间隔
  final EdgeInsetsGeometry padding; // 内边距

  final String image;
  final String name;
  final num price;

  /// only for ProductItemRowLayout.DEFAULT
  final int stock; // 库存
  final int loclStock; // 锁定存库
  final int sales; // 销量

  /// only for ProductItemRowLayout.ORDER
  final String attributes; // 目前先使用String类型，后面可以使用具体模型通过遍历等方式拼接成String
  final int count;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Widget _pressWidgetBuild(Widget pressChild) {
      return GestureDetector(
        onTap: () {
          if (this.onPressed != null) {
            this.onPressed();
          }
        },
        child: pressChild,
      );
    }

    List<Widget> _children = [];

    if (left != null) {
      _children.add(left);
    }

    _children.add(
      _pressWidgetBuild(
        Image(
          fit: BoxFit.contain,
          width: ScreenAdapter.width(70.0),
          height: ScreenAdapter.width(70.0),
          image: NetworkImage(image ?? ''),
        ),
      ),
    );

    switch (layoutType) {
      case ProductItemRowLayout.DEFAULT:
        _children.add(
          Expanded(
            flex: 1,
            child: _pressWidgetBuild(
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: ScreenAdapter.width(12.0),
                  right: ScreenAdapter.width(33.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12.0),
                        color: AppColors.black43,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenAdapter.height(3.0),
                        bottom: ScreenAdapter.height(4.0),
                      ),
                      child: Text(
                        '${Strings.symbol_rmb}${price ?? ''}',
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(14.0),
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '库存 ${stock ?? '-'}件' +
                          '    ' +
                          (loclStock != null
                              ? '锁定库存 ${loclStock ?? '-'}件     '
                              : '') +
                          '销量 ${sales ?? '-'}件',
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12.0),
                        color: AppColors.black999,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      case ProductItemRowLayout.ORDER:
        _children.add(
          Expanded(
            flex: 1,
            child: _pressWidgetBuild(
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: ScreenAdapter.height(14.0),
                  bottom: ScreenAdapter.height(14.0),
                  left: ScreenAdapter.width(12.0),
                  right: ScreenAdapter.width(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(12.0),
                            color: AppColors.black43,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: ScreenAdapter.height(5.0),
                        ),
                        Text(
                          attributes ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(12.0),
                            color: AppColors.black666,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${Strings.symbol_rmb}${price ?? '-'}',
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(14.0),
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${Strings.symbol_count_prefix}${count ?? '-'}',
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(14.0),
                            color: AppColors.black666,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;
    }

    if (right != null) {
      _children.add(right);
    }

    return Padding(
      padding: gap ?? EdgeInsets.all(0),
      child: Container(
        height: ScreenAdapter.height(100.0),
        color: AppColors.white,
        padding: padding ?? EdgeInsets.only(left: ScreenAdapter.width(12.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _children,
        ),
      ),
    );
  }
}
