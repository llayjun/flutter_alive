import 'package:app/ui/live/live_vmodel.dart';
import 'package:app/vmodel/edit_addressdetail_vmodel.dart';
import 'package:app/vmodel/product_manage_vmodel.dart';
import 'package:app/vmodel/user_info_vmodel.dart';
import 'package:provider/provider.dart';

/// 在这里列出所有的provider
final providers = [
  ChangeNotifierProvider<UserInfoVModel>.value(value: new UserInfoVModel()),
  ChangeNotifierProvider<ProductManageModel>.value(value: new ProductManageModel()),
  ChangeNotifierProvider<LiveVModel>.value(value: new LiveVModel()),
  ChangeNotifierProvider<EditAddressDetailVModel>.value(value: EditAddressDetailVModel())
];
