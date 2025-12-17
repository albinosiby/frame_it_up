// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frame_it_up/widgets/feature_card.dart';
import 'package:frame_it_up/widgets/background_wrapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'FRAME IT UP',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Your Memories, Perfectly Framed',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    FeatureCard(
                      icon: Icons.add_photo_alternate,
                      title: 'New Order',
                      subtitle: 'Standard Sizes',
                      color: Colors.deepPurple,
                      onTap: () {
                        Navigator.pushNamed(context, '/orders');
                      },
                    ),
                    FeatureCard(
                      icon: Icons.dashboard_customize,
                      title: 'Custom Order',
                      subtitle: 'Any Size & Frame',
                      color: Colors.amber[700]!,
                      onTap: () {
                        Navigator.pushNamed(context, '/custom');
                      },
                    ),
                    FeatureCard(
                      icon: Icons.camera_alt,
                      title: 'Polaroids',
                      subtitle: '20 Pics / Set',
                      color: Colors.pink,
                      onTap: () {
                        Navigator.pushNamed(context, '/polaroid');
                      },
                    ),
                    FeatureCard(
                      icon: Icons.price_check,
                      title: 'Price List',
                      subtitle: 'Frame Rates',
                      color: Colors.green,
                      onTap: () {
                        Navigator.pushNamed(context, '/prices');
                      },
                    ),
                    FeatureCard(
                      icon: Icons.history,
                      title: 'Order History',
                      subtitle: 'Track Orders',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, '/history');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
