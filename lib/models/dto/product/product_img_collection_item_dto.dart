import 'package:json_annotation/json_annotation.dart';

part 'product_img_collection_item_dto.g.dart';

@JsonSerializable()
class ProductImgCollectionItemDTO {
  String itemId;

  String link;

  String linkType;

  String linkId;

  int sortOrder;

  String title;

  dynamic file;

  String collectionId;

  ProductImgCollectionItemDTO(
      {this.itemId,
      this.link,
      this.linkType,
      this.linkId,
      this.sortOrder,
      this.title,
      this.file,
      this.collectionId});

  factory ProductImgCollectionItemDTO.fromJson(Map<String, dynamic> json) =>
      _$ProductImgCollectionItemDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImgCollectionItemDTOToJson(this);
}
