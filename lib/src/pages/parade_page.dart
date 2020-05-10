import 'package:community_parade/src/bloc/gps_bloc.dart';
import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/pages/parade/map_tab.dart';
import 'package:community_parade/src/pages/parade/stops_tab.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:websafe_platform/websafe_platform.dart';

class ParadePage extends StatefulWidget {
  ParadePage({
    Key key,
  }) : super(key: key);

  @override
  _ParadePageState createState() => _ParadePageState();
}

class _ParadePageState extends State<ParadePage>
    with SingleTickerProviderStateMixin {
  GpsBloc _gpsBloc;
  TabController _tabController;
  bool _tracking = false;
  TranslationsBloc _translationsBloc;
  WebsafePlatform _websafePlatform;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _gpsBloc = Provider.of<GpsBloc>(
      context,
      listen: false,
    );
    _gpsBloc.startListening();

    _translationsBloc = TranslationsBloc.of(context);

    _websafePlatform = WebsafePlatform();

    if (_websafePlatform.isAndroid() == true || _websafePlatform.isIOS()) {
      Wakelock.enable();
    }
  }

  @override
  void dispose() {
    if (_websafePlatform.isAndroid() == true || _websafePlatform.isIOS()) {
      Wakelock.disable();
    }
    _gpsBloc.stopListening();
    super.dispose();
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
        title: Text(
          _translationsBloc.translate(
            AppTranslations.title_parade,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ParadeTab(
            tracking: _tracking,
          ),
          StopsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(
            () => setState(() => _tabController.index = index),
          );
        },
        items: [
          _buildBottomNavBarItem(
            context: context,
            label: _translationsBloc.translate(AppTranslations.label_map),
            icon: Icon(Icons.map),
          ),
          _buildBottomNavBarItem(
            context: context,
            label: _translationsBloc.translate(AppTranslations.label_info),
            icon: Icon(Icons.info),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _tracking == true
            ? Theme.of(context).disabledColor
            : Theme.of(context).primaryColor,
        elevation: _tracking == true ? 2 : 4,
        onPressed: () => setState(() => _tracking = !_tracking),
        child: Icon(Icons.location_searching),
      ),
    );
  }
}
