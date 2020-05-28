import 'package:app/constants/strings.dart';
import 'package:app/repository/channel_react.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// 过滤苹果键盘中文高亮状态
class TextLimitFormatter extends TextInputFormatter {
  int _maxLength;

  TextLimitFormatter(this._maxLength);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // TODO: implement formatEditUpdate

    bool isHans = true;

    /// 获取输入是否汉字
    ChannelReact.getInstance().jumpToBoast(Strings.getprimarylanguage, (value) {
      if (value == "zh-Hans") {
        isHans = true;
      } else {
        isHans = false;
      }
      print('~~*******  ${value}');
    });


//    print(newValue.selection);
//    print('------------');
//    print(newValue.composing);
//    String regex = "[\\u4e00-\\u9fa5]+";
//    bool isWriteHans = oldValue.text.matches(regex3);


    if (_maxLength != null &&
        _maxLength > 0 &&
        newValue.text.runes.length > _maxLength) {
      final TextSelection newSelection = newValue.selection.copyWith(
        baseOffset: math.min(newValue.selection.start, _maxLength),
        extentOffset: math.min(newValue.selection.end, _maxLength),
      );
      final RuneIterator iterator = RuneIterator(newValue.text);
      print(newValue.text);

      if (iterator.moveNext())
        for (int count = 0; count < _maxLength; ++count)
          if (!iterator.moveNext()) break;

      final String truncated = newValue.text.substring(0, iterator.rawIndex);
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
