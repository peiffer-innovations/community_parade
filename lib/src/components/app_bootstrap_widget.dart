import 'dart:async';

import 'package:community_parade/src/components/app.dart';
import 'package:community_parade/src/components/bootstrapper.dart';
import 'package:community_parade/src/pages/error_page.dart';
import 'package:community_parade/src/theme/app_color.dart';
import 'package:community_parade/src/theme/app_theme.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:community_parade/src/widgets/placeholder_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class AppBootstrapWidget extends StatefulWidget {
  AppBootstrapWidget({
    this.autoRun,
    @required this.bootstrapper,
    Key key,
  })  : assert(bootstrapper != null),
        super(key: key);

  final bool autoRun;
  final Bootstrapper bootstrapper;

  @override
  _AppBootstrapWidgetState createState() => _AppBootstrapWidgetState();
}

class _AppBootstrapWidgetState extends State<AppBootstrapWidget> {
  static final Logger _logger = Logger('_AppBootstrapWidgetState');

  Bootstrapper _bootstrapper;
  bool _error = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _bootstrapper = widget.bootstrapper;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: AppColor.primaryColor,
          systemNavigationBarColor: AppColor.primaryColor,
        ),
      );
    });

    _initialize();
  }

  Future<void> _initialize() async {
    _error = false;
    _initialized = false;

    if (mounted == true) {
      setState(() {});
    }

    try {
      await _bootstrapper.bootstrap();
      _initialized = true;

      if (mounted == true) {
        setState(() {});
      }
    } catch (e, stack) {
      _logger.severe('Error during bootstrap', e, stack);
      _bootstrapper = _bootstrapper.reinitialize();
      _initialized = false;
      _error = true;
    }

    if (mounted == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) => _initialized == true
          ? App(
              bootstrapper: _bootstrapper,
            )
          : _error == true
              ? MaterialApp(
                  theme: AppTheme.theme,
                  home: ErrorPage(
                    buttonLabel: AppTranslations.app_retry,
                    message: AppTranslations.app_error_message,
                    onButtonPressed: () => _initialize(),
                    title: AppTranslations.app_error_title,
                  ),
                )
              : MaterialApp(
                  theme: AppTheme.theme,
                  home: PlaceholderApp(),
                ),
    );
  }
}
