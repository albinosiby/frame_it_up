import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'order_screen.dart';

void main() {
  runApp(const FrameItUpApp());
}

class FrameItUpApp extends StatelessWidget {
  const FrameItUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Frame It Up',
          theme: ThemeData(primarySwatch: Colors.brown, fontFamily: 'Roboto'),
          home: const OrderScreen(),
        );
      },
    );
  }
}
