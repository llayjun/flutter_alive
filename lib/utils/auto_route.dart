import 'package:flutter/cupertino.dart';

class AutoRoute extends PageRouteBuilder {
  final WidgetBuilder builder;

  AutoRoute({
    @required this.builder,
  })  : assert(builder != null),
        super(
            // 设置过度时间
            transitionDuration: Duration(microseconds: 1),
            // 构造器
            pageBuilder: (
              // 上下文和动画
              BuildContext context,
              Animation<double> animaton1,
              Animation<double> animaton2,
            ) {
              return builder(context);
            },
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animaton1,
              Animation<double> animaton2,
              Widget child,
            ) {
              return FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animaton1,
                  curve: Curves.easeInOutBack,
                )),
                child: child,
              );
            });

}
