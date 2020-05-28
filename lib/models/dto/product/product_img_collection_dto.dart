import 'package:app/models/dto/product/product_img_collection_item_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_img_collection_dto.g.dart';

@JsonSerializable()
class ProductImgCollectionDTO {
  String collectionId;

  bool active;

  String displayType;

  String name;

  String siteId;

  int sortOrder;

  List<ProductImgCollectionItemDTO> items;

  ProductImgCollectionDTO(
      {this.collectionId,
      this.displayType,
      this.name,
      this.siteId,
      this.sortOrder,
      this.items});

  factory ProductImgCollectionDTO.fromJson(Map<String, dynamic> json) =>
      _$ProductImgCollectionDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImgCollectionDTOToJson(this);
}
