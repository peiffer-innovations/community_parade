import 'package:community_parade/src/bloc/community_bloc.dart';
import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/models/community.dart';
import 'package:community_parade/src/pages/community/community_info_tab.dart';
import 'package:community_parade/src/pages/community/parades_tab.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  bool _admin = false;
  Community _community;
  CommunityBloc _communityBloc;
  TabController _tabController;
  String _title;
  TranslationsBloc _translationsBloc;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _communityBloc = Provider.of<CommunityBloc>(
      context,
      listen: false,
    );

    _translationsBloc = TranslationsBloc.of(context);
    _title = _translationsBloc.translate(AppTranslations.title_community);

    _userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initialize() async {
    _community = await _communityBloc.getCommunity(_userBloc.communityId);
    if (_community != null) {
      _admin = _community.admins[_userBloc.user.userId] == true;
    }
    _tabController = TabController(
      length: _admin == true ? 3 : 2,
      vsync: this,
    );
    _title = _community?.name ?? 'Community';

    if (mounted == true) {
      setState(() {});
    }
  }

  BottomNavigationBarItem _buildBottomNavBarItem({
    @required BuildContext context,
    @required String label,
    @required Widget icon,
  }) {
    return BottomNavigationBarItem(
      icon: icon,
      title: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _community == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                ParadesTab(),
                CommunityInfoTab(),
                if (_admin == true) SizedBox(),
              ],
            ),
      bottomNavigationBar: _community == null
          ? null
          : BottomNavigationBar(
              currentIndex: _tabController.index,
              onTap: (index) => setState(() => _tabController.index = index),
              items: [
                _buildBottomNavBarItem(
                  context: context,
                  label:
                      _translationsBloc.translate(AppTranslations.tab_parades),
                  icon: Icon(
                    FlutterIcons.birthday_cake_faw,
                  ),
                ),
                _buildBottomNavBarItem(
                  context: context,
                  label: _translationsBloc
                      .translate(AppTranslations.tab_community),
                  icon: Icon(
                    Icons.group,
                  ),
                ),
                if (_admin == true)
                  _buildBottomNavBarItem(
                    context: context,
                    label:
                        _translationsBloc.translate(AppTranslations.tab_admin),
                    icon: Icon(
                      FlutterIcons.users_cog_faw5s,
                    ),
                  ),
              ],
            ),
    );
  }
}
