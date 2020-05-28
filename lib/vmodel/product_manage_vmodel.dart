import 'package:app/models/view/base_vmodel.dart';
import 'package:app/models/vo/product/product_vo.dart';
import 'package:app/services/product_service.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductManageModel extends BaseViewModel {
  final ProductService _productService = ProductService();

  int _pageIndex = 0;
  bool _nothingMore = false;

  List<ProductVO> _products = [];

  bool get nothingMore => _nothingMore;

  /// 商品集合
  List<ProductVO> productList() {
    return _products ?? [];
  }

  /// 获取商品列表
  Future<List<ProductVO>> fetchData(bool refresh) async {
    if (refresh) {
      _pageIndex = 0;
    }
    try {
      return await _productService.getProductList({
        'page': _pageIndex,
        'size': 10
      }).then((res) {
        var result = (res.data ?? []).map((item) => item.toVO()).toList();
        if (refresh) {
          _products = result;
        } else {
          if (_products == null) {
            _products = result;
          } else {
            _products.addAll(result);
          }
        }
        _pageIndex++;
        _nothingMore = _products.length >= res.total;
        notifyListeners();
        return result;
      });
    } catch (e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      notifyListeners();
      return [];
    }
  }

}
