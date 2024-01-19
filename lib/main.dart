import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // false
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(),
        body: BlurredBackground(),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Ezgiler ve Marşlar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle search button press
          },
        ),
      ],
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          'assets/logo.svg', // Replace with the path to your SVG file
          color: Colors.white,
          height: 240.0,
          width: 240.0,
        ),
      ),
      // Replace with your desired icon
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.white,
          height: 1.0,
        ),
      ),
    );
  }
}

class BlurredBackground extends StatelessWidget {
  const BlurredBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 1: Background Image with Blur
        buildBlurredBackground(),

        // Step 2: Gradient Overlay
        buildGradientOverlay(),
      ],
    );
  }

  Widget buildBlurredBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/haykir.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: const Color(0xFF0B1627).withOpacity(0.5),
        ),
      ),
    );
  }

  Widget buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF0B1627).withOpacity(1),
          ],
        ),
      ),
    );
  }
}
