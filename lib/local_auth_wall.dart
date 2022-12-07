library local_auth_wall;
// ignore_for_file: public_member_api_docs
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_wall/src/auth_wall_notifier.dart';
import 'package:provider/provider.dart';

import 'src/auth_wall_controller.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class LocalAuthWall extends StatefulWidget {
  final Widget ifAuthorizedWidget;
  final Widget ifNotAuthorizedWidget;
  final Widget isAuthenticating;

  const LocalAuthWall(
      {Key? key,
      required this.ifNotAuthorizedWidget,
      required this.ifAuthorizedWidget,
      required this.isAuthenticating
      })
      : super(key: key);

  @override
  State<LocalAuthWall> createState() => _LocalAuthWallState();
}

class _LocalAuthWallState extends State<LocalAuthWall> {

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  late AuthWallNotifier authWallNotifier;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      authWallNotifier = AuthWallNotifier(keyName: "_local_auth_wall_",
          writeToLocalStorage: false);
    });



  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authWallNotifier),
      ],
      child: AuthWallController(
        isAuthenticating: widget.isAuthenticating,
        ifAuthorizedWidget: widget.ifAuthorizedWidget,
        ifNotAuthorizedWidget: widget.ifNotAuthorizedWidget,
      )
    );
  }
}
