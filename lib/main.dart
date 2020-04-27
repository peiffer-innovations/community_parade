import 'package:community_parade/src/components/app_bootstrap_widget.dart';
import 'package:community_parade/src/components/bootstrapper.dart';
import 'package:flutter/material.dart';

void main() {
  var bootstrapper = Bootstrapper();

  runApp(AppBootstrapWidget(bootstrapper: bootstrapper));
}
