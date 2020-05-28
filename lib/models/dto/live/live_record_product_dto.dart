class LiveRecordProductDTO {
  String displayWindow;
  String id;
  String img;
  String name;
  double originPrice;
  double price;
  String productId;
  int saleAmount;
  String status;
  int totalStockNum;

  LiveRecordProductDTO(
      {this.displayWindow,
      this.id,
      this.img,
      this.name,
      this.originPrice,
      this.price,
      this.productId,
      this.saleAmount,
      this.status,
      this.totalStockNum});

  factory LiveRecordProductDTO.fromJson(Map<String, dynamic> json) {
    return LiveRecordProductDTO(
      displayWindow: json['displayWindow'],
      id: json['id'],
      img: json['img'],
      name: json['name'],
      originPrice: json['originPrice'],
      price: json['price'],
      productId: json['productId'],
      saleAmount: json['saleAmount'],
      status: json['status'],
      totalStockNum: json['totalStockNum'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayWindow'] = this.displayWindow;
    data['id'] = this.id;
    data['img'] = this.img;
    data['name'] = this.name;
    data['originPrice'] = this.originPrice;
    data['price'] = this.price;
    data['productId'] = this.productId;
    data['saleAmount'] = this.saleAmount;
    data['status'] = this.status;
    data['totalStockNum'] = this.totalStockNum;
    return data;
  }
}
