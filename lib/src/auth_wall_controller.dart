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
    return Scaffold(
      primary: false,
      body: Stack(
        children: [
          (context.watch<AuthWallNotifier>().defaultRouteIsAuthorized)
              ? context
              .watch<AuthWallNotifier>()
              .stateWallWidgets["root"] ?? Container() : context
        .watch<AuthWallNotifier>()
        .stateWallWidgets["not_authorized"] ?? Container(
            color: Colors.red,
            child: Text("Nao estou autorizado"),
          ),


          AnimatedPositioned(
                  right: 0,
                  left: 0,
                  top: (context.watch<AuthWallNotifier>().showLocalAuth)
                      ? 0
                      : (MediaQuery.of(context).size.height),
                  bottom: 0,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOutQuad,
                  child: Container(
                    color: Colors.white.withOpacity(0.5),
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Container(
                        color: Colors.amber,
                      ),
                    ),
                  )),
        ],
      ),
    );
  }
}
