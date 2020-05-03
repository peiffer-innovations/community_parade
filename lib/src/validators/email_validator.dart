import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:community_parade/src/validators/validator_interface.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class EmailValidator implements ValidatorInterface {
  @override
  String validate({
    BuildContext context,
    @required String label,
    @required String value,
  }) {
    assert(label?.isNotEmpty == true);

    String error;

    if (value?.isNotEmpty == true) {
      var pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      var regExp = RegExp(pattern);

      var translationsBloc = TranslationsBloc.of(context);
      if (!regExp.hasMatch(value)) {
        error = translationsBloc.translate(
          AppTranslations.error_invalid_email_address,
          {
            'label': label,
          },
        );
      }
    }

    return error;
  }
}
