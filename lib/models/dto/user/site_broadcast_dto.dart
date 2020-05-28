
import 'package:json_annotation/json_annotation.dart';

part 'site_broadcast_dto.g.dart';
@JsonSerializable()
class SiteBroadcastDTO{
  String type;
  bool broadcast;
  String msg;


  SiteBroadcastDTO({this.type, this.broadcast, this.msg});

  factory SiteBroadcastDTO.fromJson(Map<String, dynamic> json) => _$SiteBroadcastDTOFromJson(json);
}