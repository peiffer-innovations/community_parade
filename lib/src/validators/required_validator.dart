import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:community_parade/src/validators/validator_interface.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class RequiredValidator implements ValidatorInterface {
  RequiredValidator();

  @override
  String validate({
    BuildContext context,
    @required String label,
    @required String value,
  }) {
    assert(label?.isNotEmpty == true);

    String error;

    if (value?.isNotEmpty != true) {
      var translationsBloc = TranslationsBloc.of(context);
      error = translationsBloc.translate(
        AppTranslations.error_value_required,
        {
          'label': label,
        },
      );
    }

    return error;
  }
}
