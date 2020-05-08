import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/components/named_route.dart';
import 'package:community_parade/src/theme/app_padding.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:community_parade/src/validators/required_validator.dart';
import 'package:community_parade/src/validators/validator_chain.dart';
import 'package:community_parade/src/widgets/loader_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddManualCommunityPage extends StatefulWidget {
  AddManualCommunityPage({
    Key key,
  }) : super(key: key);

  @override
  _AddManualCommunityPageState createState() => _AddManualCommunityPageState();
}

class _AddManualCommunityPageState extends State<AddManualCommunityPage> {
  String _communityId;
  bool _loading = false;
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
              _translationsBloc.translate(
                AppTranslations.error_message_form,
              ),
        ),
        contentPadding: EdgeInsets.all(AppPadding.medium),
        title: Text(
          _translationsBloc.translate(AppTranslations.error),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    _loading = true;
    if (mounted == true) {
      setState(() {});
    }

    try {
      var form = Form.of(context);
      if (form.validate() == true) {
        var success = await _userBloc.attachToCommunity(_communityId);
        if (success == true) {
          await Navigator.of(context).pushNamedAndRemoveUntil(
            NamedRoute.community,
            (route) => false,
          );
        } else {
          await _showGenericErrorDialog(
            context,
            content: _translationsBloc.translate(
              AppTranslations.message_unable_to_add_community,
            ),
          );
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

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return Form(
      autovalidate: true,
      child: Builder(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: Text(
              _translationsBloc.translate(
                AppTranslations.title_add_community,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(AppPadding.medium),
            child: Material(
              borderRadius: BorderRadius.circular(AppPadding.medium),
              color: Colors.white,
              elevation: 2.0,
              child: Padding(
                padding: EdgeInsets.all(AppPadding.medium),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: _translationsBloc.translate(
                      AppTranslations.label_community_id,
                    ),
                  ),
                  onChanged: (value) => _communityId = value,
                  validator: (value) => ValidatorChain(
                    validators: [
                      RequiredValidator(),
                    ],
                  ).validate(
                    label: _translationsBloc.translate(
                      AppTranslations.label_community_id,
                    ),
                    value: value,
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
              AppPadding.medium,
              0.0,
              AppPadding.medium,
              mq.padding.bottom,
            ),
            width: double.infinity,
            child: Container(
              width: double.infinity,
              child: LoaderButton(
                loading: _loading,
                child: RaisedButton(
                  onPressed: () => _submit(context),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      _translationsBloc.translate(
                        AppTranslations.button_submit,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
