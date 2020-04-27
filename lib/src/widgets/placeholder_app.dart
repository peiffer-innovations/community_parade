import 'package:community_parade/src/theme/app_color.dart';
import 'package:community_parade/src/theme/app_image_asset.dart';
import 'package:community_parade/src/theme/app_padding.dart';
import 'package:flutter/material.dart';

class PlaceholderApp extends StatelessWidget {
  PlaceholderApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            height: mq.padding.top,
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: Container(
              color: AppColor.primaryColor,
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 150.0,
                  width: 150.0,
                  child: Image.asset(
                    AppImageAsset.splash,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: AppPadding.medium),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
