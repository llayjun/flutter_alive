import 'package:app/models/dto/product/product_brand_dto.dart';
import 'package:app/models/dto/product/product_img_collection_dto.dart';
import 'package:app/models/dto/product/product_option_combine_dto.dart';
import 'package:app/models/vo/product/product_detail_vo.dart';
import 'package:json_annotation/json_annotation.dart';

class ProductDetailDTO {
  String productId;
  String description;
  String mobileDescription;
  num marketPrice;
  num maxPrice;
  num minPrice;
  String name;
  String subName;
  int pageView;
  String siteId;
  String siteName;
  String status;
  int totalStockNum;
  int totalStock;
  int stock;
  String selectedOptionTypeIds;
  int commentAmount;
  dynamic file;
  ProductImgCollectionDTO imgCollection;
  ProductBrandDTO brand;

//  List<JiuDaYeProductDetailDTO> categories;
//  List<ProductDetailDTO> relatedProducts;
//  List<ProductDetailDTO> relatedProductGifts;
  List<ProductOptionCombineDTO> optionCombines;
//  List<DtgDTO> tags;
//  List<Map<ProductOptionTypeDTO, List<String>>> options;
//  List<Map<dynamic, dynamic>> options;

  ProductDetailDTO(
      {this.productId,
      this.description = '',
      this.mobileDescription,
      this.marketPrice,
      this.maxPrice,
      this.minPrice,
      this.name = '',
      this.subName,
      this.pageView,
      this.siteId,
      this.siteName,
      this.status,
      this.totalStockNum,
      this.selectedOptionTypeIds,
      this.commentAmount,
      this.file,
      this.imgCollection,
      this.brand,
      this.stock,
      this.totalStock,
//      this.categories,
//      this.relatedProducts,
//      this.relatedProductGifts,
      this.optionCombines = const[],
//      this.tags,
//      this.options
      });

  factory ProductDetailDTO.fromJson(Map<String, dynamic> json){}

  ProductDetailVO toVO(){
    return ProductDetailVO.fromDTO(this);
  }
}
