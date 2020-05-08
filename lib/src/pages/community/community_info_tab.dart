import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/components/named_route.dart';
import 'package:community_parade/src/theme/app_padding.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CommunityInfoTab extends StatefulWidget {
  CommunityInfoTab({
    Key key,
  }) : super(key: key);

  @override
  _CommunityInfoTabState createState() => _CommunityInfoTabState();
}

class _CommunityInfoTabState extends State<CommunityInfoTab> {
  TranslationsBloc _translationsBloc;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _translationsBloc = TranslationsBloc.of(context);
    _userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 48.0 + (AppPadding.medium * 2.0),
          left: 0.0,
          right: 0.0,
          top: 0.0,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 400.0,
                ),
                padding: EdgeInsets.all(AppPadding.medium),
                child: Material(
                  borderRadius: BorderRadius.circular(AppPadding.medium),
                  color: Colors.white,
                  elevation: 2.0,
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.medium),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        QrImage(
                          data: _userBloc.communityId,
                        ),
                        SizedBox(
                          height: AppPadding.medium,
                        ),
                        Text(
                          'This is your community QR code.  If another community member is having difficulty finding the community in the app, have him or her use the Scan feature to scan it.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Material(
            color: Colors.white,
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.all(AppPadding.medium),
              child: RaisedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  NamedRoute.logout,
                  (route) => false,
                ),
                child: Text(
                  _translationsBloc.translate(AppTranslations.button_logout),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
