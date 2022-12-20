import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_wall_boot_controller.dart';
import 'auth_wall_notifier.dart';

///
class AuthWallOverlayController extends StatelessWidget {
  ///
  const AuthWallOverlayController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ///
        AuthWallBootController(),

        ///
        // AnimatedPositioned(
        //     right: 0,
        //     left: 0,
        //     top: (context.watch<AuthWallNotifier>().showLocalAuth)
        //         ? 0
        //         : (MediaQuery.of(context).size.height),
        //     bottom: 0,
        //     duration: Duration(milliseconds: 400),
        //     curve: Curves.easeInOutQuad,
        //
        //     ///
        //     child: Container(
        //       color: Colors.black.withOpacity(0.5),
        //       alignment: Alignment.bottomCenter,
        //       child: SizedBox(
        //         height: MediaQuery.of(context).size.height * 0.3,
        //         child: Container(
        //           color: Colors.white,
        //           alignment: Alignment.center,
        //           child: Column(
        //             children: [
        //               ///
        //               SizedBox(
        //                 height: 48,
        //                 width: 48,
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: CircularProgressIndicator(),
        //                 ),
        //               ),
        //
        //               ///
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: IconButton(
        //                     onPressed: () {
        //                       context
        //                           .read<AuthWallNotifier>()
        //                           .dismissLocalAuth();
        //                     },
        //                     icon: Icon(Icons.cancel)),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     )),
      ],
    );
  }
}
