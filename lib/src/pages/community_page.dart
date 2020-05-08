import 'package:community_parade/src/bloc/community_bloc.dart';
import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
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
  CommunityBloc _communityBloc;
  TabController _tabController;
  String _title;
  TranslationsBloc _translationsBloc;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

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
    _title = (await _communityBloc.getCommunity(_userBloc.communityId))?.name ??
        'Community';

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
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ParadesTab(),
          CommunityInfoTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (index) => setState(() => _tabController.index = index),
        items: [
          _buildBottomNavBarItem(
            context: context,
            label: _translationsBloc.translate(AppTranslations.tab_parades),
            icon: Icon(
              FlutterIcons.birthday_cake_faw,
            ),
          ),
          _buildBottomNavBarItem(
            context: context,
            label: _translationsBloc.translate(AppTranslations.tab_community),
            icon: Icon(
              Icons.group,
            ),
          ),
        ],
      ),
    );
  }
}
