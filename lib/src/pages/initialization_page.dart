import 'package:community_parade/src/components/bootstrapper.dart';
import 'package:flutter/material.dart';

class InitializationPage extends StatefulWidget {
  InitializationPage({
    this.bootstrapper,
    Key key,
  }) : super(key: key);

  Bootstrapper bootstrapper;

  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _initialize() async {
    await widget.bootstrapper.bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
