import 'package:json_annotation/json_annotation.dart';
part 'user_info_vo.g.dart';
@JsonSerializable()
class UserInfoVO{
  String username;
  String mobile;
  String headerImg;
  String shopName;
  bool bindWechat;
  String nickname;
  bool enableBroadcast;

  UserInfoVO({
    this.nickname,
    this.username,
    this.mobile,
    this.headerImg,
    this.shopName,
    this.bindWechat,
    this.enableBroadcast
  });

  

}