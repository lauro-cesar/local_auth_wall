import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../local_auth_wall.dart';
import 'auth_wall_controller.dart';
import 'auth_wall_notifier.dart';
import 'default_unsupported_widget.dart';


///
class UnsupportedAuthWallController extends StatelessWidget {
  ///
  const UnsupportedAuthWallController({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    if (context.watch<AuthWallNotifier>().isSupported){
      return AuthWallController();
    }
    /// If unsupported show a nice message and options for auth...
    return context
        .watch<AuthWallNotifier>().unsupportedWidget;

  }
}
