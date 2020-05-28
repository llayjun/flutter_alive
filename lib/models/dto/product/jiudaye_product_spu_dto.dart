import 'package:app/models/vo/product/product_spu_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jiudaye_product_spu_dto.g.dart';

@JsonSerializable()
class JiuDaYeProductSpuDto {
  String attributeName;

  String optionName;

  JiuDaYeProductSpuDto({
    this.attributeName,
    this.optionName,
  });

  factory JiuDaYeProductSpuDto.fromJson(Map<String, dynamic> json) =>
      _$JiuDaYeProductSpuDtoFromJson(json);

  ProductSpuVO toVO() {
    return ProductSpuVO(
      attributeName: this.attributeName,
      optionName: this.optionName,
    );
  }
}
