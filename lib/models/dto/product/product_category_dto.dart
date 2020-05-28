import 'package:json_annotation/json_annotation.dart';

part 'product_category_dto.g.dart';

@JsonSerializable()
class ProductCategoryDTO {
  String categoryId;

  String code;

  String description;

  String name;

  String parentId;

  String siteId;

  bool suggested;

  dynamic file;

  List<ProductCategoryDTO> children;

  ProductCategoryDTO(
      {this.categoryId,
      this.code,
      this.description,
      this.name,
      this.parentId,
      this.siteId,
      this.suggested,
      this.file,
      this.children});

  factory ProductCategoryDTO.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryDTOFromJson(json);
}
