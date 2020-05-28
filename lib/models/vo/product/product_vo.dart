class ProductVO {
    ExtDataMap extDataMap;
    String imageUrl;
    double maxPrice;
    double minPrice;
    String name;
    String productId;
    int saleAmount;
    int shareNum;
    String siteCompany;
    int stock;

    ProductVO({this.extDataMap, this.imageUrl, this.maxPrice, this.minPrice, this.name, this.productId, this.saleAmount, this.shareNum, this.siteCompany, this.stock});

    factory ProductVO.fromJson(Map<String, dynamic> json) {
        return ProductVO(
            extDataMap: json['extDataMap'] != null ? ExtDataMap.fromJson(json['extDataMap']) : null,
            imageUrl: json['imageUrl'],
            maxPrice: json['maxPrice'],
            minPrice: json['minPrice'],
            name: json['name'],
            productId: json['productId'],
            saleAmount: json['saleAmount'],
            shareNum: json['shareNum'],
            siteCompany: json['siteCompany'],
            stock: json['stock'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['imageUrl'] = this.imageUrl;
        data['maxPrice'] = this.maxPrice;
        data['minPrice'] = this.minPrice;
        data['name'] = this.name;
        data['productId'] = this.productId;
        data['saleAmount'] = this.saleAmount;
        data['shareNum'] = this.shareNum;
        data['siteCompany'] = this.siteCompany;
        data['stock'] = this.stock;
        if (this.extDataMap != null) {
            data['extDataMap'] = this.extDataMap.toJson();
        }
        return data;
    }
}

class ExtDataMap {
    String maxDistributionPrice;
    String minDistributionPrice;

    ExtDataMap({this.maxDistributionPrice, this.minDistributionPrice});

    factory ExtDataMap.fromJson(Map<String, dynamic> json) {
        return ExtDataMap(
            maxDistributionPrice: json['maxDistributionPrice'],
            minDistributionPrice: json['minDistributionPrice'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['maxDistributionPrice'] = this.maxDistributionPrice;
        data['minDistributionPrice'] = this.minDistributionPrice;
        return data;
    }
}