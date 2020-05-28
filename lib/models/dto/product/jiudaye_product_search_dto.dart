import 'package:app/models/vo/product/jiudaye_product_search_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jiudaye_product_search_dto.g.dart';

@JsonSerializable()
class JiuDaYeProductSearchJiuDaYeDTO {
  int jiuDaYeProductId;

  String title;
  int saleStatus;
  num minPrice;
  num maxPrice;
  int customization;
  int customerLimit;

  int productImageId;
  String productImageUrl;

  JiuDaYeProductSearchJiuDaYeDTO(
      {this.jiuDaYeProductId,
      this.title,
      this.saleStatus,
      this.minPrice,
      this.maxPrice,
      this.customization,
      this.customerLimit,
      this.productImageId,
      this.productImageUrl});

  factory JiuDaYeProductSearchJiuDaYeDTO.fromJson(Map<String, dynamic> json) =>
      _$JiuDaYeProductSearchJiuDaYeDTOFromJson(json);

  JiuDaYeProductSearchVO toVO() {
    return JiuDaYeProductSearchVO(
        id: this.jiuDaYeProductId,
        price: this.minPrice,
        originPrice: this.maxPrice,
        image: this.productImageUrl,
        title: this.title);
  }
}
