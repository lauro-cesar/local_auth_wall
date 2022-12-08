import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../local_auth_wall.dart';
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
              ? context.watch<AuthWallNotifier>().stateWallWidgets["root"] ??
                  Container()
              : context
                      .watch<AuthWallNotifier>()
                      .stateWallWidgets[AuthWallState.unauthorized] ??
                  Container(
                    color: Colors.red,
                    child: Column(
                      children: [
                        Text("Please authorize root route"),
                        TextButton(
                            onPressed: () {
                              context
                                  .read<AuthWallNotifier>()
                                  .authorizeRoute("root");
                            },
                            child: Icon(Icons.security))
                      ],
                    ),
                  ),
          //
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
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 5,
                          width:MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearProgressIndicator(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(onPressed: () {
                            context.read<AuthWallNotifier>().dismissLocalAuth();
                          }, icon: Icon(Icons.cancel)),
                        )
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
