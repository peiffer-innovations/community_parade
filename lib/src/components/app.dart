import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/bloc/gps_bloc.dart';
import 'package:community_parade/src/components/app_router.dart';
import 'package:community_parade/src/components/bootstrapper.dart';
import 'package:community_parade/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  App({
    @required this.bootstrapper,
    Key key,
  })  : assert(bootstrapper != null),
        super(key: key);

  final Bootstrapper bootstrapper;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseBloc>.value(value: widget.bootstrapper.firebaseBloc),
        Provider<GpsBloc>.value(value: widget.bootstrapper.gpsBloc),
      ],
      child: MaterialApp(
        navigatorKey: widget.bootstrapper.navigatorKey,
        routes: AppRouter.all,
        theme: AppTheme.theme,
      ),
    );
  }
}
