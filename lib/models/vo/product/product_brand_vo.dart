
import 'package:json_annotation/json_annotation.dart';

part 'product_brand_vo.g.dart';

@JsonSerializable()
class ProductBrandVO {
  String name;
  String imageUrl;
  String extData;
  ProductBrandVO({
    this.name,
    this.imageUrl,
    this.extData,
  });

  factory ProductBrandVO.fromJson(Map<String, dynamic> json) =>
      _$ProductBrandVOFromJson(json);

  Map<String, dynamic> toJson() => _$ProductBrandVOToJson(this);
}