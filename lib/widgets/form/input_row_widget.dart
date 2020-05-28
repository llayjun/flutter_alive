import 'package:app/constants/app_theme.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 标签之于输入框的对齐方式
enum LabelPosition {
  top, // label和input分两行，label在上面，input在下面
  left // label和input在同一行，label在左边，input在右边
}

class InputRow extends StatefulWidget {
  InputRow(
      {Key key,
      this.label,
      this.labelStyle = const TextStyle(),
      this.labelWidth = 90.0,
      this.padding,
      this.labelPosition = LabelPosition.left,

      // 传递给TextField
      this.enabled = true,
      this.initValue = '',
      this.controller,
      this.focusNode,
      this.decoration = const InputDecoration(),
      this.obscureText = false,
      this.keyboardType,
      this.textInputAction,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.inputFormatters,
      this.onSaved,
      this.onChanged,
      this.validator,
      this.minLines,
      this.maxLines})
      : super(key: key);

  final String label;
  final TextStyle labelStyle;

  final double labelWidth;

  final EdgeInsetsGeometry padding;

  final LabelPosition labelPosition;

  final String initValue;

  final bool enabled;

  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onFieldSubmitted;
  List<TextInputFormatter> inputFormatters;
  FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;
  FormFieldValidator<String> validator;

  final bool obscureText;

  final int minLines;
  final int maxLines;

  @override
  _InputRowState createState() => _InputRowState();
}

class _InputRowState extends State<InputRow> {
  TextEditingController _controller;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  EdgeInsetsGeometry get _padding {
    if (widget.padding == null) {
      return EdgeInsets.only(left: 12.0, right: 12.0);
    }
    return widget.padding;
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    if (widget.initValue != null) {
      _effectiveController.text = widget.initValue;
    }
    _effectiveController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _onChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(_effectiveController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.labelPosition == LabelPosition.left) {
      return Container(
        color: AppColors.white,
        height: ScreenAdapter.height(55.0),
        padding: _padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: widget.labelWidth,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: AppColors.black43,
                  fontSize: ScreenAdapter.fontSize(17.0),
                  fontWeight: FontWeight.w500,
                ).merge(widget.labelStyle),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                enabled: widget.enabled,
                controller: _effectiveController,
                focusNode: widget.focusNode,
                style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(15.0),
                  height: 1,
                ),
                decoration: widget.decoration.copyWith(
                  labelStyle: TextStyle(
                    color: AppColors.black999,
                    fontSize: ScreenAdapter.fontSize(14.0),
                  ),
                  hintStyle: TextStyle(
                    color: AppColors.black999,
                    fontSize: ScreenAdapter.fontSize(14.0),
                    height: 1,
                  ),
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                inputFormatters: widget.inputFormatters,
                onSaved: widget.onSaved,
                onFieldSubmitted: widget.onFieldSubmitted,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                onEditingComplete: widget.onEditingComplete,
                obscureText: widget.obscureText,
                validator: widget.validator,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        color: AppColors.white,
        padding: _padding,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: ScreenAdapter.height(14.0),
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: AppColors.black43,
                  fontSize: ScreenAdapter.fontSize(17.0),
                  fontWeight: FontWeight.w500,
                ).merge(widget.labelStyle),
              ),
            ),
            TextFormField(
              enabled: widget.enabled,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              controller: _effectiveController,
              focusNode: widget.focusNode,
              style: TextStyle(
                fontSize: ScreenAdapter.fontSize(15.0),
              ),
              decoration: widget.decoration.copyWith(
                contentPadding: EdgeInsets.only(
                  top: ScreenAdapter.height(8.0),
                  bottom: ScreenAdapter.height(8.0),
                ),
                labelStyle: TextStyle(
                  color: AppColors.black999,
                  fontSize: ScreenAdapter.fontSize(14.0),
                ),
                hintStyle: TextStyle(
                  color: AppColors.black999,
                  fontSize: ScreenAdapter.fontSize(14.0),
                ),
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              inputFormatters: widget.inputFormatters,
              onSaved: widget.onSaved,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              onFieldSubmitted: widget.onFieldSubmitted,
              onEditingComplete: widget.onEditingComplete,
              obscureText: widget.obscureText,
              validator: widget.validator,
            ),
          ],
        ),
      );
    }
  }
}
