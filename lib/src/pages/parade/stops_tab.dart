import 'dart:async';

import 'package:community_parade/src/bloc/parade_bloc.dart';
import 'package:community_parade/src/models/birthday_person.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StopsTab extends StatefulWidget {
  StopsTab({
    Key key,
  }) : super(key: key);

  @override
  _StopsTabState createState() => _StopsTabState();
}

class _StopsTabState extends State<StopsTab> {
  final List<StreamSubscription> _subscriptions = [];

  ParadeBloc _paradeBloc;
  List<BirthdayPerson> _stops;

  @override
  void initState() {
    super.initState();

    _paradeBloc = Provider.of(
      context,
      listen: false,
    );

    _subscriptions.add(_paradeBloc.subscribe().listen((parade) {
      _stops = parade.birthdays;
      if (mounted == true) {
        setState(() {});
      }
    }));
  }

  @override
  void dispose() {
    _subscriptions.forEach((sub) => sub.cancel());
    _subscriptions.clear();

    super.dispose();
  }

  Widget _buildStop(
    BuildContext context,
    BirthdayPerson stop,
  ) =>
      ListTile(
        subtitle: Text(stop.address),
        title: Text('${stop.name} (${stop.age})'),
      );

  @override
  Widget build(BuildContext context) {
    return _stops == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            color: Colors.white,
            child: ListView.separated(
              padding: EdgeInsets.only(
                bottom: 80.0,
              ),
              itemCount: _stops.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) =>
                  _buildStop(
                context,
                _stops[index],
              ),
              separatorBuilder: (_, __) => Divider(),
            ),
          );
  }
}
