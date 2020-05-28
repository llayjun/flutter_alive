import 'package:json_annotation/json_annotation.dart';

part 'product_option_type_dto.g.dart';

@JsonSerializable()
class ProductOptionTypeDTO {
  String typeId;
  String name;
  String siteId;

  ProductOptionTypeDTO({this.typeId, this.name, this.siteId});

  factory ProductOptionTypeDTO.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionTypeDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOptionTypeDTOToJson(this);
}
