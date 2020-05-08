import 'package:community_parade/src/bloc/community_bloc.dart';
import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/bloc/gps_bloc.dart';
import 'package:community_parade/src/bloc/rest_client_bloc.dart';
import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/components/named_route.dart';
import 'package:community_parade/src/config/api_config.dart';
import 'package:community_parade/src/models/community.dart';
import 'package:community_parade/src/theme/app_padding.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:rest_client/rest_client.dart';

class CommunitiesPage extends StatefulWidget {
  CommunitiesPage({
    this.autoSelect = true,
    Key key,
  }) : super(key: key);

  final bool autoSelect;

  @override
  _CommunitiesPageState createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  static final Logger _logger = Logger('_CommunitiesPageState');

  Map<String, Community> _communities;
  CommunityBloc _communityBloc;
  List<Community> _communityList;
  ConfigBloc _configBloc;
  FirebaseBloc _firebaseBloc;
  GpsBloc _gpsBloc;
  bool _loading = false;
  RestClientBloc _restClientBloc;
  TranslationsBloc _translationsBloc;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _communityBloc = Provider.of<CommunityBloc>(
      context,
      listen: false,
    );

    _configBloc = Provider.of<ConfigBloc>(
      context,
      listen: false,
    );
    _firebaseBloc = Provider.of<FirebaseBloc>(
      context,
      listen: false,
    );
    _gpsBloc = Provider.of<GpsBloc>(
      context,
      listen: false,
    );
    _restClientBloc = Provider.of<RestClientBloc>(
      context,
      listen: false,
    );
    _translationsBloc = TranslationsBloc.of(context);

    _userBloc = Provider.of<UserBloc>(
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
    await Future.wait([
      _loadNearbyCommunities(),
      _loadFirebaseCommunities(),
    ]);
  }

  Future<void> _loadFirebaseCommunities() async {
    var fbResult = await _firebaseBloc.once(
      [
        'data',
        'users',
        _userBloc.user.userId,
        'communities',
      ],
      onError: ({
        @required dynamic error,
        @required String name,
        StackTrace stack,
      }) async =>
          _logger.severe(
        name,
        error,
        stack,
      ),
    );

    var fbCommunities = <String, Community>{};
    if (fbResult?.isNotEmpty == true) {
      var ids = <String>[];
      fbResult.forEach((key, _) => ids.add(key));
      _communities ??= {};
      await Future.forEach(
        ids,
        (communityId) async {
          var community = await _communityBloc.getCommunity(communityId);

          if (community != null) {
            fbCommunities[communityId] = community;
            _communities[communityId] = community;
          }
        },
      );

      _communityList = _communities.values.toList()..sort();
      if (mounted == true) {
        if (fbCommunities.length == 1) {
          await _userBloc.setCommunityId(fbCommunities.keys.first);
          await Navigator.of(context).pushNamedAndRemoveUntil(
            NamedRoute.community,
            (route) => false,
          );
        } else {
          setState(() {});
        }
      }
    }
  }

  Future<void> _loadNearbyCommunities() async {
    try {
      var position = await _gpsBloc.getCurrentPosition();

      if (mounted == true) {
        if (position != null) {
          var request = Request(
            url: _configBloc
                .value(ApiConfig.communityFromCoordinates)
                .replaceAll('{latitude}', '${position.latitude}')
                .replaceAll('{longitude}', '${position.longitude}'),
          );

          var response = await _restClientBloc.client.execute(request: request);
          var communities =
              Community.fromDynamicList(response.body['communities']);

          if (communities?.isNotEmpty == true) {
            _communities ??= {};
            for (var community in communities) {
              _communities[community.id] = community;
            }

            if (mounted == true) {
              setState(() {});
            }
          }
        } else {
          _communities ??= {};
          if (mounted == true) {
            setState(() {});
          }
        }
      }
    } catch (e, stack) {
      _logger.severe('Error loading nearby communities', e, stack);
      _communities ??= {};

      if (mounted == true) {
        setState(() {});
      }
    }
  }

  Widget _buildChildren(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListView.builder(
        itemCount: _communityList.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) =>
            ListTile(
          onTap: _loading == true
              ? null
              : () async {
                  _loading = true;
                  try {
                    if (mounted == true) {
                      setState(() {});
                      var success = await _userBloc
                          .attachToCommunity(_communityList[index].id);

                      if (success == true) {
                        await Navigator.of(context).pushNamedAndRemoveUntil(
                          NamedRoute.community,
                          (_) => false,
                        );
                      } else {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            actions: <Widget>[
                              RaisedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  _translationsBloc.translate(
                                    AppTranslations.button_dismiss,
                                  ),
                                ),
                              )
                            ],
                            content: Text(
                              _translationsBloc.translate(
                                AppTranslations.error_add_community_failed,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(AppPadding.medium),
                            title: Text(
                              _translationsBloc.translate(
                                AppTranslations.error_default_title,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  } finally {
                    _loading = false;
                    if (mounted == true) {
                      setState(() {});
                    }
                  }
                },
          subtitle: Text(_communityList[index].location),
          title: Text(_communityList[index].name),
        ),
      ),
    );
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
                      AppTranslations.message_no_nearby_communities,
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

  Widget _buildLoading(BuildContext context) {
    return Center(
      key: ValueKey('loading'),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 400.0,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(AppPadding.medium),
          color: Colors.white,
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(AppPadding.medium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: AppPadding.medium),
                Text(
                  _translationsBloc.translate(
                    AppTranslations.message_looking_for_communities,
                  ),
                ),
              ],
            ),
          ),
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
            AppTranslations.title_select_community,
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _communities == null
            ? _buildLoading(context)
            : _communities.isEmpty == true
                ? _buildEmpty(context)
                : _buildChildren(context),
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
        child: RaisedButton(
          onPressed: _loading == true
              ? null
              : () => Navigator.of(context).pushNamed(
                    NamedRoute.add_manual_community,
                  ),
          child: Text(
            _translationsBloc
                .translate(
                  AppTranslations.button_add_manually,
                )
                .toUpperCase(),
          ),
        ),
      ),
    );
  }
}
