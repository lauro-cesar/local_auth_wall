library local_auth_wall;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/auth_wall_notifier.dart';
import 'src/auth_wall_controller.dart';

///
class LocalAuthWall extends StatefulWidget {
  ///
  final String defaultRouteName;

  ///
  final String defaultHelpText;

  /// Register a set of widgets to be
  final Map<String, Widget> stateWallWidgets;

  ///
  final bool autoAuthRootRoute;

  ///
  const LocalAuthWall(
      {Key? key,
      required this.autoAuthRootRoute,
      required this.stateWallWidgets,
        required this.defaultHelpText,
      required this.defaultRouteName})
      : super(key: key);

  @override
  State<LocalAuthWall> createState() => _LocalAuthWallState();
}

class _LocalAuthWallState extends State<LocalAuthWall> {
  late AuthWallNotifier authWallNotifier;

  @override
  void initState() {
    super.initState();
    setState(() {
      authWallNotifier = AuthWallNotifier(
          keyName: "_local_auth_wall_",
          writeToLocalStorage: false,
          defaultHelpText: widget.defaultHelpText,
          autoAuthRootRoute: widget.autoAuthRootRoute,
          defaultRouteName: widget.defaultRouteName,
          initialStateWallWidgets: widget.stateWallWidgets)
        ..onBoot();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => authWallNotifier),
    ], child: AuthWallController());
  }
}
