// main.dart
import 'package:flutter/material.dart';
import 'package:frame_it_up/screens/home_screen.dart';
import 'package:frame_it_up/screens/price_list_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frame_it_up/screens/order_screen.dart';
import 'package:frame_it_up/screens/custom_order_screen.dart';
import 'package:frame_it_up/screens/polaroid_screen.dart';
import 'package:frame_it_up/screens/order_history_screen.dart';

void main() {
  runApp(const FrameItUpApp());
}

class FrameItUpApp extends StatelessWidget {
  const FrameItUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Frame It Up',
          themeMode: ThemeMode.dark,
          // Define standard Dark Theme
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.deepPurple,
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple,
              secondary: Colors.amber,
              surface: Color(0xFF1E1E1E),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              elevation: 0,
              centerTitle: true,
            ),
            textTheme: Typography.material2018().white,
          ),
          // Fallback light theme (unused if forced to dark)
          theme: ThemeData(
            primaryColor: Colors.deepPurple,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepPurple,
            ).copyWith(
              secondary: Colors.amber,
            ),
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              elevation: 4,
              centerTitle: true,
            ),
          ),
          home: const HomeScreen(),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/prices': (context) => const PriceListScreen(),
            '/orders': (context) => const OrderScreen(),
            '/custom': (context) => const CustomOrderScreen(),
            '/polaroid': (context) => const PolaroidScreen(),
            '/history': (context) => const OrderHistoryScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
