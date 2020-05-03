import 'package:flutter/material.dart';

class LoaderButton extends StatelessWidget {
  LoaderButton({
    this.child,
    Key key,
    this.loading = false,
  }) : super(key: key);

  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: loading ? 0.5 : 1.0,
          child: IgnorePointer(
            ignoring: loading == true,
            child: child,
          ),
        ),
        if (loading == true)
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
      ],
    );
  }
}
