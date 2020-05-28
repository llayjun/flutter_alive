
import 'package:json_annotation/json_annotation.dart';

part 'live_product_vo.g.dart';

@JsonSerializable()
class LiveProductVO {
  String id;
  String productId;
  String name;
  num price;
  num originPrice;
  String img;
  int stock;
  int sales;
  bool checked;


  LiveProductVO({
    this.id,
    this.productId,
    this.name,
    this.price,
    this.originPrice,
    this.img,
    this.stock,
    this.sales,
    this.checked
  });

  Map<String, dynamic> toJson() => _$LiveProductVOToJson(this);
}