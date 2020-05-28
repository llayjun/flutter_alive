import 'package:app/models/dto/product/product_brand_dto.dart';
import 'package:app/models/dto/product/jiudaye_product_sku_dto.dart';
import 'package:app/models/dto/product/jiudaye_product_spu_dto.dart';
import 'package:app/models/vo/product/product_detail_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jiudaye_product_detail_dto.g.dart';

@JsonSerializable()
class JiuDaYeProductDetailDTO {
  int id;
  List<String> productImages;
  num marketPrice;
  num minPrice;
  num maxPrice;
  String title;
  String description;
  String detail;
  Map<String, String> productOptionTypes;
  List<JiuDaYeProductSkuDto> productSkuPrice;
  List<JiuDaYeProductSpuDto> productSpus;
  Map productEvaluation;
  ProductBrandDTO productBrand;

  JiuDaYeProductDetailDTO({
    this.id,
    this.productImages,
    this.marketPrice,
    this.minPrice,
    this.maxPrice,
    this.title,
    this.description,
    this.detail,
    this.productOptionTypes,
    this.productEvaluation,
    this.productBrand,
    this.productSkuPrice,
    this.productSpus,
  });

  factory JiuDaYeProductDetailDTO.fromJson(Map<String, dynamic> json) =>
      _$JiuDaYeProductDetailDTOFromJson(json);

  ProductDetailVO toVO() {
    return ProductDetailVO.fromDTO(this);
  }
}
