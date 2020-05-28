import 'dart:math';

import 'package:app/constants/app_theme.dart';
import 'package:app/entry/config.dart';
import 'package:app/models/dto/adress/address_info_dto.dart';
import 'package:app/models/dto/basic_dto.dart';
import 'package:app/models/vo/mine/my_amount_vo.dart';
import 'package:app/repository/remote_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

typedef GetBackValue = Future<void> Function(dynamic value);

class SelectAddressWidget extends StatefulWidget {
  ///回调函数
  final GetBackValue valueCb;
  final AddressInfoDTO infoDTO;



  SelectAddressWidget({Key key, @required this.valueCb,this.infoDTO}) : super(key: key);

  @override
  _SelectAddressWidgetState createState() {
    return _SelectAddressWidgetState();
  }
}

class _SelectAddressWidgetState extends State<SelectAddressWidget>
    with SingleTickerProviderStateMixin {
  ///区域信息列表
  List<AddressProModel> localList = [];

  ///TabBarController
  TabController _tabController;

  ///选择的省市县的名字
  String selectProvinceStr = '省份';
  String selectCityStr = '城市';
  String selectDistrictStr = '区/县';

  ///选择的省市县Id
  int selectProvinceId = -1;
  int selectCityId = -1;
  int selectDistrictId = -1;


  ///当前Tab位置
  int currentTabPos = 0;

  Map<String, dynamic> selectMap = new Map();

  ///Tab Text样式
  TextStyle tabTvStyle = new TextStyle(
      color: AppColors.Color_333333,
      fontSize: 16.0,
      fontWeight: FontWeight.normal);

  @override
  void initState() {
    super.initState();

    ///给区域Id Map一个初始值
    selectMap['selectProvinceId'] = -1;
    selectMap['selectCityId'] = -1;
    selectMap['selectDistrictId'] = -1;
//    if(widget.infoDTO.indexList.length>0) {
//      print(widget.infoDTO.districtFmt);
//      List _list = widget.infoDTO.districtFmt.split(' ');
//      selectMap['selectProvinceId'] = int.parse(widget.infoDTO.indexList[0]);
//      selectMap['selectCityId'] = int.parse(widget.infoDTO.indexList[1]);
//      selectProvinceStr = _list.first;
//      selectCityStr = _list[1];
//      if(widget.infoDTO.indexList.length>2) {
//        selectMap['selectDistrictId'] =int.parse(widget.infoDTO.indexList[2]);
//        selectCityStr = _list.last;
//      }
//
//    }

    ///初始化控制器
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      ///获取tab当前点击位置
      currentTabPos = _tabController.index;

      ///切换Tab重新请求列表数据
      if (_checkTabCanSelect(currentTabPos)) {
        _queryLocal(currentTabPos == 0
            ? '0'
            : currentTabPos == 1
                ? selectProvinceId.toString()
                : selectCityId.toString());
      }

      print(currentTabPos);
    });
    ///第一次进来
//    if(widget.infoDTO.indexList.length>0) {
//      _queryLocal(widget.infoDTO.indexList.last);
//    }else {
//
//    }

    _queryLocal('0');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        ///去掉左箭头
        automaticallyImplyLeading: false,
        title: Text(
          '选择地址',
          style: TextStyle(color: AppColors.Color_666666),
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: AppColors.Color_666666,
              ),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      body: _getBody(),
    );
    ;
  }

  ///构建底部视图
  Widget _getBody() {
    if (_showLoadingDialog()) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return _buildContent();
    }
  }

  ///根据数据是否有返回显示加载条或者列表
  bool _showLoadingDialog() {
    if (localList == null || localList.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  ///有数据时构建tab和区域列表
  Widget _buildContent() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Padding(padding: const EdgeInsets.only(top: 15.0)),
          new TabBar(
            indicatorColor: AppColors.Color_F9515A,
            controller: _tabController,
            tabs: <Widget>[
              new Text(
                '$selectProvinceStr',
                style: tabTvStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              new Text(
                '$selectCityStr',
                style: tabTvStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              new Text(
                '$selectDistrictStr',
                style: tabTvStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          new Padding(padding: const EdgeInsets.only(top: 10.0)),
          _buildListView(),
        ],
      ),
      color: Colors.white,
    );
  }

  ///构建列表
  Widget _buildListView() {
    return new Expanded(
        child: new ListView.builder(
      shrinkWrap: true,
      itemCount: localList.length,
      itemBuilder: (BuildContext context, int position) {
        return _buildListRow(position);
      },
    ));
  }

  ///构建子项
  Widget _buildListRow(int position) {
    return new ListTile(
      title: new Text(
        '${localList[position].name}',
        style: new TextStyle(color: AppColors.Color_666666, fontSize: 15.0),
      ),
      onTap: () => _onLocalSelect(position),
    );
  }

  ///区域位置选择
  _onLocalSelect(int position) {
    _setSelectData(position);
    if (currentTabPos != 2) {
      _queryLocal(localList[position].districtId);
    }
  }

  ///设置选择的数据
  ///根据当前选择的列表项的position 和 Tab的currentTabPos
  ///@params position 当前列表选择的省或市或县的position
  _setSelectData(position) {
    if (currentTabPos == 0) {
      selectProvinceId = int.parse(localList[position].districtId);
      selectProvinceStr = localList[position].name;
      selectMap['selectProvinceId'] = selectProvinceId;
      setState(() {
        selectCityStr = '城市';
        selectDistrictStr = '区/县';
      });
      selectCityId = -1;
      selectDistrictId = -1;
    }

    if (currentTabPos == 1) {
      selectCityId = int.parse(localList[position].districtId);
      selectCityStr = localList[position].name;
      selectMap['selectCityId'] = selectCityId;
      setState(() {
        selectDistrictStr = '区/县';
      });
      selectDistrictId = -1;
    }

    if (currentTabPos == 2) {
      selectDistrictId = int.parse(localList[position].districtId);
      selectDistrictStr = localList[position].name;
      selectMap['selectDistrictId'] = selectDistrictId;

      ///拼接区域字符串 回调给上个页面 关闭弹窗
      String localStr =
          selectProvinceStr + ' ' + selectCityStr + ' ' + selectDistrictStr;
      selectMap['addressdetail'] = localStr;
      widget.valueCb(selectMap);
      Navigator.pop(context);
    }else {
      currentTabPos++;
      _tabController.animateTo(currentTabPos);
    }
  }

  ///检查是否可以选择下级Tab
  bool _checkTabCanSelect(int position) {
    if (position == 0) {
      return true;
    }
    if (position == 1) {
      if (selectProvinceId == -1) {
        _tabController.animateTo(0);
        _showSnack();
        return false;
      }
      return true;
    }

    if (position == 2) {
      if (selectProvinceId == -1 && selectCityId == -1) {
        _tabController.animateTo(0);
        _showSnack();
        return false;
      }
      if (selectProvinceId != -1 && selectCityId == -1) {
        _tabController.animateTo(1);
        _showSnack();
        return false;
      }
      return true;
    }
  }

  ///显示错误信息
  _showSnack() {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: new Text('请先选择上级地区')));
  }

  ///查询区域信息
  _queryLocal(String parentId) async {
    Dio dio = new Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    Response response = await dio
        .get('${Config.inst.apiUrl}/api/districts?parentId=${parentId}');
    BasicDTO<List<AddressProModel>> bean;
    if (response != null || response.data != null) {
      bean = BasicDTO.fromJson(response.data);
      if (bean.success) {
        localList = bean.data
            .map<AddressProModel>((pItem) => AddressProModel.fromJson(pItem))
            .toList();

        if ((currentTabPos == 2 && bean.data == null) || localList.length == 0) {
          String localStr = selectProvinceStr + ' ' + selectCityStr;
          selectMap['addressdetail'] = localStr;
          widget.valueCb(selectMap);
          Navigator.pop(context);
        }
        setState(() {});
      }
    }
  }
}
