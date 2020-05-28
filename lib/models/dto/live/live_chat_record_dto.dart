class LiveChatRecordDTO {
  String created_at;
  String message;
  String type;
  String user;
  String user_id;

  LiveChatRecordDTO(
      {this.created_at, this.message, this.type, this.user, this.user_id});

  factory LiveChatRecordDTO.fromJson(Map<String, dynamic> json) {
    return LiveChatRecordDTO(
      created_at: json['created_at'],
      message: json['message'],
      type: json['type'],
      user: json['user'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['message'] = this.message;
    data['type'] = this.type;
    data['user'] = this.user;
    data['user_id'] = this.user_id;
    return data;
  }
}
