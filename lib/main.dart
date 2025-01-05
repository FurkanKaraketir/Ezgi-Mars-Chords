import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:Ezgiler/Song.dart';
import 'package:Ezgiler/SongItem.dart';
import 'package:Ezgiler/about.dart';
import 'package:Ezgiler/app_state.dart';
import 'package:Ezgiler/chords.dart';
import 'package:Ezgiler/settings.dart';
import 'package:Ezgiler/songs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:Ezgiler/lyrics.dart';
import 'package:Ezgiler/web_utils.dart';
import 'package:app_links/app_links.dart';

int scrollDuration = 60;
int metronomeBpm = 120;
double lyricsFontSize = 18;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure URL strategy for web
  if (kIsWeb) {
    setPathUrlStrategy();
  }
  
  // Initialize deep linking
  if (!kIsWeb) {
    try {
      final appLinks = AppLinks();
      
      // Get the initial link
      final uri = await appLinks.getInitialAppLink();
      if (uri != null) {
        debugPrint('Initial URI: $uri');
      }
      
      // Handle subsequent links
      appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          debugPrint('URI received: $uri');
        }
      });
    } catch (e) {
      debugPrint('Failed to handle deep link: $e');
    }
  }
  
  await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final appState = AppState();
  await appState.loadColor();
  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const MyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    if (state.matchedLocation.startsWith('/song/')) {
      final songId = state.pathParameters['id'];
      if (songId == null || songId.isEmpty) {
        return '/';
      }
      final songNumber = int.tryParse(songId.replaceAll(RegExp(r'[^0-9]'), ''));
      if (songNumber == null || songNumber < 1 || songNumber > 25) {
        return '/';
      }
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        updateWebTitle('Ana Sayfa - Ezgiler ve Marşlar');
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/album/:id',
      name: 'album',
      builder: (context, state) {
        final albumId = state.pathParameters['id'];
        if (albumId == null || (albumId != 'album1' && albumId != 'album2')) {
          updateWebTitle('Albüm Bulunamadı - Ezgiler ve Marşlar');
          updateMetaTags(
            title: 'Albüm Bulunamadı - Ezgiler ve Marşlar',
            description: 'Aradığınız albüm bulunamadı.',
          );
          return const Scaffold(
            body: Center(
              child: Text('Album not found'),
            ),
          );
        }
        final albumTitle = albumId == 'album1' ? 'Haykır' : 'Arşiv';
        final description = albumId == 'album1' 
          ? 'Grup İslami Direniş\'in Haykır albümündeki ezgi ve marşlar. Şarkı sözleri ve akorlar ile birlikte dinleyin.'
          : 'Grup İslami Direniş\'in Arşiv albümündeki ezgi ve marşlar. Şarkı sözleri ve akorlar ile birlikte dinleyin.';
        updateWebTitle('$albumTitle - Ezgiler ve Marşlar');
        updateMetaTags(
          title: '$albumTitle - Ezgiler ve Marşlar',
          description: description,
          imageUrl: albumId == 'album1' ? 'assets/haykir.jpeg' : 'assets/archive.jpg',
        );
        return SongsScreen(albumId: albumId);
      },
    ),
    GoRoute(
      path: '/song/:id',
      name: 'song',
      builder: (context, state) {
        final songId = state.pathParameters['id'];
        if (songId == null || songId.isEmpty) {
          updateWebTitle('Şarkı Bulunamadı - Ezgiler ve Marşlar');
          updateMetaTags(
            title: 'Şarkı Bulunamadı - Ezgiler ve Marşlar',
            description: 'Aradığınız şarkı bulunamadı.',
          );
          return const Scaffold(
            body: Center(
              child: Text('Song not found'),
            ),
          );
        }
        final songNumber = int.tryParse(songId.replaceAll(RegExp(r'[^0-9]'), ''));
        if (songNumber == null || songNumber < 1 || songNumber > 25) {
          updateWebTitle('Geçersiz Şarkı - Ezgiler ve Marşlar');
          updateMetaTags(
            title: 'Geçersiz Şarkı - Ezgiler ve Marşlar',
            description: 'Geçersiz şarkı numarası.',
          );
          return const Scaffold(
            body: Center(
              child: Text('Invalid song ID'),
            ),
          );
        }
        updateWebTitle('$songId - Ezgiler ve Marşlar');
        updateMetaTags(
          title: '$songId - Ezgiler ve Marşlar',
          description: 'Grup İslami Direniş\'in $songId isimli ezgisini dinleyin. Şarkı sözleri ve akorlar ile birlikte.',
          imageUrl: songNumber <= 10 ? 'assets/haykir.jpeg' : 'assets/archive.jpg',
        );
        return LyricsScreen(songId: songId);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) {
        updateWebTitle('Ayarlar - Ezgiler ve Marşlar');
        return const SettingsScreen();
      },
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) {
        updateWebTitle('Hakkında - Ezgiler ve Marşlar');
        return const AboutScreen();
      },
    ),
    GoRoute(
      path: '/chords',
      name: 'chords',
      builder: (context, state) {
        updateWebTitle('Akorlar - Ezgiler ve Marşlar');
        final chordsList = state.extra as List<String>? ?? [];
        return ChordsScreen(chords: chordsList);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        'Sayfa bulunamadı: ${state.error}',
        style: const TextStyle(fontSize: 18),
      ),
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final String location = _router.routerDelegate.currentConfiguration.uri.path;
        if (location == '/') {
          return true; // Allow app to close only on home screen
        }
        _router.go('/');
        return false; // Prevent app from closing on other screens
      },
      child: MaterialApp.router(
        routerConfig: _router,
        theme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        title: 'Ezgiler ve Marşlar - Grup İslami Direniş',
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
          'assets/logo.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          height: 240.0,
          width: 240.0,
        ),
      ),
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
      id: "album1",
      title: "Haykır · Grup İslami Direniş",
      cover: 'assets/haykir.jpeg',
    ),
    const Song(
      id: "album2",
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
                  final songTitle = snapshot.data![index];
                  final isHaykir =
                      (songList[songTitle] ?? "").contains("haykir");
                  return SongItem(
                    id: isHaykir ? 'song_${index + 1}' : 'archive_${index + 1}',
                    title: songTitle,
                    keyNote: "",
                    albumCover: songList[songTitle] ?? "",
                    albumTitle:
                        isHaykir ? "Haykır · Grup İslami Direniş" : "Arşiv",
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
          context.go('/album/album1');
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
          context.go('/album/album2');
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // Allow app to close on home screen
      },
      child: const Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(),
        body: BlurredBackground(),
      ),
    );
  }
}
