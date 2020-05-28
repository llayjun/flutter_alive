import 'package:app/constants/app_theme.dart';
import 'package:app/constants/strings.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:app/widgets/overwrite/custom_single_child_scroll_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductGraphicDescScreen extends StatelessWidget {
  ProductGraphicDescScreen({Key key, this.html}) : super(key: key);
  final String html;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(Strings.title_product_graphic_desc),
      ),
      body: CustomSingleChildScrollView(
        child: Html(
          backgroundColor: AppColors.white,
          data: this.html,
        ),
      ),
    );
  }
}
