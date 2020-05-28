

import 'dart:io';

import 'live_product_vo.dart';


class LiveCreateVO {
  String id;
  String title;
  String description;
  DateTime beginTime;
  File squareCover;
  File verticalCover;// 竖直
  File bannerCover;// 水平
  List<LiveProductVO> products;


  LiveCreateVO({
    this.id,
    this.title = '',
    this.description = '',
    this.beginTime,
    this.squareCover,
    this.bannerCover,
    this.verticalCover,
    this.products = const <LiveProductVO>[]
  });


  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "beginTime": beginTime,
    "squareCover": squareCover,
    "bannerCover": bannerCover,
    "verticalCover": verticalCover,
    "products": products
  };

  String get validate{
    if(title.isEmpty){
      return '请填写直播标题';
    }
    if(verticalCover == null || bannerCover == null){
      return '请选择封面图';
    }
    if(beginTime == null){
      return '请选择直播时间';
    }
    if(beginTime.isBefore(DateTime.now())){
      return '直播时间不能早于当前时间';
    }
    if(description.isEmpty){
      return '请填写直播简介';
    }
    if(products.length<=0){
      return '请选择关联商品';
    }
    return '';
  }

}