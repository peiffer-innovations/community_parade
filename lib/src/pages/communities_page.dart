import 'package:flutter/material.dart';

class CommunitiesPage extends StatefulWidget {
  CommunitiesPage({
    Key key,
  }) : super(key: key);

  @override
  _CommunitiesPageState createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  List<Widget> _buildChildren(BuildContext context) {
    return [SizedBox()];
  }

  List<Widget> _buildEmpty(BuildContext context) {
    return [SizedBox()];
  }

  @override
  Widget build(BuildContext context) {}
}
