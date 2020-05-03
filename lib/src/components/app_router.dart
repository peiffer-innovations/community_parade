import 'package:community_parade/src/components/named_route.dart';
import 'package:community_parade/src/pages/communities_page.dart';
import 'package:community_parade/src/pages/community_page.dart';
import 'package:community_parade/src/pages/create_account_page.dart';
import 'package:community_parade/src/pages/initialization_page.dart';
import 'package:community_parade/src/pages/login_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> all = {
    NamedRoute.create_account: (BuildContext context) => CreateAccountPage(),
    NamedRoute.community: (BuildContext context) => CommunityPage(),
    NamedRoute.communities: (BuildContext context) => CommunitiesPage(),
    NamedRoute.initialize: (BuildContext context) => InitializationPage(),
    NamedRoute.login: (BuildContext context) => LoginPage(),
  };
}
