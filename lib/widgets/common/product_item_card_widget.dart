import 'package:app/constants/app_theme.dart';
import 'package:app/constants/strings.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:flutter/material.dart';

class ProductItemCard extends StatelessWidget {
  ProductItemCard({
    Key key,
    this.width,
    this.image,
    this.name,
    this.price,
    this.originPrice,
    this.onPressed,
    this.floatBtn,
    this.backgroundColor = Colors.transparent,
    this.textPadding = false,
    this.fillHeight = false,
  }) : super();

  final double width;
  final String image;
  final String name;
  final num price;
  final num originPrice;
  final VoidCallback onPressed;
  final Widget floatBtn;
  final Color backgroundColor;
  final bool textPadding;
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Container(
        width: width,
        color: backgroundColor,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: fillHeight ? ScreenAdapter.height(250.0) : 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: Image(
                  color: AppColors.greyF4,
                  colorBlendMode: BlendMode.dstATop,
                  fit: BoxFit.cover,
                  image: NetworkImage(image),
                ),
              ),
              Padding(
                padding: textPadding
                    ? EdgeInsets.symmetric(
                        vertical: ScreenAdapter.height(9.0),
                        horizontal: ScreenAdapter.height(7.0),
                      )
                    : EdgeInsets.only(
                        top: ScreenAdapter.height(6.0),
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.black43,
                        fontSize: ScreenAdapter.fontSize(14.0),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: ScreenAdapter.height(
                        floatBtn != null ? 3.0 : 6.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${Strings.symbol_rmb}${price}',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: AppColors.primaryRed,
                                fontSize: ScreenAdapter.fontSize(16.0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: ScreenAdapter.width(2.5),
                            ),
                            Text(
                              '${Strings.symbol_rmb}${originPrice}',
                              style: TextStyle(
                                color: AppColors.black999,
                                fontSize: ScreenAdapter.fontSize(12.0),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        )
                      ]..addAll(floatBtn != null ? [floatBtn] : []),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
