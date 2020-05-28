import 'package:json_annotation/json_annotation.dart';

part 'customer_dto.g.dart';
@JsonSerializable()
class CustomerDTO {
  String customerId;
  String districtId;
  String email;
  String fax;
  String mobile;
  String nickname;
  String parentId;
  String sex;
  String telephone;
  String username;
  dynamic file;
  num deposit;
  int experience;
  int point;
  String customerGroupId;
  String thirdLoginCode;

  CustomerDTO(
      {this.customerId,
      this.districtId,
      this.email,
      this.fax,
      this.mobile,
      this.nickname,
      this.parentId,
      this.sex,
      this.telephone,
      this.username,
      this.file,
      this.deposit,
      this.experience,
      this.point,
      this.customerGroupId,
      this.thirdLoginCode});

  factory CustomerDTO.fromJson(Map<String, dynamic> json) =>
      _$CustomerDTOFromJson(json);
}
