class LiveStatisticDto {
    int interaction;
    int online;
    int maxOnline;
    int productView;
    int view;

    LiveStatisticDto({this.interaction, this.online, this.productView, this.view, this.maxOnline});

    factory LiveStatisticDto.fromJson(Map<String, dynamic> json) {
        return LiveStatisticDto(
            interaction: json['interaction'], 
            online: json['online'], 
            productView: json['productView'], 
            view: json['view'],
            maxOnline: json['maxOnline'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['interaction'] = this.interaction;
        data['online'] = this.online;
        data['productView'] = this.productView;
        data['view'] = this.view;
        data['maxOnline'] = this.maxOnline;
        return data;
    }
}