import 'package:app/models/dto/live/live_product_dto.dart';
import 'package:app/models/dto/sys/file_dto.dart';

class LiveBroadcastDTO {
  String id;

  /// 标题
  String title;

  /// 直播描述
  String description;

  /// 开始时间
  String beginTime;

  /// 结束时间
  String endTime;

  /// 封面图ID 1:1
  FileDTO squareCover;

  /// 竖直图ID 9:16
  FileDTO verticalCover;

  /// 封面图ID 16:9
  FileDTO bannerCover;

  /// 状态
  String status;

  /// 微信小程序码图片
  dynamic minAppCodeImg;

  /// 商品数据
  List<LiveProductDTO> products;

  /// 总赞
  int totalPraise;

  /// 总观看
  int totalView;

  /// 编辑次数
  int editTime;

  /// 直播预告图片
  String sharePosterPending;

  LiveBroadcastDTO(
      {this.id,
      this.title,
      this.description,
      this.beginTime,
      this.endTime,
      this.squareCover,
      this.verticalCover,
      this.bannerCover,
      this.status,
      this.minAppCodeImg,
      this.products,
      this.totalPraise,
      this.totalView,
      this.editTime,
      this.sharePosterPending});

    factory LiveBroadcastDTO.fromJson(Map<String, dynamic> json) {
        return LiveBroadcastDTO(
            bannerCover: json['bannerCover'] != null ? FileDTO.fromJson(json['bannerCover']) : null,
            beginTime: json['beginTime'], 
            description: json['description'],
            editTime: json['editTime'], 
            endTime: json['endTime'], 
            id: json['id'], 
            minAppCodeImg: json['minAppCodeImg'] != null ? json['minAppCodeImg'] : null,
            products: json['products'] != null ? (json['products'] as List).map((i) => LiveProductDTO.fromJson(i)).toList() : null,
            squareCover: json['squareCover'] != null ? FileDTO.fromJson(json['squareCover']) : null,
            status: json['status'], 
            title: json['title'], 
            totalPraise: json['totalPraise'], 
            totalView: json['totalView'],
            sharePosterPending: json['sharePosterPending'],
            verticalCover: json['verticalCover'] != null ? FileDTO.fromJson(json['verticalCover']) : null,
        );
    }
}
