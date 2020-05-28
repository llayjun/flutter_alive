import 'package:app/constants/app_theme.dart';
import 'package:app/constants/app_theme.dart';
import 'package:app/constants/strings.dart';
import 'package:app/entry/routes.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/vmodel/user_info_vmodel.dart';
import 'package:app/widgets/common/loading_wrap_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super();
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneEditController;
  TextEditingController _pwdEditController;

  FocusNode _phoneFocusNode;
  FocusNode _pwdFocusNode;

  bool _loading = false;
  bool _canLogin = false;

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _phoneEditController = new TextEditingController()
      ..addListener(_listenEmpty);
    _pwdEditController = new TextEditingController()..addListener(_listenEmpty);
    _phoneFocusNode = new FocusNode();
//    _phoneEditController.text = '18751579693';
//    _pwdEditController.text = '12345678';
//        _phoneEditController.text = '15150104174';
    _pwdFocusNode = new FocusNode();
    super.initState();
  }

  void _listenEmpty() {
    bool result = _phoneEditController.text.isNotEmpty &&
        _pwdEditController.text.isNotEmpty;
    if (result != _canLogin) {
      setState(() {
        _canLogin = result;
      });
    }
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _pwdFocusNode.dispose();
    _phoneEditController.dispose();
    _pwdEditController.dispose();
    super.dispose();
  }

  Future _onSubmit() async {
    _formKey.currentState.validate();
    setState(() {
      _loading = true;
    });
    _phoneFocusNode.unfocus();
    _pwdFocusNode.unfocus();
    bool result = await Provider.of<UserInfoVModel>(context)
        .login(_phoneEditController.text, _pwdEditController.text);
    if (result) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home,
        (Route<dynamic> route) => false,
      );
    }
    setState(() {
      _loading = false;
    });
  }

  InputDecoration get decoration {
    InputBorder _createBorder(Color _color){
      return UnderlineInputBorder(
        borderSide: BorderSide(
          color: _color,
          width: ScreenAdapter.borderWidth(),
        ),
      );
    }
    return InputDecoration(
      hintStyle: TextStyle(
        color: const Color(0x72999999),
        fontSize: ScreenAdapter.fontSize(17.0),
      ),
      labelStyle: TextStyle(
        color: const Color(0xFF333333),
        fontSize: ScreenAdapter.fontSize(16.0),
      ),
      enabledBorder: _createBorder(Color(0xFFE8E8E8)),
      focusedBorder: _createBorder(AppColors.primaryRed),
      focusedErrorBorder: _createBorder(AppColors.primaryRed),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _phoneTextFormField = TextFormField(
      validator: Provider.of<UserInfoVModel>(context).validatePhone,
      controller: _phoneEditController,
      focusNode: _phoneFocusNode,
      decoration: decoration.copyWith(
        labelText: Strings.login_et_phone_label,
        hintText: Strings.login_et_phone_placeholder,
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onEditingComplete: _pwdFocusNode.nextFocus,
    );

    final _pwdTextFormField = TextFormField(
      validator: Provider.of<UserInfoVModel>(context).validatePassword,
      controller: _pwdEditController,
      focusNode: _pwdFocusNode,
      decoration: decoration.copyWith(
        labelText: Strings.login_et_password_label,
        hintText: Strings.login_et_password_placeholder,
      ),
      obscureText: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onEditingComplete: _onSubmit,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _phoneFocusNode.unfocus();
        _pwdFocusNode.unfocus();
        // FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(barBorder: false),
        body: LoadingWrap(
          saving: _loading,
          savingTips: '登录中...',
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: ScreenAdapter.height(30.0),
                right: ScreenAdapter.height(30.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: ScreenAdapter.height(50.0),
                  ),
                  Text(
                    Strings.login_doc_title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.black333,
                      fontSize: ScreenAdapter.fontSize(36.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: ScreenAdapter.height(15.0),
                  ),
                  Text(
                    Strings.login_doc_tips,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.black666,
                      fontSize: ScreenAdapter.fontSize(17.0),
                    ),
                  ),
                  SizedBox(
                    height: ScreenAdapter.height(54.0),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _phoneTextFormField,
                        _pwdTextFormField,
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: ScreenAdapter.height(40.0),
                              bottom: ScreenAdapter.height(40.0),
                            ),
                            child: MaterialButton(
                              child: Text(
                                Strings.login_btn_sign_in,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: ScreenAdapter.fontSize(17.0),
                                ),
                              ),
                              onPressed: _canLogin ? _onSubmit : null,
                              color: AppColors.primaryRed,
                              disabledColor: AppColors.disabledRed,
                              height: ScreenAdapter.height(44.0),
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    ScreenAdapter.width(22.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
