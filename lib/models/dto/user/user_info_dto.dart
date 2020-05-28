import 'package:app/models/dto/user/site_dto.dart';
import 'package:app/models/vo/user/user_info_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info_dto.g.dart';
@JsonSerializable()
class UserInfoDTO{
  String siteId;
  dynamic avator;
  String mobile;
  String nickname;
  String username;
  bool bindWechat;
  SiteDTO site;

  UserInfoDTO({
    this.siteId,
      this.avator,
      this.mobile,
      this.nickname,
      this.username,
      this.site,
      this.bindWechat
  });

  factory UserInfoDTO.fromJson(Map<String, dynamic> json) => _$UserInfoDTOFromJson(json);

  UserInfoVO toVO(){
    return UserInfoVO(
      username: this.username,
      nickname: this.nickname,
      mobile: this.mobile,
      headerImg: this.avator==null?'':this.avator['url'],
      bindWechat: this.bindWechat,
      shopName: this.nickname
    );
  }
}