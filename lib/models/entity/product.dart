
/// 商品状态
enum ProductStatus{
  PENDING,      // 下架
  ONSELL,       // 上架
  RECYCLE       // 删除
}
class _ProductStatus{
  _ProductStatus();
  String toStr(ProductStatus status){
    switch(status){
      case ProductStatus.PENDING:
        return 'PENDING';
      case ProductStatus.ONSELL:
        return 'ONSELL';
      case ProductStatus.RECYCLE:
        return 'RECYCLE';
      default:
        return null;
    }
  }

  ProductStatus fromStr(String status) {
    switch(status){
      case 'PENDING': return ProductStatus.PENDING;
      case 'ONSELL': return ProductStatus.ONSELL;
      case 'RECYCLE': return ProductStatus.RECYCLE;
      default:
        return null;
    }
  }
}


/// 商品类型
enum ProductType{
  NORMAL,       // 一般商品
  GIFT,         // 赠品
  SEMI_FINISHED // 半成品
}
class _ProductType{
  _ProductType();
  String toStr(ProductType status){
    switch(status){
      case ProductType.NORMAL:
        return 'NORMAL';
      case ProductType.GIFT:
        return 'GIFT';
      case ProductType.SEMI_FINISHED:
        return 'SEMI_FINISHED';
      default:
        return null;
    }
  }

  ProductType fromStr(String status) {
    switch(status){
      case 'NORMAL': return ProductType.NORMAL;
      case 'GIFT': return ProductType.GIFT;
      case 'SEMI_FINISHED': return ProductType.SEMI_FINISHED;
      default:
        return null;
    }
  }
}

class Product{
  Product._();

  static final _ProductStatus Status = new _ProductStatus();
  static final _ProductType Type = new _ProductType();
}