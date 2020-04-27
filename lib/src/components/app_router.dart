import 'package:community_parade/src/components/named_route.dart';
import 'package:community_parade/src/pages/home_page.dart';
import 'package:community_parade/src/pages/initialization_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> all = {
    NamedRoute.home: (BuildContext context) => HomePage(),
    NamedRoute.initialize: (BuildContext context) => InitializationPage(),
  };
}
