/// 直播状态
enum LiveStatus {
  PENDING, // 待开始
  LIVE, // 直播中
  RECORDING, // 已结束
  CLOSED // 已关闭
}

class _LiveStatus {
  _LiveStatus();
  String toStr(LiveStatus status) {
    switch (status) {
      case LiveStatus.PENDING:
        return 'PENDING';
      case LiveStatus.LIVE:
        return 'LIVE';
      case LiveStatus.RECORDING:
        return 'RECORDING';
      case LiveStatus.CLOSED:
        return 'CLOSED';
      default:
        return null;
    }
  }

  LiveStatus fromStr(String status) {
    switch (status) {
      case 'PENDING':
        return LiveStatus.PENDING;
      case 'LIVE':
        return LiveStatus.LIVE;
      case 'RECORDING':
        return LiveStatus.RECORDING;
      case 'CLOSED':
        return LiveStatus.CLOSED;
      default:
        return null;
    }
  }
}

class Live {
  Live._();

  static final _LiveStatus Status = new _LiveStatus();
}
