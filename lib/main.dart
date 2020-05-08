import 'package:community_parade/src/components/app_bootstrap_widget.dart';
import 'package:community_parade/src/components/bootstrapper.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rest_client/rest_client.dart';

void main() {
  Logger.root.level = Level.INFO;
  assert(() {
    Logger.root.level = Level.ALL;
    return true;
  }());
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '${record.level.name}: ${record.time}: ${record.message} -- ${record.error}');
    if (record.stackTrace != null) {
      debugPrint('${record.stackTrace}');
    }
  });
  var bootstrapper = Bootstrapper();

  // assert(() {
  //   Client.proxy = Proxy(
  //     ignoreBadCertificate: true,
  //     url: '192.168.86.42:8888',
  //   );

  //   return true;
  // }());

  runApp(AppBootstrapWidget(bootstrapper: bootstrapper));
}
