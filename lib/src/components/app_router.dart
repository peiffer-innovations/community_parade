import 'package:community_parade/src/components/named_route.dart';
import 'package:community_parade/src/pages/add_manual_community_page.dart';
import 'package:community_parade/src/pages/communities_page.dart';
import 'package:community_parade/src/pages/community_page.dart';
import 'package:community_parade/src/pages/create_account_page.dart';
import 'package:community_parade/src/pages/initialization_page.dart';
import 'package:community_parade/src/pages/login_page.dart';
import 'package:community_parade/src/pages/logout_page.dart';
import 'package:community_parade/src/pages/parade_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> all = {
    NamedRoute.add_manual_community: (BuildContext context) =>
        AddManualCommunityPage(),
    NamedRoute.create_account: (BuildContext context) => CreateAccountPage(),
    NamedRoute.community: (BuildContext context) => CommunityPage(),
    NamedRoute.communities: (BuildContext context) => CommunitiesPage(),
    NamedRoute.initialize: (BuildContext context) => InitializationPage(),
    NamedRoute.login: (BuildContext context) => LoginPage(),
    NamedRoute.logout: (BuildContext context) => LogoutPage(),
    NamedRoute.parade: (BuildContext context) => ParadePage(),
  };
}
