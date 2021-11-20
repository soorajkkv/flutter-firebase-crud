import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Lottie.asset(
        'assets/icons/loading.json',
        height: 50.0,
        width: 50.0,
      )),
    );
  }
}
