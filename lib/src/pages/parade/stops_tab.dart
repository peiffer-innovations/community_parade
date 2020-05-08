import 'dart:async';

import 'package:community_parade/src/models/birthday_person.dart';
import 'package:flutter/material.dart';

class StopsTab extends StatefulWidget {
  StopsTab({
    Key key,
  }) : super(key: key);

  @override
  _StopsTabState createState() => _StopsTabState();
}

class _StopsTabState extends State<StopsTab> {
  final List<StreamSubscription> _subscriptions = [];
  List<BirthdayPerson> _stops;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _subscriptions.forEach((sub) => sub.cancel());
    _subscriptions.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
