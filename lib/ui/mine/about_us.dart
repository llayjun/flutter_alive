import 'package:app/constants/images.dart';
import 'package:app/constants/strings.dart';
import 'package:app/widgets/layout/action_row_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';

class AboutUsScreen extends StatefulWidget{
  AboutUsScreen();
  @override
  _AboutUsState createState()=> _AboutUsState();
}

class _AboutUsState extends State<AboutUsScreen>{


  String _version;
  
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _version = packageInfo.version;
      setState(() {});
    });
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: CustomAppBar(
        title: new Text('关于我们')
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 48.0,
              bottom: 56.0
            ),
            child: Image(
              fit: BoxFit.fitWidth,
              image: AssetImage(Images.logo),
              width: 112.0
            )
          ),
          ActionRow(
            title: '版本',
            padding: EdgeInsets.only(
              left: 27.0,
              right: 20.0
            ),
            tips: '$_version',
            arrow: false
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: ActionRow(
              title: '官网',
              padding: EdgeInsets.only(
                left: 27.0,
                right: 20.0
              ),
              tips: Strings.website,
              arrow: false
            )
          )
        ]
      )
    );
  }
}