import 'dart:convert';
import 'dart:io';

import 'package:app/constants/app_theme.dart';
import 'package:app/entry/routes.dart';
import 'package:app/models/dto/adress/address_info_dto.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/navigator_util.dart';
import 'package:app/vmodel/edit_addressdetail_vmodel.dart';
import 'package:app/widgets/form/input_format/text_input_formatter.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:app/widgets/ui/automake_searchbar_widget.dart';
import 'package:app/widgets/ui/chooseadress_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EditAddressDetailPage extends StatefulWidget {
  bool isEdit = false;

  EditAddressDetailPage({Key key, this.isEdit = false}) : super(key: key);

  @override
  _EditAddressDetailPageState createState() {
    return _EditAddressDetailPageState();
  }
}

class _EditAddressDetailPageState extends State<EditAddressDetailPage> {
  List _list = ['门店名称', '手机号', '所在地址', '详细地址'];
  AddressInfoDTO _addressInfoDTO = AddressInfoDTO();
  FocusNode _namefocusNode = FocusNode();
  FocusNode _phoneNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _namefocusNode.addListener(() {
      if (!_namefocusNode.hasFocus) {
        setState(() {
          _addressInfoDTO.name = _addressInfoDTO.name.substring(0,getSubRangeLength(30, _addressInfoDTO.name));
        });
      }
    });

    _phoneNode.addListener(() {
      if(!_phoneNode.hasFocus) {
        if(_addressInfoDTO.mobile.length != 11) {
          CustomToast.showToast(msg: "手机号码必须为11位", gravity: ToastGravity.CENTER);
        }
      }
    });
    
    _addressFocusNode.addListener((){
      if(!_addressFocusNode.hasFocus) {
        setState(() {
          _addressInfoDTO.address = _addressInfoDTO.address.substring(0,getSubRangeLength(40, _addressInfoDTO.address));
        });
      }
    });

    if (widget.isEdit) {
      new Future.delayed(Duration.zero, () {
        Map<String, dynamic> obj = json.decode(json.encode(Provider.of<EditAddressDetailVModel>(context).addressInfoDTO));
        _addressInfoDTO = AddressInfoDTO.fromJson(obj);
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: CustomAppBar(
          title: Text('${widget.isEdit ? '编辑门店地址' : '新增门店地址'}'),
          backgroundColor: Colors.white,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return _buildList(index);
                      },
                      itemCount: 4,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: AppColors.Color_F0F0F0,
                          height: 1,
                        );
                      },
                    ),
                  ),
                  flex: 1,
                ),
                Container(
                  height: 100,
                  child: Center(
                    child: MaterialButton(
                      minWidth: 300.0,
                      height: 45.0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(22.0),
                        ),
                      ),
                      color: AppColors.primaryRed,
                      child: Text(
                        '保存',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {

                        if(TextUtil.isEmpty(_addressInfoDTO?.name) || TextUtil.isEmpty(_addressInfoDTO?.mobile) || TextUtil.isEmpty(_addressInfoDTO?.address) || TextUtil.isEmpty(_addressInfoDTO?.districtId)) {
                          CustomToast.showToast(msg: "请补全门店信息", gravity: ToastGravity.CENTER);
                          return;
                        }

                        if(RegExp(r"^[\u4E00-\u9FA5A-Za-z0-9_]+$").firstMatch(_addressInfoDTO.name) ==null) {
                          CustomToast.showToast(msg: "请删除特殊字符后再试", gravity: ToastGravity.CENTER);
                          return;
                        }

                        if(_addressInfoDTO.mobile.length != 11) {
                          CustomToast.showToast(msg: "手机号码必须为11位", gravity: ToastGravity.CENTER);
                          return;
                        }

                        Provider.of<EditAddressDetailVModel>(context)
                            .changeaddress(_addressInfoDTO)
                            .then((value) {
                          /// 保存成功
                          if (value) {
                            CustomToast.showToast(
                                msg: "修改成功", gravity: ToastGravity.CENTER);
                            NavigatorUtil.popUntil(context, Routes.home,);
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildList(int row) {
    AutoMakeSearchBar _textFCell = AutoMakeSearchBar(
      keyboardType: (row == 1) ? ITextInputType.phone : ITextInputType.text,
      isShowPrefix: false,
      blackColor: AppColors.white,
      hintColor: AppColors.Color_666666,
      fontSize: 15,
      focusNode: (row == 0)?_namefocusNode:(row == 1)?_phoneNode:(row == 3)?_addressFocusNode:null,
      inputFormatters:  row == 1? [LengthLimitingTextInputFormatter(11), WhitelistingTextInputFormatter(RegExp("[0-9]"))]:null,
      hintText: row == 0? "请输入门店名称": row == 1? "请输入门手机号": row == 2? "请选择所在城市": row == 3? "街道、门牌号、小区等": "",
      fristStr: row == 0
          ? _addressInfoDTO.name
          : row == 1
              ? _addressInfoDTO.mobile
              : row == 2
                  ? _addressInfoDTO.districtFmt
                  : _addressInfoDTO.address,
      numline: row == 1 ? 1 :null,
      isCanWirte: row != 2,
      fieldCallBack: (content) {
        switch (row) {
          case 0:
            _addressInfoDTO.name = content;
            break;
          case 1:
            _addressInfoDTO.mobile = content;
            break;
          case 2:
            break;
          case 3:
            _addressInfoDTO.address = content;
            break;
        }

      },
    );
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: row == 0
            ? BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4))
            : row == 3
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4))
                : BorderRadius.all(Radius.circular(1)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                _list[row],
                style: TextStyle(color: AppColors.Color_333333, fontSize: 15),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: row == 2
                      ? GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: _textFCell,
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: AppColors.white,
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext dialogContex) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        2 /
                                        3,
                                    child: SelectAddressWidget(
                                      infoDTO: _addressInfoDTO,
                                      valueCb: (value) {
                                        setState(() {
                                          _addressInfoDTO.districtId =
                                              value['selectDistrictId']
                                                  .toString();
                                          _addressInfoDTO.districtFmt =
                                              value['addressdetail'];
                                        });
                                      },
                                    ),
                                  );
                                });
                          },
                        )
                      : _textFCell),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
  
  int getSubRangeLength(int limtLength,String content) {
    int maxLength = 0;
    int subStringIndex = limtLength;
    for (int i = 0; i < content.length; i++) {
      if (content.codeUnitAt(i) > 122) { /// 汉字
        maxLength = maxLength+2 ;
      }else { /// 字母数字
        maxLength = maxLength+1;
      }
      if(maxLength == limtLength) {
        subStringIndex = i+1;
      }
    }
    if(maxLength > limtLength) {
      CustomToast.showToast(msg: limtLength == 30?"门店名称不超过15个字":'地址不能超过20个字', gravity: ToastGravity.CENTER);
    }
    return subStringIndex;
  }

}
