# local_auth_wall

Flutter widget to simplify local auth

## Getting Started

Local Auth wall redirect user to a widget when  authenticated and another if not.


## iOS Integration

```
<key>NSFaceIDUsageDescription</key>
<string>Why is my app authenticating using face id?</string>
```

## Android Integration 

The plugin will build and run on SDK 16+, but isDeviceSupported() will always return false before SDK 23 (Android 6.0).
Activity Changes

Note that local_auth requires the use of a FragmentActivity instead of an Activity. To update your application:

If you are using FlutterActivity directly, change it to FlutterFragmentActivity in your AndroidManifest.xml.

If you are using a custom activity, update your MainActivity.java:

```
    import io.flutter.embedding.android.FlutterFragmentActivity;
    public class MainActivity extends FlutterFragmentActivity {
          // ...
    }
```
     
or MainActivity.kt:

``` 
      import io.flutter.embedding.android.FlutterFragmentActivity

      class MainActivity: FlutterFragmentActivity() {
          // ...
      }
```

to inherit from FlutterFragmentActivity.

## Permissions

Update your project's AndroidManifest.xml file to include the USE_BIOMETRIC permissions:

``` 
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
package="com.example.app">
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<manifest>

```

## Usage example:



In this example we use MaterialApp.builder to encapsulate all your app routes bellow our
ChangeNotifierProvider, so anytime its possible to call ```context.read<AuthWallNotifier>().
routeIsAuthorized(routeName)```  to 
check for the authorization state.

However, you can use LocalAuthWall in any place, with the limitation that only widgets bellow 
will be able to call ```context.read<AuthWallNotifier>().routeIsAuthorized(routeName)```


```
import 'package:flutter/material.dart';
import 'package:local_auth_wall/local_auth_wall.dart';
import 'package:local_auth_wall/src/auth_wall_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

/// Widget to show when Not Authorized
class NotAuthorizedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Please authorize to access"),
              TextButton(onPressed: () {
                context.read<AuthWallNotifier>().authorizeRoute("root","pleas"
                    "e authorize to access");
              } , child: Icon(Icons.security))
            ],
          ),
        )
    );
  }
}

/// Widget to show while checking for requeriments..
class OnBootState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Please wait, checking for hardware support  "),
              TextButton(onPressed: () {
                ///Call here action here..
              } , child: Icon(Icons.security))
            ],
          ),
        )
    );
  }
}


/// Widget to show when hardware requirements not meet...
class NotSupportedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Sorry, this device is not supported, please, auth using "
                  "the below alternative."),
              TextButton(onPressed: () {
               ///Call here...
              } , child: Icon(Icons.security))
            ],
          ),
        )
    );
  }
}



class MyApp extends StatelessWidget {
  /// String to define the defaultRoute (Anytime wee can use context.read<AuthWallNotifier>().
  routeIsAuthorized
  (routeName) to check the authorization state (bool)
  final String defaultRouteName = "root";


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (BuildContext, child) {
          return LocalAuthWall(
          /// minimal set of conf required, this way is           
            appConf: {
              AuthWallConfProperty.defaultHelpText:"Please, authorize to "
                  "access.",
              AuthWallConfProperty.autoAuthRootRoute:true,
              AuthWallConfProperty.resetRootRouteOnAnyUnAuthorized:false,
              AuthWallConfProperty.defaultRouteName:defaultRouteName,
            },
            stateWallWidgets: {
            /// A nice Widget to show while checking for hardware support...
              "${AuthWallDefaultStates.booting}":OnBootState(),
              /// A nice Widget to show if Authorized.
              "${AuthWallDefaultStates.unauthorized}":NotAuthorizedState(),
              /// A nice Widget to show when local_auth its unsupported. 
              "${AuthWallDefaultStates.unsupported}":NotSupportedState(),
              /// child here provided by Flutter MaterialApp, normally the
              /// home route, in this case: MyHomePage
              /// root must match defaultRouteName
              defaultRouteName:child ?? Container(
                alignment: Alignment.center,
                color: Colors.amber,
                child: Text("Something is wrong, "
                  "where is my Home Widget??"),)
            },
          );
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'));
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          (!context.watch<AuthWallNotifier>().routeIsAuthorized("root"))?
            TextButton(
                onPressed: () {
                  context.read<AuthWallNotifier>().authorizeRoute("root");
                },
                child: Text("Autorizar Root")) : Container(),
               
            Text(
              '${context.watch<AuthWallNotifier>().routeIsAuthorized("root")}',
            ),
            Text(
              '${context.watch<AuthWallNotifier>().isSupported}',
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      /// Test for a diferent route
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            /// "wallet_ballance" is just a tag, you can ask to authorize anything.
          context.read<AuthWallNotifier>().authorizeRoute("wallet_ballance","Please, authorize 
          to see your balance");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


```