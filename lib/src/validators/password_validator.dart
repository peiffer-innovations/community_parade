import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:community_parade/src/validators/validator_interface.dart';
import 'package:flutter/material.dart';

class PasswordValidator implements ValidatorInterface {
  @override
  String validate({
    BuildContext context,
    String label,
    String value,
  }) {
    String error;
    var translationsBloc = TranslationsBloc.of(context);

    if (value?.isNotEmpty == true) {
      if (value.length < 8) {
        error = translationsBloc.translate(
          AppTranslations.error_value_min_length,
          {
            'label': label,
            'length': 8,
          },
        );
      }
    }

    return error;
  }
}
