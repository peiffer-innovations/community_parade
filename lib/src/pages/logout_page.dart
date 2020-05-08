import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/bloc/gps_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/components/named_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    var gpsBloc = Provider.of<GpsBloc>(
      context,
      listen: false,
    );
    await gpsBloc.stopListening();

    var firebaseBloc = Provider.of<FirebaseBloc>(
      context,
      listen: false,
    );
    await firebaseBloc.logout();

    var userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );
    await userBloc.logout();

    if (mounted == true) {
      await Navigator.of(context).pushNamedAndRemoveUntil(
        NamedRoute.initialize,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
