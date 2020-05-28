class LoginDTO {
  String chatRoomToken;
  bool enableBroadcast;
  bool fixed;
  String headerImg;
  String shopName;
  String siteId;
  String status;
  String token;
  String username;
  String wechatUserInfo;

  LoginDTO(
      {this.chatRoomToken,
      this.enableBroadcast,
      this.fixed,
      this.headerImg,
      this.shopName,
      this.siteId,
      this.status,
      this.token,
      this.username,
      this.wechatUserInfo});

  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    return LoginDTO(
      chatRoomToken: json['chatRoomToken'],
      enableBroadcast: json['enableBroadcast'],
      fixed: json['fixed'],
      headerImg: json['headerImg'],
      shopName: json['shopName'],
      siteId: json['siteId'],
      status: json['status'],
      token: json['token'],
      username: json['username'],
      wechatUserInfo: json['wechatUserInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatRoomToken'] = this.chatRoomToken;
    data['enableBroadcast'] = this.enableBroadcast;
    data['fixed'] = this.fixed;
    data['headerImg'] = this.headerImg;
    data['shopName'] = this.shopName;
    data['siteId'] = this.siteId;
    data['status'] = this.status;
    data['token'] = this.token;
    data['username'] = this.username;
    data['wechatUserInfo'] = this.wechatUserInfo;
    return data;
  }
}
