import 'package:app/models/vo/live/live_product_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_product_dto.g.dart';

@JsonSerializable()
class LiveProductDTO {
  
  /// ID
  String id;

  /// 商品ID
  String productId;

  /// 名称
  String name;

  /// 价格
  num price;

  /// 原价
  num originPrice;

  /// 图片
  String img;

  /// 直播间ID
  String lbId;

  /// 库存
  int stock;

  /// 销量
  int sales;

  LiveProductDTO(
      {this.id,
      this.name,
      this.price,
      this.originPrice,
      this.img,
      this.stock,
      this.sales,
      this.lbId});

  factory LiveProductDTO.fromJson(Map<String, dynamic> json) =>
      _$LiveProductDTOFromJson(json);

  LiveProductVO toVO(bool _checked) {
    return LiveProductVO(
      id: this.id,
      productId: this.productId,
      name: this.name,
      price: this.price,
      originPrice: this.originPrice,
      img: this.img,
      stock: this.stock,
      sales: this.sales,
      checked: _checked,
    );
  }
}
