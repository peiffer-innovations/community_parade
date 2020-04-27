import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/theme/app_padding.dart';
import 'package:community_parade/src/translations/translation_entry.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({
    @required this.buttonLabel,
    Key key,
    @required this.message,
    @required this.onButtonPressed,
    @required this.title,
  })  : assert(buttonLabel != null),
        assert(message != null),
        assert(onButtonPressed != null),
        assert(title != null),
        super(key: key);

  final TranslationEntry buttonLabel;
  final double contentHeight = 400.0;
  final double iconSize = 150.0;
  final TranslationEntry message;
  final VoidCallback onButtonPressed;
  final TranslationEntry title;

  @override
  Widget build(BuildContext context) {
    var translationsBloc = TranslationsBloc.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translationsBloc.translate(title)),
      ),
      body: Column(
        children: <Widget>[
          Icon(
            Icons.warning,
            size: iconSize,
          ),
          SizedBox(
            height: AppPadding.medium,
          ),
          Text(
            translationsBloc.translate(message),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: AppPadding.medium,
          ),
          RaisedButton(
            onPressed: () => onButtonPressed(),
            child: Text(translationsBloc.translate(buttonLabel)),
          ),
        ],
      ),
    );
  }
}
