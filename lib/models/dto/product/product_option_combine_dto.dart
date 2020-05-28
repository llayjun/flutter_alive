import 'package:app/models/vo/product/product_sku_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_option_combine_dto.g.dart';

@JsonSerializable()
class ProductOptionCombineDTO {
  String combineId;

  bool buyIfNoStock;

  String combineDisplay;

  Map<String,String> combineMap;

  num marketPrice;

  int minStockToAlarm;

  num price;

  String productId;

  String sku;

  int stock;

  bool stockAlarm;

  num volume;

  num weight;

  List<dynamic> images;


  ProductOptionCombineDTO({this.combineId, this.buyIfNoStock,
      this.combineDisplay, this.combineMap, this.marketPrice,
      this.minStockToAlarm, this.price, this.productId, this.sku, this.stock,
      this.stockAlarm, this.volume, this.weight, this.images});

  factory ProductOptionCombineDTO.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionCombineDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOptionCombineDTOToJson(this);

  ProductSkuVO toVO() {
    return ProductSkuVO(
      combineId: this.combineId,
      productId: this.productId,
      skuDisplay: this.combineDisplay,
      marketPrice: this.marketPrice,
      price: this.price,
      stock: this.stock
    );
  }
}
