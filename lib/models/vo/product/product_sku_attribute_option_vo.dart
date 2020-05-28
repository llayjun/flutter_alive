import 'package:json_annotation/json_annotation.dart';

part 'product_sku_attribute_option_vo.g.dart';

@JsonSerializable()
class ProductSkuAttributeOptionVO {
  int attributeId;
  String attributeName;
  int optionId;
  String optionName;
  ProductSkuAttributeOptionVO({
    this.attributeId,
    this.attributeName,
    this.optionId,
    this.optionName,
  });

  factory ProductSkuAttributeOptionVO.fromJson(Map<String, dynamic> json) =>
      _$ProductSkuAttributeOptionVOFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSkuAttributeOptionVOToJson(this);
}