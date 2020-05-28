import 'package:app/models/dto/paging_data_dto.dart';
import 'package:app/models/dto/product/product_detail_dto.dart';
import 'package:app/models/dto/product/product_dto.dart';
import 'package:app/services/base/base_service.dart';

class ProductService extends BaseService{

  /// 获取商品列表
  Future<PagingDataDTO<ProductDTO>> getProductList(
      Map<String, dynamic> params) async {
    final res = await api.get("/admin/api/products", queryParameters: params);
    return PagingDataDTO<ProductDTO>(
        total: res.total,
        data: res.data.map<ProductDTO>((pItem) => ProductDTO.fromJson(pItem)).toList());
  }

  /// 获得九大爷商品详情
  Future<ProductDetailDTO> getProductDetail(String id) async {
    final res = await api.get("/admin/api/products/$id");
    return ProductDetailDTO.fromJson(res.data);
  }

}
