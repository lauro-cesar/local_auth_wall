import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../local_auth_wall.dart';
import 'default_booting_widget.dart';
import 'default_unauthorized_widget.dart';
import 'default_unsupported_widget.dart';

///
class AuthWallNotifier extends ChangeNotifier {
  ///
  final String keyName;

  ///
  final Map<AuthWallConfProperty, dynamic> appConf;

  ///
  bool get resetRootRouteOnAnyUnAuthorized =>
      appConf[AuthWallConfProperty.resetRootRouteOnAnyUnAuthorized];

  ///
  String get defaultHelpText => appConf[AuthWallConfProperty.defaultHelpText];

  ///
  bool get autoAuthRootRoute => appConf[AuthWallConfProperty.autoAuthRootRoute];

  ///
  final bool? writeToLocalStorage;

  ///
  final bool? debugMode;

  ///
  final bool? autoNotify;

  ///
  final List<String>? keepKeys;

  ///
  final List<String>? excludeKeys;

  List<String> get _keepKeys {
    return keepKeys ?? [];
  }

  List<String> get _excludeKeys {
    return excludeKeys ?? [];
  }

  ///
  String? getStringKey(String key) {
    return instanceMap[key] ?? null;
  }

  ///
  final Map<String, dynamic> _initialMap = {"isLoaded": true};

  ///
  final Map<String, dynamic> _instanceMap = {};

  ///
  final Map<AuthWallDefaultStates, Widget> initialStateWallWidgets;

  ///
  UnmodifiableMapView<String, dynamic> get instanceMap =>
      UnmodifiableMapView(_instanceMap);

  /// Documentation
  AuthWallNotifier(
      {required this.keyName,
      this.writeToLocalStorage,
      this.debugMode,
      this.keepKeys,
      this.excludeKeys,
      required this.appConf,
      required this.initialStateWallWidgets,
      this.autoNotify}) {
    ;
    reloadMap().then((_) => {
          if (autoNotify ?? true) {notifyListeners()}
        });
  }

  ///
  Future<void> onBoot() async {
    _authorizedRoutes = {};
    _stateWallWidgets = {};
    _stateWallWidgets.addAll(initialStateWallWidgets);
    notifyListeners();
    _isSupported = await _auth.isDeviceSupported();
    notifyListeners();

    if (autoAuthRootRoute) {
      await authorizeRoute(
          AuthWallDefaultStates.defaultRoute.toString(), defaultHelpText);
    }
    _isReady = true;
    notifyListeners();
  }

  ///
  final LocalAuthentication _auth = LocalAuthentication();

  ///
  LocalAuthentication get auth => _auth;

  bool _isReady = false;

  ///
  bool get isReady => _isReady;

  ///
  bool _isSupported = false;

  ///
  bool get isSupported => _isSupported;

  ///
  late Map<AuthWallDefaultStates, Widget> _stateWallWidgets;

  ///
  ///
  Map<AuthWallDefaultStates, Widget> get stateWallWidgets => _stateWallWidgets;

  ///
  Widget get rootWidget =>
      stateWallWidgets[AuthWallDefaultStates.defaultRoute] ??
      DefaultUnAuthorizedWidget();

  ///
  Widget get unsupportedWidget =>
      stateWallWidgets[AuthWallDefaultStates.unsupported] ??
      DefaultUnsupportedWidget();

  ///
  Widget get unauthorizedWidget =>
      stateWallWidgets[AuthWallDefaultStates.unauthorized] ??
      DefaultUnAuthorizedWidget();

  ///
  Widget get bootingWidget =>
      stateWallWidgets[AuthWallDefaultStates.booting] ??
      DefaultOnBootingWidget();

  ///
  Future<void> onRegisterWallWidget(
      Map<AuthWallDefaultStates, Widget> widgets) async {
    _stateWallWidgets.addAll(widgets);
    notifyListeners();
  }

  late Map<String, bool> _authorizedRoutes;

  ///
  Map<String, bool> get authorizedRoutes => _authorizedRoutes;

  ///
  bool get defaultRouteIsAuthorized =>
      routeIsAuthorized(AuthWallDefaultStates.defaultRoute.toString());

  ///
  bool routeIsAuthorized(String route) {
    return _authorizedRoutes[route] ?? false;
  }

  ///
  Future<void> authorizeRoute(String route,
      [String reason = "Autorização necessária"]) async {
    if (isSupported) {
      await askLocalAuth();
      var success = await auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );

      if (success) {
        _authorizedRoutes[route] = success;
      } else {
        if (resetRootRouteOnAnyUnAuthorized) {
          _authorizedRoutes.clear();
        } else {
          _authorizedRoutes.remove(route);
        }
      }
      await dismissLocalAuth();
    }
  }

  ///
  bool _showLocalAuth = false;

  ///
  bool get showLocalAuth => _showLocalAuth;

  ///
  Future<void> askLocalAuth() async {
    _showLocalAuth = true;
    notifyListeners();
  }

  ///
  Future<void> dismissLocalAuth() async {
    _showLocalAuth = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> _onComputeJson(String inputData) async {
    return jsonDecode(inputData);
  }

  ///
  Future<Map<String, dynamic>> onComputeJson(String inputData) async {
    return await compute(_onComputeJson, inputData);
  }

  ///
  Future<String> get localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  ///
  Future<File> sourceFile(String filename) async {
    final path = await localPath;
    return File('$path/$filename');
  }

  ///
  Future<File> outPutFile(String filename) async {
    final path = await localPath;
    return File('$path/$filename');
  }

  ///
  Future<File> saveData(String data, String filename) async {
    final file = await outPutFile(filename);
    await file.writeAsString('$data');
    return file;
  }

  ///
  Future<String> loadFilePath(String filename) async {
    final file = await outPutFile(filename);
    if (file.existsSync()) {
      return await file.readAsString();
    } else {
      return "{}";
    }
  }

  ///
  Future<String> loadData(File file) async {
    return await file.readAsString();
  }

  ///
  Future<void> reloadMap() async {
    await _loadAppState();
  }

  ///
  void onAdd(Map<String, dynamic> values) {
    _instanceMap.addAll(values);
  }

  ///
  Future<void> onNotify() async {
    notifyListeners();
  }

  ///
  Future<void> onSave() async {
    _saveAppState();
  }

  ///
  Future<void> addAndSave(Map<String, dynamic> values) async {
    _instanceMap.addAll(values);
    _saveAppState().then((value) => {notifyListeners()});
  }

  ///
  Future<void> add(Map<String, dynamic> values) async {
    _instanceMap.addAll(values);
    _saveAppState().then((value) => {notifyListeners()});
  }

  ///
  Future<void> removeKey(String keyName) async {
    _instanceMap.remove(keyName);
    await _saveAppState();
    notifyListeners();
  }

  ///
  Future<void> del(Map<String, dynamic> values) async {
    _instanceMap.remove(values);
    _saveAppState().then((value) => {notifyListeners()});
  }

  ///
  Future<void> removeAll() async {
    ///
    var _writeMap = {};

    for (var key in _keepKeys) {
      _writeMap.addAll(_instanceMap[key]);
      if (debugMode ?? false) {
        print("keeping key: $key");
      }
    }
    _instanceMap.clear();
    _instanceMap.addAll(_initialMap);
    _instanceMap.addAll(_writeMap.cast());
    _saveAppState().then((value) => {notifyListeners()});
  }

  Future<void> _loadAppState() async {
    if (writeToLocalStorage ?? true) {
      var sharedPrefs = await SharedPreferences.getInstance();
      if (sharedPrefs.containsKey(keyName)) {
        _instanceMap
            .addAll(jsonDecode(sharedPrefs.getString('$keyName').toString()));
      } else {
        _instanceMap.addAll(_initialMap);
      }
    } else {
      if (debugMode ?? false) {
        print("save not found");
      }
      _instanceMap.addAll(_initialMap);
    }
  }

  Future<void> _saveAppState() async {
    if (writeToLocalStorage ?? true) {
      var sharedPrefs = await SharedPreferences.getInstance();
      var _writeMap = {};
      _writeMap.addAll(_instanceMap);
      for (var key in _excludeKeys) {
        _writeMap.remove(key);
        if (debugMode ?? false) {
          print("Removing key: $key");
        }
      }
      await sharedPrefs.setString('$keyName', jsonEncode(_writeMap));
    } else {
      if (debugMode ?? false) {
        print("not write");
      }
    }
  }
}
