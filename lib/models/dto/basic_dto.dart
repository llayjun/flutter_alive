import 'package:app/models/dto/sys/file_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'basic_dto.g.dart';


@JsonSerializable()
class BasicDTO<T>{
  final dynamic data;
  final String msg;
  final bool success;
  final int total;

  BasicDTO({
    this.data,
    this.msg,
    this.success,
    this.total
  });

  dynamic get responseData{
    return this.data;
  }

  

  String get message{
    if(success){
      return this.msg??'成功';
    } else {
      return this.msg??'失败';
    }
  }

  int get pageTotal{
    return this.total;
  }


  factory BasicDTO.fromJson(Map<String, dynamic> json) => _$BasicDTOFromJson(json);

  Map<String, dynamic> toJson() => _$BasicDTOToJson(this);

  T get dataObj {
    if (data == null) return null;

    // 根据类型手动判断
    switch (T) {
      case FileDTO:
        return FileDTO.fromJson(data) as T;
      default:
        return data;
    }
  }

  List<T> get dataList {
    if (data == null) return [];

    var list = data as List<dynamic>;

    // 根据类型手动判断
    switch (T) {
//      case Product:
//        return list.map((item) => Product.fromJson(item)).toList() as List<T>;
      default:
        return data;
    }
  }
}

