import 'package:app/models/vo/product/product_sku_attribute_option_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jiudaye_product_sku_attribute_option_dto.g.dart';

@JsonSerializable()
class JiuDaYeProductSkuAttributeOptionDTO {
  int attributeId;
  String attributeName;
  int optionId;
  String optionName;
  JiuDaYeProductSkuAttributeOptionDTO({
    this.attributeId,
    this.attributeName,
    this.optionId,
    this.optionName,
  });

  factory JiuDaYeProductSkuAttributeOptionDTO.fromJson(
          Map<String, dynamic> json) =>
      _$JiuDaYeProductSkuAttributeOptionDTOFromJson(json);

  Map<String, dynamic> toJson() =>
      _$JiuDaYeProductSkuAttributeOptionDTOToJson(this);

  ProductSkuAttributeOptionVO toVO() {
    return ProductSkuAttributeOptionVO(
      attributeId: this.attributeId,
      attributeName: this.attributeName,
      optionId: this.optionId,
      optionName: this.optionName,
    );
  }
}
