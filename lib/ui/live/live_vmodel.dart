import 'dart:convert';

import 'package:app/models/view/base_vmodel.dart';
import 'package:app/services/live_service.dart';

import 'package:app/models/dto/live/live_broadcast_dto.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LiveVModel extends BaseViewModel {
  final LiveService _liveService = LiveService();

  List<LiveBroadcastDTO> _liveList = [];

  List<LiveBroadcastDTO> _liveList4Person = [];

  int _pageIndex = 0;

  bool _loadingData = true;
  bool _loadingMore = true;
  bool _nothingMore = false;

  List<LiveBroadcastDTO> get liveList => _liveList;
  List<LiveBroadcastDTO> get liveList4Person => _liveList4Person;

  bool get loadingData => _loadingData;
  bool get loadingMore => _loadingMore;
  bool get nothingMore => _nothingMore;

  /// 获取分页数据
  Future fetchPagingData(bool refresh, String status, String sort) async {
    if (refresh) {
      _pageIndex = 0;
      _loadingData = true;
    } else {
      _pageIndex++;
      _loadingMore = true;
    }
    notifyListeners();
    try {
      await _liveService.getLivePage({"size": 10, "page": _pageIndex, "status":status??"", "sort": sort??""}).then((res) {
        List<LiveBroadcastDTO> data = res.data ?? [];
        if (refresh) {
          _liveList = data;
        } else {
          _liveList.addAll(data);
        }
        _nothingMore = _liveList.length >= res.total;
        _loadingData = false;
        _loadingMore = false;
        notifyListeners();
      });
    } catch (e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      _loadingData = false;
      _loadingMore = false;
      notifyListeners();
    }
  }

  /// 个人主页的3条直播
  Future fetchData4Person() async {
    try {
      await _liveService.getLivePage({"size": 3, "page": 0, "sort": "beginTime", "statuses" : jsonEncode(['PENDING','LIVE'])}).then((res) {
        List<LiveBroadcastDTO> data = res.data ?? [];
        _liveList4Person = data;

        notifyListeners();
      });
    } catch (e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      notifyListeners();
    }
  }

  /// 删除直播
  Future deleteBroadcast(String id) async {
    try {
      await _liveService.deleteBroadcast(id).then((res) {
        if (res.success) {
          CustomToast.showToast(msg: res.msg, gravity: ToastGravity.CENTER);
          fetchPagingData(true, "RECORDING", "endTime");
          notifyListeners();
        }
      });
    } catch (e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      notifyListeners();
    }
  }
}
