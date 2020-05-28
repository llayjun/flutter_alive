import 'package:app/constants/app_theme.dart';
import 'package:app/constants/strings.dart';
import 'package:app/models/vo/live/live_product_vo.dart';
import 'package:app/models/vo/product/product_vo.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/vmodel/product_manage_vmodel.dart';
import 'package:app/widgets/common/loading_wrap_widget.dart';
import 'package:app/widgets/common/product_item_row_widget.dart';
import 'package:app/widgets/layout/column_flex_layout_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:app/widgets/overwrite/custom_checkbox_widget.dart';
import 'package:app/widgets/basic/iconfont_widget.dart';
import 'package:app/widgets/overwrite/custom_single_child_scroll_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LiveCreateLinkProductScreen extends StatefulWidget {
  LiveCreateLinkProductScreen({Key key, this.linkProductList})
      : super(key: key);

  final List<LiveProductVO> linkProductList;

  @override
  _LiveCreateLinkProductStatus createState() => _LiveCreateLinkProductStatus();
}

class _LiveCreateLinkProductStatus extends State<LiveCreateLinkProductScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<LiveProductVO> _productList = [];

  bool _loadingData = true;
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    new Future.delayed(Duration.zero, () {
      _fetchData(true);
    });
  }

  Future<void> _fetchData(bool refresh) async {
//    if (refresh) {
//      List<ProductVO> _alreadyList = Provider.of<ProductManageModel>(context).productList();
//      if (_alreadyList.length > 0) {
//        _productList = _alreadyList.map((item) {
//          return LiveProductVO(
//            name: item.name,
//            price: item.minPrice,
//            originPrice: item.maxPrice,
//            productId: item.productId,
//            stock: item.stock,
//            sales: item.saleAmount,
//            img: item.imageUrl,
//            checked: widget.linkProductList.any((LiveProductVO linkProduct) {
//              if (linkProduct.productId == item.productId) {
//                return true;
//              }
//              return false;
//            }),
//          );
//        }).toList();
//        _loadingData = false;
//        setState(() {});
//        return;
//      }
//    }
    if (refresh) {
      _loadingData = true;
    } else {
      _loadingMore = true;
    }
    setState(() {});
    List<ProductVO> _list = await Provider.of<ProductManageModel>(context).fetchData(refresh);
    _productList = _productList
      ..addAll(_list.map((item) {
        return LiveProductVO(
          name: item.name,
          price: item.minPrice,
          originPrice: item.maxPrice,
          productId: item.productId,
          stock: item.stock,
          sales: item.saleAmount,
          img: item.imageUrl,
          checked: widget.linkProductList.any((LiveProductVO linkProduct) {
            if (linkProduct.productId == item.productId) {
              return true;
            }
            return false;
          }),
        );
      }).toList());
    _loadingData = false;
    _loadingMore = false;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleChange(String id, bool newVal) {
    for (int n = 0; n < _productList.length; n++) {
      if (_productList[n].productId == id) {
        setState(() {
          _productList[n].checked = newVal;
        });
        break;
      }
    }
  }

  void _handleCommit() {
    // 目前回退（非点击“选好了”按钮）并不能更新选择结果
    Navigator.of(context).pop(
      _productList.where((item) => item.checked).toList(),
    );
  }

  Widget _buildItem(LiveProductVO info, bool checked) {
    return ProductItemRow(
      gap: EdgeInsets.only(top: 1.0),
      padding: EdgeInsets.all(0),
      left: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(46.0),
        child: checked
            ? FlatButton(
                padding: EdgeInsets.only(right: 0),
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  padding: EdgeInsets.all(0.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    color: AppColors.primaryRed,
                  ),
                  child: Icon(
                    IconFont.minus,
                    color: AppColors.white,
                    size: ScreenAdapter.width(10.0),
                  ),
                ),
                onPressed: () {
                  _handleChange(info.productId, false);
                },
              )
            : CustomCheckbox(
                value: info.checked,
                onChanged: (bool val) {
                  _handleChange(info.productId, val);
                },
              ),
      ),
      image: info.img,
      name: info.name,
      price: info.price,
      stock: info.stock,
      sales: info.sales,
      onPressed: (){
//        Navigator.of(context).pushNamed(Routes.product_sku_edit, arguments: {
//          'id': info.productId,
//        });
      },
    );
  }

  List<Widget> _getList(bool checked) {
    // TODO 若后面已选项不是在_productList里面的，则需要特别处理
    return _productList
        .where((item) => !checked || item.checked)
        .map<Widget>((f) => _buildItem(f, checked))
        .toList();
  }

  Widget _buildBtn(text, onPressed, [isPrimary = true]) {
    return Expanded(
      flex: 1,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: ScreenAdapter.fontSize(14.0),
            color: isPrimary ? AppColors.white : AppColors.primaryRed,
          ),
        ),
        color: isPrimary ? AppColors.primaryRed : AppColors.secondaryRed,
        height: ScreenAdapter.height(49.0),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _unlinkList = _getList(false);
    final _linkList = _getList(true);
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(Strings.title_link_product),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: Strings.live_link_product_tab_relevance,
            ),
            Tab(
              text: Strings.live_link_product_tab_irrelevance,
            ),
          ],
        ),
      ),
      body: LoadingWrap(
        loading: _loadingData,
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            Container(
              height: double.infinity,
              child: ColumnFlexLayout(
                body: CustomSingleChildScrollView(
                  loading: _loadingMore,
                  onLoadMore: () => _fetchData(false),
                  empty: _unlinkList.length <= 0,
                  emptySlot: Column(
                    children: <Widget>[
                      SizedBox(height: ScreenAdapter.height(200.0)),
                      Text('你还没有在售的商品，快去添加吧~'),
                      SizedBox(height: ScreenAdapter.height(5.0)),
                    ],
                  ),
                  child: Column(
                    children: _unlinkList,
                  ),
                ),
                bottom: Row(
                  children: <Widget>[
                    Visibility(
                      child: _buildBtn(
                        Strings.live_link_product_btn_selected,
                        _handleCommit,
                      ),
                      visible: _linkList.length > 0,
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: CustomSingleChildScrollView(
                    empty: _linkList.length <= 0,
                    emptyText: '还没添加关联商品哦~',
                    child: Column(
                      children: _linkList,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    _buildBtn(
                      _linkList.length <= 0
                          ? Strings.live_link_product_btn_adding
                          : Strings.live_link_product_btn_continue_adding,
                      () => _tabController.index = 0,
                      false,
                    ),
                    Visibility(
                      child: _buildBtn(
                        Strings.live_link_product_btn_selected,
                        _handleCommit,
                      ),
                      visible: _linkList.length > 0,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
