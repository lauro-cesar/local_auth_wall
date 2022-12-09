library local_auth_wall;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/auth_wall_notifier.dart';
import '/src/auth_wall_overlay_controller.dart';

export '/src/auth_wall_notifier.dart';

///
enum AuthWallConfProperty {
  ///
  defaultRouteName,

  ///
  defaultHelpText,

  ///
  resetRootRouteOnAnyUnAuthorized,

  ///
  autoAuthRootRoute,
}

///
enum AuthWallDefaultStates {
  ///
  booting,

  ///
  authorized,

  ///
  unknown,

  ///
  supported,

  ///
  unsupported,

  ///
  unauthorized,

  ///
  defaultRoute
}

///
class LocalAuthWall extends StatefulWidget {
  /// Register a set of widgets to be
  final Map<AuthWallDefaultStates, Widget> stateWallWidgets;

  ///
  final Map<AuthWallConfProperty, dynamic> appConf;

  ///
  const LocalAuthWall({
    Key? key,
    required this.appConf,
    required this.stateWallWidgets,
  }) : super(key: key);

  @override
  State<LocalAuthWall> createState() => _LocalAuthWallState();
}

class _LocalAuthWallState extends State<LocalAuthWall> {
  ///
  late AuthWallNotifier authWallNotifier;

  ///
  String get defaultHelpText =>
      widget.appConf[AuthWallConfProperty.defaultHelpText];

  ///
  bool get autoAuthRootRoute =>
      widget.appConf[AuthWallConfProperty.autoAuthRootRoute];

  ///
  String get defaultRouteName =>
      widget.appConf[AuthWallConfProperty.defaultRouteName];

  @override
  void initState() {
    super.initState();

    setState(() {
      authWallNotifier = AuthWallNotifier(
          keyName: "_local_auth_wall_",

          /// Save the state on local storage to persist routes already
          /// authenticated
          writeToLocalStorage: false,
          appConf: widget.appConf,
          initialStateWallWidgets: widget.stateWallWidgets)
        ..onBoot();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => authWallNotifier),
    ], child: Scaffold(primary: false, body: AuthWallOverlayController()));
  }
}
