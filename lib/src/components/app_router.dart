import 'package:community_parade/src/components/named_route.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> all = {
    NamedRoute.home: (BuildContext context) => HomePage(),
  }
}