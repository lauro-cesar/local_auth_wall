library local_auth_wall;
// ignore_for_file: public_member_api_docs
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

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
  int activeScreen=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      sizing: StackFit.loose,
        index: activeScreen,
        children:
 [
   widget.ifAuthorizedWidget
 ],

        );
  }
}
