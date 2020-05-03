import 'package:auto_size_text/auto_size_text.dart';
import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/components/named_route.dart';
import 'package:community_parade/src/theme/app_image_asset.dart';
import 'package:community_parade/src/theme/app_padding.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:community_parade/src/translations/translation_entry.dart';
import 'package:community_parade/src/validators/email_validator.dart';
import 'package:community_parade/src/validators/password_validator.dart';
import 'package:community_parade/src/validators/required_validator.dart';
import 'package:community_parade/src/validators/validator_chain.dart';
import 'package:community_parade/src/widgets/loader_button.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({
    Key key,
  }) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  static final Logger _logger = Logger('_CreateAccountPageState');
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final Map<String, String> _values = {};

  bool _loading = false;
  TranslationsBloc _translationsBloc;

  @override
  void initState() {
    super.initState();

    _translationsBloc = TranslationsBloc.of(context);
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _createAccount(BuildContext context) async {
    FocusScope.of(context).requestFocus(null);
    _loading = true;
    try {
      if (mounted == true) {
        setState(() {});
      }

      var form = Form.of(context);
      if (form.validate() == true) {
        var userBloc = Provider.of<UserBloc>(
          context,
          listen: false,
        );
        try {
          await userBloc.createAccount(
            firstName: _values['firstName'],
            lastName: _values['lastName'],
            password: _values['password'],
            username: _values['email'],
          );

          await Navigator.of(context).pushNamedAndRemoveUntil(
            NamedRoute.home,
            (route) => false,
          );
        } catch (e, stack) {
          if (e is TranslationEntry) {
            await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                actions: <Widget>[
                  RaisedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      _translationsBloc
                          .translate(
                            AppTranslations.button_dismiss,
                          )
                          .toUpperCase(),
                    ),
                  ),
                ],
                content: Text(
                  _translationsBloc.translate(e),
                ),
                title: Text(
                  _translationsBloc.translate(AppTranslations.error),
                ),
              ),
            );
          } else {
            _logger.severe('Error on create account', e, stack);
            await _showGenericErrorDialog(
              context,
              content: _translationsBloc.translate(
                AppTranslations.error_default_message,
              ),
            );
          }
        }
      } else {
        await _showGenericErrorDialog(context);
      }
    } finally {
      _loading = false;
      if (mounted == true) {
        setState(() {});
      }
    }
  }

  Future<void> _showGenericErrorDialog(
    BuildContext context, {
    String content,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actions: <Widget>[
          RaisedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              _translationsBloc
                  .translate(
                    AppTranslations.button_dismiss,
                  )
                  .toUpperCase(),
            ),
          ),
        ],
        content: Text(
          content ??
              _translationsBloc.translate(AppTranslations.error_message_form),
        ),
        title: Text(
          _translationsBloc.translate(AppTranslations.error),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _translationsBloc.translate(
            AppTranslations.title_create_account,
          ),
        ),
      ),
      body: Form(
        autovalidate: true,
        child: Builder(
          builder: (BuildContext context) => Stack(
            children: [
              Positioned(
                bottom: mq.padding.bottom + (AppPadding.medium * 2) + 40.0,
                left: 0.0,
                right: 0.0,
                top: 0.0,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: AppPadding.medium),
                      Image.asset(
                        AppImageAsset.splash,
                        width: 150.0,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(height: AppPadding.medium),
                      Container(
                        constraints: BoxConstraints(maxWidth: 400.0),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.medium,
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(
                            AppPadding.medium,
                          ),
                          color: Colors.white,
                          elevation: 2.0,
                          child: Padding(
                            padding: EdgeInsets.all(AppPadding.medium),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: _translationsBloc.translate(
                                      AppTranslations.label_email,
                                    ),
                                  ),
                                  enabled: _loading != true,
                                  onChanged: (value) =>
                                      _values['email'] = value,
                                  onFieldSubmitted: (_) =>
                                      Focus.of(context).requestFocus(
                                    _firstNameFocusNode,
                                  ),
                                  validator: (String value) =>
                                      ValidatorChain(validators: [
                                    RequiredValidator(),
                                    EmailValidator(),
                                  ]).validate(
                                    label: _translationsBloc.translate(
                                      AppTranslations.label_email,
                                    ),
                                    value: value,
                                  ),
                                ),
                                SizedBox(height: AppPadding.medium),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: _translationsBloc.translate(
                                      AppTranslations.label_first_name,
                                    ),
                                  ),
                                  enabled: _loading != true,
                                  focusNode: _firstNameFocusNode,
                                  onChanged: (value) =>
                                      _values['firstName'] = value,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).requestFocus(
                                    _lastNameFocusNode,
                                  ),
                                  validator: (String value) =>
                                      ValidatorChain(validators: [
                                    RequiredValidator(),
                                  ]).validate(
                                    label: _translationsBloc.translate(
                                      AppTranslations.label_first_name,
                                    ),
                                    value: value,
                                  ),
                                ),
                                SizedBox(height: AppPadding.medium),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: _translationsBloc.translate(
                                      AppTranslations.label_last_name,
                                    ),
                                  ),
                                  enabled: _loading != true,
                                  focusNode: _lastNameFocusNode,
                                  onChanged: (value) =>
                                      _values['lastName'] = value,
                                  onFieldSubmitted: (value) {
                                    _values['lastName'] = value;
                                    FocusScope.of(context)
                                        .requestFocus(_passwordFocusNode);
                                  },
                                  validator: (String value) =>
                                      ValidatorChain(validators: [
                                    RequiredValidator(),
                                  ]).validate(
                                    label: _translationsBloc.translate(
                                      AppTranslations.label_last_name,
                                    ),
                                    value: value,
                                  ),
                                ),
                                SizedBox(height: AppPadding.medium),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: _translationsBloc.translate(
                                      AppTranslations.label_password,
                                    ),
                                  ),
                                  enabled: _loading != true,
                                  focusNode: _passwordFocusNode,
                                  obscureText: true,
                                  onChanged: (value) =>
                                      _values['password'] = value,
                                  onFieldSubmitted: (value) {
                                    _values['password'] = value;
                                    _createAccount(context);
                                  },
                                  validator: (String value) =>
                                      ValidatorChain(validators: [
                                    RequiredValidator(),
                                    PasswordValidator(),
                                  ]).validate(
                                    label: _translationsBloc.translate(
                                      AppTranslations.label_password,
                                    ),
                                    value: value,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppPadding.medium,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                height: 40.0 + (AppPadding.medium * 2) + mq.padding.bottom,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                    AppPadding.medium,
                    AppPadding.medium,
                    AppPadding.medium,
                    mq.padding.bottom + AppPadding.medium,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: _loading == true
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              _translationsBloc
                                  .translate(
                                    AppTranslations.button_cancel,
                                  )
                                  .toUpperCase(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppPadding.medium),
                      Expanded(
                        child: SizedBox.expand(
                          child: LoaderButton(
                            loading: _loading,
                            child: RaisedButton(
                              onPressed: () => _createAccount(context),
                              child: Container(
                                width: double.infinity,
                                child: AutoSizeText(
                                  _translationsBloc
                                      .translate(
                                        AppTranslations
                                            .login_create_account_button,
                                      )
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
