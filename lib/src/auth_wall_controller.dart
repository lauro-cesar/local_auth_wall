import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_wall_notifier.dart';

///
class AuthWallController extends StatelessWidget {
  ///

  ///
  const AuthWallController({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthWallNotifier>().defaultRouteIsAuthorized) {
      return context.watch<AuthWallNotifier>().rootWidget;
    }

    return context.watch<AuthWallNotifier>().unauthorizedWidget;
  }
}
