import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/crypto_bloc.dart';
import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/bloc/gps_bloc.dart';
import 'package:community_parade/src/bloc/parade_bloc.dart';
import 'package:community_parade/src/bloc/rest_client_bloc.dart';
import 'package:community_parade/src/bloc/secure_store_bloc.dart';
import 'package:community_parade/src/bloc/sembast_bloc.dart';
import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
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
        Provider<ConfigBloc>.value(
          value: widget.bootstrapper.configBloc,
        ),
        Provider<CryptoBloc>.value(
          value: widget.bootstrapper.cryptoBloc,
        ),
        Provider<FirebaseBloc>.value(
          value: widget.bootstrapper.firebaseBloc,
        ),
        Provider<GpsBloc>.value(
          value: widget.bootstrapper.gpsBloc,
        ),
        Provider<ParadeBloc>.value(
          value: widget.bootstrapper.paradeBloc,
        ),
        Provider<RestClientBloc>.value(
          value: widget.bootstrapper.restClientBloc,
        ),
        Provider<SecureStoreBloc>.value(
          value: widget.bootstrapper.secureStoreBloc,
        ),
        Provider<SembastBloc>.value(
          value: widget.bootstrapper.sembastBloc,
        ),
        Provider<TranslationsBloc>.value(
          value: widget.bootstrapper.translationsBloc,
        ),
        Provider<UserBloc>.value(
          value: widget.bootstrapper.userBloc,
        ),
      ],
      child: MaterialApp(
        navigatorKey: widget.bootstrapper.navigatorKey,
        routes: AppRouter.all,
        theme: AppTheme.theme,
      ),
    );
  }
}
