import 'package:community_parade/src/components/bootstrapper.dart';
import 'package:community_parade/src/components/named_route.dart';
import 'package:community_parade/src/theme/app_image_asset.dart';
import 'package:community_parade/src/theme/app_padding.dart';
import 'package:community_parade/src/widgets/placeholder_app.dart';
import 'package:flutter/material.dart';

class InitializationPage extends StatefulWidget {
  InitializationPage({
    this.bootstrapper,
    Key key,
  }) : super(key: key);

  final Bootstrapper bootstrapper;

  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    await widget.bootstrapper.bootstrap();

    var route = NamedRoute.home;
    await Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return PlaceholderApp();
  }
}
