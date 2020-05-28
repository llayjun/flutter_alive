import 'package:app/models/vo/product/product_brand_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_brand_dto.g.dart';
@JsonSerializable()
class ProductBrandDTO {
  String name;

  String imageUrl;

  String extData;

  ProductBrandDTO({this.name, this.imageUrl, this.extData});

  factory ProductBrandDTO.fromJson(Map<String, dynamic> json) =>
      _$ProductBrandDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProductBrandDTOToJson(this);

  ProductBrandVO toVO(){
    return ProductBrandVO(
      name: this.name,
      imageUrl: this.imageUrl,
      extData: this.extData,
    );
  }
}
