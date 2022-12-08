import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/auth_wall_unsupported_controller.dart';
import 'auth_wall_notifier.dart';

///
class AuthWallBootController extends StatelessWidget {
  ///
  const AuthWallBootController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthWallNotifier>().isReady) {
      /// Lets test device capabilities.
      return UnsupportedAuthWallController();
    }

    /// while on boot, show a nice loading screen
    return context.watch<AuthWallNotifier>().bootingWidget;
  }
}
