import 'package:app/constants/app_theme.dart';
import 'package:app/models/dto/user/customer_site_relation_dto.dart';
import 'package:app/services/user_service.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/widgets/common/loading_wrap_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:app/widgets/overwrite/custom_single_child_scroll_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FansScreen extends StatefulWidget {
  FansScreen();

  @override
  _FansState createState() => _FansState();
}

class _FansState extends State<FansScreen> {
  final UserService _userService = UserService();

  bool _init = true;
  bool _loadingMore = false;
  bool _nothingMore = false;

  int _pageIndex = 0;

  List<CustomerSiteRelationDTO> _list = [];

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      _fetchData(true);
      setState(() {
        _init = false;
      });
    });
  }

  Future _fetchData(bool refresh) async {
    if (refresh) {
      _pageIndex = 0;
    } else {
      _pageIndex++;
      _loadingMore = true;
    }
    setState(() {});
    try {
      var respond =
          await _userService.getFans({"size": "10", "page": _pageIndex});
      var result = respond.data ?? [];
      if (refresh) {
        _list = result;
      } else {
        if (_list == null) {
          _list = result;
        } else {
          _list.addAll(result);
        }
      }
      _pageIndex++;
      _nothingMore = _list.length >= respond.total;

      setState(() {});
    } catch (e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: Text('粉丝列表'),
      ),
      body: LoadingWrap(
        loading: _init,
        child: RefreshIndicator(
          onRefresh: () => _fetchData(true),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomSingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              loading: _loadingMore,
              onLoadMore: () => _fetchData(false),
              empty: _list.length <= 0,
              emptyText: '你一个粉丝都没有',
              finished: _nothingMore,
              finishedText: '就这么多粉丝啦~',
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: _list.map((item) {
                    return Container(
                      height: ScreenAdapter.height(80.0),
                      padding: EdgeInsets.only(
                        left: ScreenAdapter.width(12.0),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          ClipOval(
                            child: Image(
                              width: ScreenAdapter.width(50.0),
                              height: ScreenAdapter.width(50.0),
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                '${item.customer.file['url']??'https://apex-platform-test2.oss-cn-shanghai.aliyuncs.com/upload/test/072ca09d-2bbf-4e1a-bf58-23687d1fa00f.jpg'}',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ScreenAdapter.width(15.0),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${item.customer.nickname??item.customer.username}',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: ScreenAdapter.fontSize(17.0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: ScreenAdapter.height(3.0)),
                              Text(
                                '${item.createDate}',
                                style: TextStyle(
                                  color: AppColors.black999,
                                  fontSize: ScreenAdapter.fontSize(14.0),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  color: AppColors.greyF3,
                ).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
