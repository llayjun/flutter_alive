import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:flutter/material.dart';

class CustomSingleChildScrollView extends StatefulWidget {
  CustomSingleChildScrollView({
    Key key,
    this.physics,
    this.onLoadMore,
    this.child,
    this.loading = false,
    this.finished = false,
    this.empty = false,
    this.loadingText = '加载中...',
    this.finishedText = '我是有底线的~',
    this.emptyText = '啥都木有哦~',
    this.emptySlot,
  }) : super(key: key);

  final ScrollPhysics physics;

  // 触发加载更多逻辑时会使用的回调
  final VoidCallback onLoadMore;

  // 内容
  final Widget child;

  // 判断是否为加载中状态
  final bool loading;

  // 判断是否还能继续加载
  final bool finished;

  // 判断是否为空
  final bool empty;

  // 加载中的提示文案
  final String loadingText;

  // 没有更多可以加载的数据时的提示文案
  final String finishedText;

  // 如果没有数据显示文案
  final String emptyText;
  final Widget emptySlot;

  @override
  _CustomSingleChildScrollViewStatus createState() =>
      new _CustomSingleChildScrollViewStatus();
}

class _CustomSingleChildScrollViewStatus
    extends State<CustomSingleChildScrollView> {
  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (widget.loading ||
          _scrollController.position.maxScrollExtent !=
              _scrollController.position.pixels ||
          widget.finished) {
        return;
      }
      if(widget.onLoadMore != null){
        widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext contetx) {
    Widget _emptyWidget = widget.emptySlot;
    if (_emptyWidget == null) {
      _emptyWidget = Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: ScreenAdapter.height(110.0),
            ),
            Image(
              width: ScreenAdapter.width(90.0),
              fit: BoxFit.fitWidth,
              image: AssetImage(Images.empty),
            ),
            SizedBox(
              height: ScreenAdapter.height(26.0),
            ),
            Text(
              widget.emptyText,
              style: TextStyle(
                fontSize: ScreenAdapter.fontSize(17.0),
                color: AppColors.greyAF,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      );
    }

    String tips = widget.loading
        ? widget.loadingText
        : (widget.finished ? widget.finishedText : '');
    return SingleChildScrollView(
      physics: widget.physics,
      controller: _scrollController,
      child: widget.empty
          ? _emptyWidget
          : Column(
              children: <Widget>[
                widget.child,
                tips.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        height: ScreenAdapter.height(40.0),
                        alignment: Alignment.center,
                        child: Text(
                          tips,
                          style: TextStyle(
                            color: AppColors.black999,
                            fontSize: ScreenAdapter.fontSize(12.0),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
