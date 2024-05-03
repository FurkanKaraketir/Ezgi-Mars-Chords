import 'dart:async';

import 'package:Ezgiler/Song.dart';
import 'package:Ezgiler/SongItem.dart';
import 'package:Ezgiler/songs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Color selectedColor = const Color(0xFFFEA501); // Default selected color
int scrollDuration = 60;
int metronomeBpm = 120;
double lyricsFontSize = 18;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false, // false
      home: const Scaffold(
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
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          'assets/logo.svg', // Replace with the path to your SVG file
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          height: 240.0,
          width: 240.0,
        ),
      ),
      // Replace with your desired icon
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

class BlurredBackground extends StatefulWidget {
  const BlurredBackground({super.key});

  @override
  State<BlurredBackground> createState() => _BlurredBackgroundState();
}

class _BlurredBackgroundState extends State<BlurredBackground> {
  final albumCovers = [
    const Song(
      title: "Haykır · Grup İslami Direniş",
      cover: 'assets/haykir.jpeg',
    ),
    const Song(
      title: "Arşiv",
      cover: 'assets/archive.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      buildGradientOverlay(),
      Positioned(
          top: 60, left: 0, right: 0, bottom: 0, child: albumList(context)),
    ]);
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

  Future<List<String>?> _loadLastPlayedSongs() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? items = prefs.getStringList('items');

      return items;
    } catch (e) {
      // Handle any potential exceptions, e.g., if SharedPreferences fails
      return null;
    }
  }

  var songList = {
    'Ahzab\'daki Yiğitler': 'assets/haykir.jpeg',
    'Dağlardayız Biz Ovalarda': 'assets/haykir.jpeg',
    'Haykır': 'assets/haykir.jpeg',
    'Bağlanmaz ki Yüreğim': 'assets/haykir.jpeg',
    'Savur İnancsız Külleri': 'assets/haykir.jpeg',
    'Kaçış': 'assets/haykir.jpeg',
    'Çocuğum': 'assets/haykir.jpeg',
    'Büyük Şeytana Ölüm': 'assets/haykir.jpeg',
    'Ninni': 'assets/haykir.jpeg',
    'Müstezafin': 'assets/haykir.jpeg',
    'Şehadet Bir Tutku': 'assets/archive.jpg',
    'Yolunda İslamın': 'assets/archive.jpg',
    'Adı Bilinmez Müslüman': 'assets/archive.jpg',
    'Suskunluğun Bedeli': 'assets/archive.jpg',
    'Bak Ülkeme': 'assets/archive.jpg',
    'Şehitler Ölmez': 'assets/archive.jpg',
    'Şehit Tahtında': 'assets/archive.jpg',
    'Ayrılık Türküsü': 'assets/archive.jpg',
    'Özgürlük Türküleri': 'assets/archive.jpg',
    'Andola': 'assets/archive.jpg',
    'Ey Şehid': 'assets/archive.jpg',
    'Mescid-i Aksa': 'assets/archive.jpg',
    'Kardan Aydınlık': 'assets/archive.jpg',
    'Şehadet Uykusu': 'assets/archive.jpg',
    'Bilal': 'assets/archive.jpg',
  };

  Widget _buildLastPlayedSongs() {
    return FutureBuilder<List<String>?>(
      future: _loadLastPlayedSongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Hata: ${snapshot.error}'),
          );
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Çalınan Bir Şarkı Yok",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          );
        } else {
          return Column(children: [
            Container(
              margin: const EdgeInsets.all(20.0),
              child: const Text(
                'En Son Çalınanlar Parçalar',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return SongItem(
                    title: snapshot.data![index],
                    keyNote: "",
                    albumCover: songList[snapshot.data![index]] ?? "",
                  );
                },
              ),
            ),
          ]);
        }
      },
    );
  }

  Widget albumList(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      GestureDetector(
        onTap: () {
          // Navigate to the SongsScreen when an album cover is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SongsScreen(albumTitle: albumCovers[0].title),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(32.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: Image.asset(
                  albumCovers[0].cover,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Text(
                albumCovers[0].title,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Divider(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          // Navigate to the SongsScreen when an album cover is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SongsScreen(albumTitle: albumCovers[1].title),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(32.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: Image.asset(
                  albumCovers[1].cover,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Text(
                albumCovers[1].title,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Divider(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      _buildLastPlayedSongs()
    ]));
  }
}
