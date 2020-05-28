
import 'package:json_annotation/json_annotation.dart';

part 'site_dto.g.dart';
@JsonSerializable()
class SiteDTO{
  String siteId;

  String address;

  String countryId;

  String districtId;

  String name;

  String company;

  String email;

  String mobile;

  String fullAddress;

  String defaultDomain;

  String customDomain;

  String description;

  String pagePullDownText;

  String appVersion;

  String placeholderImgPath2;

  List<String> appWelcomeImages;

  Map<String, String> extDataMap;

  bool showMarketPrice;

  String logoPath;

  String appAndroidUrl;

  String appIosUrl;

  String appStage;

  dynamic businessLicense;

  String pcSiteMode;

  String pcSiteCustomUrl; //暂时通过运管平台设置

  String industrySolution;

  List<String> slogan;

  bool enableBroadcast;


  SiteDTO({this.siteId, this.address, this.countryId, this.districtId, this.name,
      this.company, this.email, this.mobile, this.fullAddress,
      this.defaultDomain, this.customDomain, this.description,
      this.pagePullDownText, this.appVersion, this.placeholderImgPath2,
      this.appWelcomeImages, this.extDataMap, this.showMarketPrice,
      this.logoPath, this.appAndroidUrl, this.appIosUrl, this.appStage,
      this.businessLicense, this.pcSiteMode, this.pcSiteCustomUrl,
      this.industrySolution, this.slogan, this.enableBroadcast});

  factory SiteDTO.fromJson(Map<String, dynamic> json) => _$SiteDTOFromJson(json);
}