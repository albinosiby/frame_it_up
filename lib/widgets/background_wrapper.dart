// widgets/background_wrapper.dart
import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_image.jpeg'),
          fit: BoxFit.cover,
          opacity: 0.15, // Low opacity for readability
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
