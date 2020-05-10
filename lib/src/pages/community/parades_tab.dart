import 'package:community_parade/src/bloc/parade_bloc.dart';
import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/components/named_route.dart';
import 'package:community_parade/src/models/parade.dart';
import 'package:community_parade/src/theme/app_padding.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ParadesTab extends StatefulWidget {
  ParadesTab({
    Key key,
  }) : super(key: key);
  @override
  _ParadesTabState createState() => _ParadesTabState();
}

class _ParadesTabState extends State<ParadesTab> {
  ParadeBloc _paradeBloc;
  List<Parade> _parades;
  TranslationsBloc _translationsBloc;

  @override
  void initState() {
    super.initState();

    _paradeBloc = Provider.of<ParadeBloc>(
      context,
      listen: false,
    );

    _translationsBloc = Provider.of<TranslationsBloc>(
      context,
      listen: false,
    );

    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initialize() async {
    _parades = await _paradeBloc.getParades();
    if (mounted == true) {
      setState(() {});
    }
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      key: ValueKey('empty'),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400.0),
        padding: EdgeInsets.all(AppPadding.medium),
        child: Material(
          borderRadius: BorderRadius.circular(AppPadding.medium),
          color: Colors.white,
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(AppPadding.medium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(AppPadding.medium),
                  child: Text(
                    _translationsBloc.translate(
                      AppTranslations.message_no_parades_available,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParade(
    BuildContext context,
    Parade parade,
  ) {
    var now = DateTime.now();
    var tomorrow = now.add(Duration(days: 1));
    var startTime = parade.startDateTime.toLocal();
    var format = "EEEE' at 'h:mmaa";
    if (now.day == startTime.day &&
        now.month == startTime.month &&
        now.year == startTime.year) {
      format = "'Today at 'h:mmaa";
    } else if (tomorrow.day == startTime.day &&
        tomorrow.month == startTime.month &&
        tomorrow.year == startTime.year) {
      format = "'Tomorrow at 'h:mmaa";
    } else if (startTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch >
        Duration(days: 6).inMilliseconds) {
      format = 'MMM d @ h:mmaa';
    }
    var formatted = DateFormat(format).format(startTime);

    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: () async {
          _paradeBloc.setParadeId(parade.id);
          await Navigator.of(context).pushNamed(NamedRoute.parade);
          if (mounted == true) {
            _paradeBloc.setParadeId(null);
          }
        },
        subtitle: Text(
          _translationsBloc.translate(
            AppTranslations.message_birthdays,
            {
              'count': parade.birthdays?.length ?? 0,
            },
          ),
        ),
        title: Text(formatted),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _parades == null
        ? Center(child: CircularProgressIndicator())
        : _parades.isEmpty == true
            ? _buildEmpty(context)
            : ListView.builder(
                itemCount: _parades.length,
                itemBuilder: (BuildContext context, int index) => _buildParade(
                  context,
                  _parades[index],
                ),
              );
  }
}
