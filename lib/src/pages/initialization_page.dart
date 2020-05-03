import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/components/bootstrapper.dart';
import 'package:community_parade/src/components/named_route.dart';
import 'package:community_parade/src/widgets/placeholder_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class InitializationPage extends StatefulWidget {
  InitializationPage({
    this.bootstrapper,
    Key key,
  }) : super(key: key);

  final Bootstrapper bootstrapper;

  @override
  _InitializationPageState createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    var route = NamedRoute.login;
    var userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    if (userBloc.user != null) {
      route = NamedRoute.home;
    }

    SchedulerBinding.instance.addPostFrameCallback(
      (_) async => await Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlaceholderApp();
  }
}
