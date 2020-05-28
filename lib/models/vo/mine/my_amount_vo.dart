
class MyAmountVo {
  num paidAmount;

  num finishedAmount;

  MyAmountVo({
    this.paidAmount = 0,
    this.finishedAmount = 0
  });

  MyAmountVo toVO() {
    return MyAmountVo(
        paidAmount:  this.paidAmount,
        finishedAmount:this.finishedAmount
    );
  }

  factory MyAmountVo.fromJson(Map<String, dynamic> parsedJson) {

    return new MyAmountVo(
      paidAmount: parsedJson['paidAmount'],
      finishedAmount: parsedJson['finishedAmount']
    );
  }
}


class AddressProModel {
    String districtId;
    String name;
    String parentId;
    String pinyin;

    AddressProModel({this.districtId, this.name, this.parentId, this.pinyin});

    factory AddressProModel.fromJson(Map<String, dynamic> json) {
        return AddressProModel(
            districtId: json['districtId'],
            name: json['name'],
            parentId: json['parentId'],
            pinyin: json['pinyin'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['districtId'] = this.districtId;
        data['name'] = this.name;
        data['parentId'] = this.parentId;
        data['pinyin'] = this.pinyin;
        return data;
    }
}