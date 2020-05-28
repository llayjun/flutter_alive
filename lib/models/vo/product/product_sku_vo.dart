import 'package:app/models/vo/product/product_sku_attribute_option_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_sku_vo.g.dart';

@JsonSerializable()
class ProductSkuVO {
  String combineId;
  String productId;
  String skuDisplay;
  num marketPrice;
  num price;
  List<ProductSkuAttributeOptionVO> attributeOptions;
  int stock = 0;
  ProductSkuVO({
    this.combineId,
    this.productId,
    this.skuDisplay,
    this.marketPrice,
    this.price,
    this.attributeOptions = const [],
    this.stock = 0,
  });

  Map<String, dynamic> toJson() => _$ProductSkuVOToJson(this);
  factory ProductSkuVO.fromJson(Map<String, dynamic> json) => _$ProductSkuVOFromJson(json);
}