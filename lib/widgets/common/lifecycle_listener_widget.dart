import 'package:flutter/widgets.dart';

class LifecycleListener extends StatefulWidget {
  LifecycleListener({
    Key key,
    this.onMounted,
    this.onDestory,
    this.child,
  }) : super(key: key);
  final VoidCallback onMounted;
  final VoidCallback onDestory;
  final Widget child;

  @override
  _LifecycleListenerState createState() => _LifecycleListenerState();
}

class _LifecycleListenerState extends State<LifecycleListener> {
  @override
  void initState() {
    super.initState();
    widget.onMounted();
  }

  @override
  void deactivate() {
    widget.onDestory();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}