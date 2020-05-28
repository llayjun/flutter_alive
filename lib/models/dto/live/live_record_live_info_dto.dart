import 'live_record_product_dto.dart';

class LiveRecordLiveInfoDTO {
    String description;
    String id;
    String nickname;
    List<LiveRecordProductDTO> products;
    String sharePosterLive;
    String sharePosterPending;
    String title;
    SquareCover squareCover;

    LiveRecordLiveInfoDTO({this.description, this.id, this.nickname, this.products, this.sharePosterLive, this.sharePosterPending, this.title, this.squareCover});

    factory LiveRecordLiveInfoDTO.fromJson(Map<String, dynamic> json) {
        return LiveRecordLiveInfoDTO(
            description: json['description'],
            id: json['id'],
            nickname: json['nickname'],
            products: json['products'] != null ? (json['products'] as List).map((i) => LiveRecordProductDTO.fromJson(i)).toList() : null,
            sharePosterLive: json['sharePosterLive'],
            sharePosterPending: json['sharePosterPending'],
            squareCover: json['squareCover'] != null ? SquareCover.fromJson(json['squareCover']) : null,
            title: json['title'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['description'] = this.description;
        data['id'] = this.id;
        data['nickname'] = this.nickname;
        data['sharePosterLive'] = this.sharePosterLive;
        data['sharePosterPending'] = this.sharePosterPending;
        data['title'] = this.title;
        if (this.products != null) {
            data['products'] = this.products.map((v) => v.toJson()).toList();
        }
        if (this.squareCover != null) {
          data['squareCover'] = this.squareCover.toJson();
        }
        return data;
    }
}

class SquareCover {
    String fileId;
    String url;

    SquareCover({this.fileId, this.url});

    factory SquareCover.fromJson(Map<String, dynamic> json) {
        return SquareCover(
            fileId: json['fileId'],
            url: json['url'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['fileId'] = this.fileId;
        data['url'] = this.url;
        return data;
    }
}
