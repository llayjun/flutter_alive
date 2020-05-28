import 'package:app/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnTouchingLetterChanged = void Function(String letter);

const List<String> A_Z_LIST = const [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "#"
];

class SideBar extends StatefulWidget {
  SideBar({
    Key key,
    @required this.onTouch,
    this.width = 30,
    this.letterHeight = 16,
    this.color = Colors.transparent,
    this.textStyle = const TextStyle(
      fontSize: 12.0,
      color: AppColors.black43,
    ),
    this.touchDownColor = const Color(0x40E0E0E0),
    this.touchDownTextStyle = const TextStyle(
      fontSize: 12.0,
      color: AppColors.primaryRed,
    ),
  });

  final int width;

  final int letterHeight;

  final Color color;

  final Color touchDownColor;

  final TextStyle textStyle;

  final TextStyle touchDownTextStyle;

  final OnTouchingLetterChanged onTouch;

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool _isTouchDown = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: _isTouchDown ? widget.touchDownColor : widget.color,
      width: widget.width.toDouble(),
      child: _SlideItemBar(
        letterWidth: widget.width,
        letterHeight: widget.letterHeight,
        textStyle: _isTouchDown ? widget.touchDownTextStyle : widget.textStyle,
        onTouch: (letter) {
          if (widget.onTouch != null) {
            setState(() {
              _isTouchDown = letter.isNotEmpty;
            });
            widget.onTouch(letter);
          }
        },
      ),
    );
  }
}

class _SlideItemBar extends StatefulWidget {
  final int letterWidth;

  final int letterHeight;

  final TextStyle textStyle;

  final OnTouchingLetterChanged onTouch;

  _SlideItemBar({
    Key key,
    @required this.onTouch,
    this.letterWidth = 30,
    this.letterHeight = 16,
    this.textStyle,
  })  : assert(onTouch != null),
        super(key: key);

  @override
  _SlideItemBarState createState() => _SlideItemBarState();
}

class _SlideItemBarState extends State<_SlideItemBar> {
  int _lastIndex = -1;
  int _widgetTop = -1;
  int _getIndex(int _offset) => (_offset/widget.letterHeight).floor();

  void _triggerTouchEvent(letter) {
    widget.onTouch(letter);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    A_Z_LIST.forEach((v) {
      children.add(
        SizedBox(
          width: widget.letterWidth.toDouble(),
          height: widget.letterHeight.toDouble(),
          child: Text(
            v,
            textAlign: TextAlign.center,
            style: widget.textStyle,
          ),
        ),
      );
    });
    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) {
        //计算索引列表距离顶部的距离
        if (_widgetTop == -1) {
          RenderBox box = context.findRenderObject();
          Offset topLeftPosition = box.localToGlobal(Offset.zero);
          _widgetTop = topLeftPosition.dy.toInt();
        }
        //获取touch点在索引列表的偏移值
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);
        //判断索引是否在列表中，如果存在，则通知上层更新数据
        if (index != -1) {
          _lastIndex = index;
          _triggerTouchEvent(A_Z_LIST[index]);
        }
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        //获取touch点在索引列表的偏移值
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);
        //并且前后两次的是否一致，如果不一致，则通知上层更新数据
        if (index != -1 && _lastIndex != index) {
          _lastIndex = index;
          _triggerTouchEvent(A_Z_LIST[index]);
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        _lastIndex = -1;
        _triggerTouchEvent('');
      },
      onTapUp: (TapUpDetails details) {
        _lastIndex = -1;
        _triggerTouchEvent('');
      },
      //填充UI
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
