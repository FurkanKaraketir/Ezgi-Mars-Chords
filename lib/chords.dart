import 'package:Ezgiler/lyrics.dart';
import 'package:flutter/material.dart';

class ChordsScreen extends StatelessWidget {
  final List<String> chords;

  const ChordsScreen({super.key, required this.chords});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ChordsPage());
  }
}

class MyChordsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyChordsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          // Handle back button press
          Navigator.of(context).pop();
        },
      ),

      // Replace with your desired icon
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

class BlurredBackgroundForChords extends StatelessWidget {
  final List<String> songList = [
    'assets/haykir.jpeg',
    // Add more album covers as needed
  ];

  BlurredBackgroundForChords({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        chordList(),
      ],
    );
  }

  Widget buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_image.png'),
          // Replace with your image asset path
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget chordList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: chords.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              ClipRRect(
                // You can adjust the radius as needed
                borderRadius: BorderRadius.circular(32.0),
                child: Image.asset(
                  'assets/chord_images/${chords[index]}.png',
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                chords[index],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChordsPage extends StatelessWidget {
  const ChordsPage({super.key});

  // This widget is the home page of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyChordsAppBar(),
      extendBodyBehindAppBar: true,
      body: BlurredBackgroundForChords(),
    );
  }
}
