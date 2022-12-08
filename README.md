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

```java
    import io.flutter.embedding.android.FlutterFragmentActivity;
    public class MainActivity extends FlutterFragmentActivity {
          // ...
    }
```
     
or MainActivity.kt:

```kotlin
      import io.flutter.embedding.android.FlutterFragmentActivity

      class MainActivity: FlutterFragmentActivity() {
          // ...
      }
```

to inherit from FlutterFragmentActivity.

## Permissions

Update your project's AndroidManifest.xml file to include the USE_BIOMETRIC permissions:

```manifest
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
package="com.example.app">
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<manifest>

```

## Usage example:



In this example we use MaterialApp.builder to encapsulate all app routes bellow our
ChangeNotifierProvider, so anytime its possible to call ```context.read<AuthWallNotifier>().
routeIsAuthorized(routeName)```  to 
check for the authorization state.

However, you can use LocalAuthWall in any place, with the limitation that only widgets bellow 
will be able to call ```context.read<AuthWallNotifier>().routeIsAuthorized(routeName)```


## Basic usage

```dart 

MaterialApp(
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
              /// root must match defaultRouteName
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


```




```dart
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
        primary: false,
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
        primary: false,
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
        primary: false,
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
  /// String to define the defaultRoute (Anytime wee can use context.read<AuthWallNotifier>().routeIsAuthorized(routeName) to check the authorization state (bool)
  

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


```