import 'package:json_annotation/json_annotation.dart';

part 'tag_dto.g.dart';

@JsonSerializable()
class DtgDTO {
  String tagId;

  String name;

  String siteId;

  DtgDTO({this.tagId, this.name, this.siteId});

  factory DtgDTO.fromJson(Map<String, dynamic> json) => _$DtgDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DtgDTOToJson(this);
}
