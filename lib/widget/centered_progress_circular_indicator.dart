import 'package:flutter/material.dart';

class CenteredProgressCircularIndicator extends StatelessWidget {
  const CenteredProgressCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
