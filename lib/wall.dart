library local_auth_wall;

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class LocalAuthWall extends StatefulWidget {
  final Widget ifAuthorizedWidget;
  final Widget ifNotAuthorizedWidget;

  const LocalAuthWall({Key? key, required this.ifNotAuthorizedWidget,
  required this.ifAuthorizedWidget}) :
        super(key: key);

  @override
  State<LocalAuthWall> createState() => _LocalAuthWallState();
}

class _LocalAuthWallState extends State<LocalAuthWall> {

  @override
  Widget build(BuildContext context) {
    return  widget.ifAuthorizedWidget;
  }
}

