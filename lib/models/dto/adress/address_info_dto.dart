class AddressInfoDTO {
    String address;
    String districtFmt;
    String districtId;
    List<String> indexList;
    String mobile;
    String name;

    AddressInfoDTO({this.address, this.districtFmt, this.districtId, this.indexList, this.mobile, this.name});

    factory AddressInfoDTO.fromJson(Map<String, dynamic> json) {
        return AddressInfoDTO(
            address: json['address'],
            districtFmt: json['districtFmt'],
            districtId: json['districtId'],
            indexList: json['indexList'] != null ? new List<String>.from(json['indexList']) : null,
            mobile: json['mobile'],
            name: json['name'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['address'] = this.address;
        data['districtFmt'] = this.districtFmt;
        data['districtId'] = this.districtId;
        data['mobile'] = this.mobile;
        data['name'] = this.name;
        if (this.indexList != null) {
            data['indexList'] = this.indexList;
        }
        return data;
    }
}