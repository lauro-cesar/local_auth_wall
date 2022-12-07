import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_wall_notifier.dart';

///
class AuthWallController extends StatelessWidget {
  ///
  final Widget ifAuthorizedWidget;
  ///
  final Widget ifNotAuthorizedWidget;
  ///
  final Widget isAuthenticating;
  ///
  final Widget isBooting;


  ///
  const AuthWallController(
      {Key? key,
      required this.isAuthenticating,
      required this.ifAuthorizedWidget,
      required this.ifNotAuthorizedWidget,
      required this.isBooting
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      body: Stack(
        children: [
          (context.watch<AuthWallNotifier>().isReady) ? ifAuthorizedWidget :
          isBooting,
          AnimatedPositioned(
              right: 0,
              left: 0,
              top: (context.watch<AuthWallNotifier>().showLocalAuth)
                  ? 0
                  : (MediaQuery.of(context).size.height),
              bottom: 0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOutQuad,
              child: Container(
                color: Colors.white.withOpacity(0.5),
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Container(
                    color: Colors.amber,
                    child: ListView(
                      children: [
                        IconButton(
                            onPressed: () {
                              context.read<AuthWallNotifier>().dismissLocalAuth();
                            },
                            icon: const Icon(Icons.expand_circle_down),
                            color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
