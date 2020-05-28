import 'package:app/constants/app_theme.dart';
import 'package:app/utils/navigator_util.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/vmodel/edit_addressdetail_vmodel.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_addressdetail.dart';

class SetAddressPage extends StatefulWidget {

  SetAddressPage({Key key}) : super(key: key);

  @override
  _SetAddressPageState createState() {
    return _SetAddressPageState();
  }
}

class _SetAddressPageState extends State<SetAddressPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _addressVM = Provider.of<EditAddressDetailVModel>(context);

    Widget _buildList() {
      return Container(
        height: ScreenAdapter.height(120),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ScreenAdapter.width(4.0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5, right: 10),
                            child: Text(
                              _addressVM?.addressInfoDTO?.name?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColors.Color_333333, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5, right: 10),
                            child: Text(
                              _addressVM?.addressInfoDTO?.mobile?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColors.Color_333333, fontSize: 15),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 10,
                              ),
                              child: Text(
                                "${_addressVM?.addressInfoDTO?.districtFmt}" + "${_addressVM?.addressInfoDTO?.address}",
                                style: TextStyle(
                                    color: AppColors.Color_666666, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                      flex: 1,
                    ),
                    Container(
                      color: AppColors.Color_F0F0F0,
                      width: 1,
                      height: 50,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        NavigatorUtil.push(context, new EditAddressDetailPage(isEdit: true,));
                      },
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '编辑',
                            style: TextStyle(
                              color: AppColors.Color_666666,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: Text('门店地址'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.transparent,
          child: _buildList(),
      ),
    );
  }

  Widget _addAddress() {
    return Center(
      child: GestureDetector(
        child: Text("添加地址", style: TextStyle(fontSize: ScreenAdapter.fontSize(15.0), color: AppColors.black666),),
        onTap: (){
          NavigatorUtil.push(context, new EditAddressDetailPage());
        },
      )
    );
  }

}
