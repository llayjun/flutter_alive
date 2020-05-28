import 'package:app/models/dto/product/jiudaye_product_detail_dto.dart';
import 'package:app/models/dto/product/product_detail_dto.dart';
import 'package:app/models/entity/product.dart';
import 'package:app/models/vo/product/product_brand_vo.dart';
import 'package:app/models/vo/product/product_sku_vo.dart';
import 'package:app/models/vo/product/product_spu_vo.dart';

class ProductDetailVO {
  String id;
  List<String> images;
  num marketPrice;
  num price;
  num minPrice;
  num maxPrice;
  num originPrice;
  String title;
  String description;
  String detail;
  ProductBrandVO productBrand;
  Map<String, String> productOptionTypes;
  Map productEvaluation;
  List<ProductSkuVO> productSkuPrice;
  List<ProductSpuVO> productSpus;
  ProductStatus status;

  ProductDetailVO({
    this.id,
    this.images = const <String>[],
    this.price,
    this.marketPrice,
    this.minPrice,
    this.maxPrice,
    this.originPrice,
    this.title = "",
    this.description = "",
    this.detail = "",
    this.productBrand,
    this.productOptionTypes,
    this.productEvaluation,
    this.productSpus,
    this.productSkuPrice = const [],
    this.status
  });

  factory ProductDetailVO.fromDTO(dynamic data) {
    if (data is JiuDaYeProductDetailDTO) {
      return ProductDetailVO(
        id: data.id.toString(),
        price: data.minPrice,
        originPrice: data.maxPrice,
        marketPrice: data.marketPrice,
        minPrice: data.minPrice,
        maxPrice: data.maxPrice,
        images: data.productImages,
        title: data.title,
        description: data.description,
        detail: data.detail,
        productBrand: data.productBrand.toVO(),
        productOptionTypes: data.productOptionTypes ?? Map<String, String>(),
        productEvaluation: data.productEvaluation,
        productSkuPrice: (data.productSkuPrice ?? []).map((item) {
          return item.toVO();
        }).toList(),
        productSpus: (data.productSpus ?? []).map((item) {
          return item.toVO();
        }).toList(),
      );
    }
    if (data is ProductDetailDTO) {
      return ProductDetailVO(
        id: data.productId,
        price: data.minPrice,
        originPrice: data.maxPrice,
        marketPrice: data.marketPrice,
        minPrice: data.minPrice,
        maxPrice: data.maxPrice,
        images: data.imgCollection == null || data.imgCollection.items == null
            ? []
            : data.imgCollection.items.where((item) {
                return item.file != null && item.file['url'] != null;
              }).map((item) {
                return item.file['url'].toString();
              }).toList(),
        title: data.name,
        description: data.subName,
        detail: data.mobileDescription,
        productBrand: data.brand.toVO(),
        productOptionTypes: {},
        productEvaluation: {},
        productSpus: [],
        productSkuPrice: (data.optionCombines ?? []).map((item) {
          return item.toVO();
        }).toList(),
        status: Product.Status.fromStr(data.status)
      );
    }
  }
}
