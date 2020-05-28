import 'package:app/models/dto/product/jiudaye_product_sku_attribute_option_dto.dart';
import 'package:app/models/vo/product/product_sku_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jiudaye_product_sku_dto.g.dart';

@JsonSerializable()
class JiuDaYeProductSkuDto {
  String skuCartesian;

  num marketPrice;

  num price;

  int productSkuImageId;

  String productSkuImageUrl;

  List<String> parseSkuCartesians;

  List<String> splitSkuCartesians;

  List<JiuDaYeProductSkuAttributeOptionDTO> attributeOptions;

  int stock;

  JiuDaYeProductSkuDto({
    this.skuCartesian,
    this.marketPrice,
    this.price,
    this.productSkuImageId,
    this.productSkuImageUrl,
    this.parseSkuCartesians,
    this.splitSkuCartesians,
    this.attributeOptions,
    this.stock,
  });

  factory JiuDaYeProductSkuDto.fromJson(Map<String, dynamic> json) =>
      _$JiuDaYeProductSkuDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JiuDaYeProductSkuDtoToJson(this);

  ProductSkuVO toVO() {
    return ProductSkuVO(
      skuDisplay: this.parseSkuCartesians.join(","),
      marketPrice: this.marketPrice,
      price: this.price,
      attributeOptions: this.attributeOptions.map((item) {
        return item.toVO();
      }).toList(),
      stock: this.stock,
    );
  }
}
