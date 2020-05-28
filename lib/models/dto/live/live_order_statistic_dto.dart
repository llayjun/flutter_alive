class LiveOrderStatisticDTO {
  int orderAmount;
  int orderQuantity;

  LiveOrderStatisticDTO({this.orderAmount, this.orderQuantity});

  factory LiveOrderStatisticDTO.fromJson(Map<String, dynamic> json) {
    return LiveOrderStatisticDTO(
      orderAmount: json == null ? 0 : json['orderAmount'],
      orderQuantity: json == null ? 0 : json['orderQuantity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderAmount'] = this.orderAmount;
    data['orderQuantity'] = this.orderQuantity;
    return data;
  }
}