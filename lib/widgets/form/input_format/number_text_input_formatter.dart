import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class NumberTextInputFormatter extends TextInputFormatter {
  NumberTextInputFormatter({Key key, this.digits = 2, this.defaultValue = 0.01, this.max});
  final int digits;
  final num max;
  final double defaultValue;
  static double strToFloat(String str, double defaultDouble) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultDouble;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (digits == 0) {
      if (value != "") {
        if (value != defaultValue.toString() &&
            strToFloat(value, defaultValue) == defaultValue) {
          value = oldValue.text;
          selectionIndex = oldValue.selection.end;
        } else if (max != null && double.parse(value) > max) {
          value = (max as int).toString();
          selectionIndex = value.length;
        }
      }
    } else if (digits > 0) {
      if (value == ".") {
        value = "0.";
        selectionIndex++;
      } else if (value != "") {
        if (value != defaultValue.toString() &&
            strToFloat(value, defaultValue) == defaultValue) {
          value = oldValue.text;
          selectionIndex = oldValue.selection.end;
        } else if (value.split('.').length == 2 &&
            value.split('.')[1].length > digits) {
          value = oldValue.text;
          selectionIndex = oldValue.selection.end;
        } else if (max != null && double.parse(value) > max) {
          value = (max as double).toString();
          selectionIndex = value.length;
        }
      }
    }

    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
