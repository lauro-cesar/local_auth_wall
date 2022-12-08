import 'package:flutter/material.dart';
import 'package:local_auth_wall/local_auth_wall.dart';
import 'package:local_auth_wall/src/auth_wall_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

/// Widget to show when Not Authorized
class NotAuthorizedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: false,
        body: Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Please authorize to access"),
              TextButton(
                  onPressed: () {
                    context.read<AuthWallNotifier>().authorizeRoute(
                        AuthWallDefaultStates.defaultRoute.toString(),
                        "pleas"
                            "e authorize to access");
                  },
                  child: Icon(Icons.security))
            ],
          ),
        ));
  }
}

///
class OnBootState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: false,
        body: Container(
          color: Colors.orange,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Please wait,"),
            ],
          ),
        ));
  }
}

/// Widget to show when hardware requirements not meet...
class NotSupportedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: false,
        body: Container(
          color:Colors.blue,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Sorry, this device is not supported, please, auth using "
                  "the below alternative."),
              TextButton(
                  onPressed: () {
                    ///Call here...
                  },
                  child: Icon(Icons.security))
            ],
          ),
        ));
  }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (BuildContext, child) {
          return LocalAuthWall(
            appConf: {
              AuthWallConfProperty.defaultHelpText: "Please, authorize to "
                  "access.",
              AuthWallConfProperty.autoAuthRootRoute: true,
              AuthWallConfProperty.resetRootRouteOnAnyUnAuthorized: false,
            },
            stateWallWidgets: {
              AuthWallDefaultStates.booting: OnBootState(),
              AuthWallDefaultStates.unauthorized: NotAuthorizedState(),
              AuthWallDefaultStates.unsupported: NotSupportedState(),
              /// child here provided by Flutter MaterialApp, normally the
              /// home route, in this case: MyHomePage
              AuthWallDefaultStates.defaultRoute: child ??
                  Container(
                    alignment: Alignment.center,
                    color: Colors.amber,
                    child: Text("Something is wrong, "
                        "where is my Home Widget??"),
                  )
            },
          );
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  context.read<AuthWallNotifier>().authorizeRoute
                    (AuthWallDefaultStates.defaultRoute.toString());
                },
                child: Text(" Tap to authorize Default Route")),
            Text(
              'Default Route authorized: ${context.watch<AuthWallNotifier>()
                  .routeIsAuthorized
                (AuthWallDefaultStates.defaultRoute.toString())}',
            ),
            Text(
              'Hardware supported: ${context.watch<AuthWallNotifier>()
                  .isSupported}',
            ),

            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthWallNotifier>().authorizeRoute(
              "show_ballance",
              "Please, authorize to see wallet balance").then((_) {
                if(context.read<AuthWallNotifier>().routeIsAuthorized
                  ("show_ballance")){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    elevation: 4,
                    dismissDirection: DismissDirection.down,
                    content: SizedBox(
                      height: 60,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.security),
                          ),
                          Expanded(
                            child: Text(
                              "Nice, authorized with sucess!", style: TextStyle
                              (fontSize:
                            18),),
                          )
                        ],
                      ),
                    ),));


                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    elevation: 4,
                    dismissDirection: DismissDirection.down,
                    content: SizedBox(
                      height: 60,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.security),
                          ),
                          Expanded(
                            child: Text(
                              "Sorry, NOT authorized with sucess!", style:
                            TextStyle
                              (fontSize:
                            18),),
                          )
                        ],
                      ),
                    ),));
                }
          } );
        },
        tooltip: 'Balance',
        child: Icon(Icons.balance),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
