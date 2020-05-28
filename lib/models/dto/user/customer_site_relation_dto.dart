import 'package:app/models/dto/user/customer_dto.dart';
import 'package:app/models/dto/user/user_info_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_site_relation_dto.g.dart';

@JsonSerializable()
class CustomerSiteRelationDTO {
  String id;

  String createDate;

  CustomerDTO customer;

  UserInfoDTO siteOwner;

  bool subscribe;

  String updateDate;

  int fans;

  CustomerSiteRelationDTO(
      {this.id,
      this.createDate,
      this.customer,
      this.siteOwner,
      this.subscribe,
      this.updateDate,
      this.fans});

  factory CustomerSiteRelationDTO.fromJson(Map<String, dynamic> json) =>
      _$CustomerSiteRelationDTOFromJson(json);
}
