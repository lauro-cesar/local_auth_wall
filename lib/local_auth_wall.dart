library local_auth_wall;


import 'package:flutter/material.dart';
import 'package:local_auth_wall/src/auth_wall_notifier.dart';
import 'package:provider/provider.dart';

import 'src/auth_wall_controller.dart';



///
class LocalAuthWall extends StatefulWidget {
  ///
  final Widget ifAuthorizedWidget;
  ///
  final Widget ifNotAuthorizedWidget;
  ///
  final Widget isAuthenticating;

  ///
  final Widget isBooting;

  ///
  const LocalAuthWall(
      {Key? key,
      required this.ifNotAuthorizedWidget,
      required this.ifAuthorizedWidget,
      required this.isAuthenticating,
        required this.isBooting
      })
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
      authWallNotifier = AuthWallNotifier(keyName: "_local_auth_wall_",
          writeToLocalStorage: false)..onBoot();
    });
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authWallNotifier),
      ],
      child: AuthWallController(
        isBooting: widget.isBooting,
        isAuthenticating: widget.isAuthenticating,
        ifAuthorizedWidget: widget.ifAuthorizedWidget,
        ifNotAuthorizedWidget: widget.ifNotAuthorizedWidget,
      )
    );
  }
}
