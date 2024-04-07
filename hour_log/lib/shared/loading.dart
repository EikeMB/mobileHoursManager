


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[200],
      child: const Center(
        child: SpinKitChasingDots(
          color: Colors.deepPurple,
          size: 50.0,
        ),
      ),
    );
  }
}