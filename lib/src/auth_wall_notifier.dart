import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
class AuthWallNotifier extends ChangeNotifier {
  ///
  final String keyName;
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
  UnmodifiableMapView<String, dynamic> get instanceMap =>
      UnmodifiableMapView(_instanceMap);

  /// Documentation
  AuthWallNotifier(
      {required this.keyName,
      this.writeToLocalStorage,
      this.debugMode,
      this.keepKeys,
      this.excludeKeys,
      this.autoNotify}) {
    reloadMap().then((_) => {
          if (autoNotify ?? true) {notifyListeners()}
        });
  }


  ///
  Future<void> onBoot() async {

    _isSupported = await _auth.isDeviceSupported();


    Future.delayed(Duration(seconds: 10), () {
      _isReady=true;
      notifyListeners();
    });


  }

  ///
  final LocalAuthentication _auth = LocalAuthentication();

  ///
  LocalAuthentication get auth => _auth;

  bool _isReady = false;

  ///
  bool get isReady => _isReady;

  ///
  bool _canCheckBiometrics = true;
  ///
  bool get canCheckBiometrics => _canCheckBiometrics;

  ///
  bool _isSupported = false;
  ///
  bool get isSupported => _isSupported;

  List<BiometricType>? _availableBiometrics;

  List<String>  _authorizedRoutes =[];

  List<String> get authorizedRoutes => _authorizedRoutes;

  ///
  bool routeIsAuthorized(String route) {
    return _authorizedRoutes.contains(route);
  }


  ///
  String _authorized = 'Not Authorized';
  ///
  bool _isAuthenticating = false;

  ///
  bool _showLocalAuth = false;

  ///
  bool get showLocalAuth => _showLocalAuth;

  ///
  Future<void> askLocalAuth() async {
    _showLocalAuth=true;
    notifyListeners();
  }

  ///
  Future<void> dismissLocalAuth() async {
    _showLocalAuth=false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> _onComputeJson(String inputData) async {
    return jsonDecode(inputData);
  }
  ///
  Future<Map<String, dynamic>> onComputeJson(String inputData) async {
    return await compute(_onComputeJson,inputData);
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
      var  _writeMap = {};
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
