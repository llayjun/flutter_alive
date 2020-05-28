class LiveRecordDTO {
    String bannerCover;
    String beginTime;
    String endTime;
    String id;
    List<String> recordings;
    String title;

    LiveRecordDTO({this.bannerCover, this.beginTime, this.endTime, this.id, this.recordings, this.title});

    factory LiveRecordDTO.fromJson(Map<String, dynamic> json) {
        return LiveRecordDTO(
            bannerCover: json['bannerCover'], 
            beginTime: json['beginTime'], 
            endTime: json['endTime'], 
            id: json['id'], 
            recordings: json['recordings'] != null ? new List<String>.from(json['recordings']) : null, 
            title: json['title'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['bannerCover'] = this.bannerCover;
        data['beginTime'] = this.beginTime;
        data['endTime'] = this.endTime;
        data['id'] = this.id;
        data['title'] = this.title;
        if (this.recordings != null) {
            data['recordings'] = this.recordings;
        }
        return data;
    }
}