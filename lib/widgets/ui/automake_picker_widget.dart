import 'package:app/constants/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/Picker.dart';

class ShowPickerWidget{
  static void showPicker(BuildContext context, List pickerArr, PickerConfirmCallback callback){
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: pickerArr,
          isArray: false,
        ),
        changeToFirst: true,
        hideHeader: false,
        cancelText: '取消',
        confirmText: '确定',
        confirmTextStyle: TextStyle(
            color: AppColors.Color_F9515A,
            fontSize: 20,
            fontWeight: FontWeight.normal),
        onConfirm: callback)
        .showModal(context);
  }
}