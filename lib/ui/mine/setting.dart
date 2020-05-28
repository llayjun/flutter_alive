import 'package:app/constants/app_theme.dart';
import 'package:app/entry/routes.dart';
import 'package:app/models/dto/adress/address_info_dto.dart';
import 'package:app/utils/navigator_util.dart';
import 'package:app/vmodel/edit_addressdetail_vmodel.dart';
import 'package:app/vmodel/user_info_vmodel.dart';
import 'package:app/widgets/layout/action_row_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_addressdetail.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('设置'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            ActionRow(
              title: '地址设置',
              titleSize: 17.0,
              onPressed: () async{
                AddressInfoDTO _addressInfoDTO = await Provider.of<EditAddressDetailVModel>(context).getAddressInfo();
                if (_addressInfoDTO == null) return;
                if (_addressInfoDTO != null && !TextUtil.isEmpty(_addressInfoDTO?.mobile)) {
                  Navigator.of(context).pushNamed(Routes.address_set,);
                } else {
                  NavigatorUtil.push(context, EditAddressDetailPage());
                }
              },
            ),
            Divider(
              color: Colors.transparent,
              height: 10,
            ),
            ActionRow(
              title: '关于我们',
              titleSize: 17.0,
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.about_us);
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 30.0,
                left: 12.0,
                right: 12.0,
              ),
              child: MaterialButton(
                minWidth: 350.0,
                height: 44.0,
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(22.0),
                  ),
                ),
                color: AppColors.primaryRed,
                child: Text(
                  '退出登录',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Provider.of<UserInfoVModel>(context).logout().then(
                    (succ) {
                      if (succ) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.boot,
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
