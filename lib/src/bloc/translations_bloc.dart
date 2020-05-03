import 'package:community_parade/src/translations/translation_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TranslationsBloc {
  TranslationsBloc({
    String language = 'en',
  })  : assert(language?.isNotEmpty == true),
        _language = language;

  String _language;
  Map<String, String> _translations = {};

  static TranslationsBloc of(BuildContext context) {
    TranslationsBloc result;
    try {
      result = Provider.of<TranslationsBloc>(
        context,
        listen: false,
      );
    } catch (e) {
      // ignore and use a default instance
    }

    return result ?? TranslationsBloc();
  }

  Future<void> initialize() async {
    await setLanguage(_language);
  }

  void dispose() {
    _translations = null;
  }

  String translate(TranslationEntry entry, [Map<String, dynamic> args]) {
    var translated = _translations[entry.key] ?? entry.value;

    if (args?.isNotEmpty == true) {
      args.forEach((key, value) {
        translated = translated.replaceAll('{$key}', '$value');
      });
    }

    return translated;
  }

  Future<void> setLanguage(String language) async {
    // TODO: Connect to an API so that the translations can be loaded by language

    _language = language;
    _translations = {};
  }
}
