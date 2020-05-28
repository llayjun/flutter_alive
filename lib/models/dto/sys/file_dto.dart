import 'package:json_annotation/json_annotation.dart';

part 'file_dto.g.dart';

@JsonSerializable()
class FileDTO {
  String fileId;

  String description;

  String ext;

  String name;

  String meta;

  double size;

  String siteId;

  String url;

  int visitCount;


  FileDTO(this.fileId, this.description, this.ext, this.name, this.meta,
      this.size, this.siteId, this.url, this.visitCount);

  factory FileDTO.fromJson(Map<String, dynamic> json) =>
      _$FileDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FileDTOToJson(this);
}
