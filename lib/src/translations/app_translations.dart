import 'package:community_parade/src/translations/translation_entry.dart';

class AppTranslations {
  AppTranslations._();

  static const app_retry = TranslationEntry(
    key: 'app_retry',
    value: 'RETRY',
  );

  static const app_error_message = TranslationEntry(
    key: 'app_error_message',
    value: 'The app failed to initialize.  Please retry.',
  );

  static const app_error_title = TranslationEntry(
    key: 'app_error_title',
    value: 'Error',
  );

  static const error_default_button = TranslationEntry(
    key: 'error_default_button',
    value: 'GO HOME',
  );

  static const error_default_message = TranslationEntry(
    key: 'error_default_message',
    value: 'An unknown system error has occurred',
  );

  static const error_default_title = TranslationEntry(
    key: 'error_default_title',
    value: 'Error',
  );
}
