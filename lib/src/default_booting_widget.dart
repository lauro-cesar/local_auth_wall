import 'package:flutter/material.dart';

///
class DefaultOnBootingWidget extends StatelessWidget {
  ///
  const DefaultOnBootingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        height: 48,
        width: 48,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
