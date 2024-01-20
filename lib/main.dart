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
    return MaterialApp(
      debugShowCheckedModeBanner: false, // false
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const MyAppBar(),
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
  final List<String> albumCovers = [
    'assets/haykir.jpeg',
    // Add more album covers as needed
  ];

  BlurredBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 1: Background Image with Blur
        buildBlurredBackground(),

        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        albumList(),
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

  Widget albumList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: albumCovers.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            // Navigate to the SongsScreen when an album cover is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SongsScreen(albumCover: albumCovers[index]),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.0),
              child: Image.asset(
                albumCovers[index],
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
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

class BlurredBackgroundForSongs extends StatelessWidget {
  final List<String> songList = [
    'assets/haykir.jpeg',
    // Add more album covers as needed
  ];

  BlurredBackgroundForSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 1: Background Image with Blur
        buildBlurredBackground(),

        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        albumList(),
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

  Widget albumList() {
    return ListView(
      children: const [
        SongItem(
          title: 'Ahzab\'daki Yiğitler',
          keyNote: 'A',
        ),
        SongItem(
          title: 'Dağlardayız Biz Ovalarda',
          keyNote: 'G#/m',
        ),
        SongItem(
          title: 'Haykır',
          keyNote: 'D',
        ),
        SongItem(
          title: 'Bağlanmaz ki Yüreğim',
          keyNote: 'F#',
        ),
        SongItem(
          title: 'Savur İnancsız Külleri',
          keyNote: 'F#',
        ),
        SongItem(
          title: 'Kaçış',
          keyNote: 'A',
        ),
        SongItem(
          title: 'Çocuğum',
          keyNote: 'C#',
        ),
        SongItem(
          title: 'Büyük Şeytana Ölüm',
          keyNote: 'D',
        ),
        SongItem(
          title: 'Ninni',
          keyNote: 'F',
        ),
        SongItem(
          title: 'Müstezafin',
          keyNote: 'F#',
        ),
      ],
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

class SongsScreen extends StatelessWidget {
  final String albumCover;

  const SongsScreen({super.key, required this.albumCover});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: MySongsPage());
  }
}

class MySongListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MySongListAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Haykır',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
      ),
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

class MySongsPage extends StatelessWidget {
  const MySongsPage({super.key});

  // This widget is the home page of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MySongListAppBar(),
      extendBodyBehindAppBar: true,
      body: BlurredBackgroundForSongs(),
    );
  }
}

class SongItem extends StatelessWidget {
  // This widget is a custom list item for each song.
  final String title;
  final String keyNote;

  const SongItem({Key? key, required this.title, required this.keyNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LyricsScreen(
              title: title,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // You can adjust the radius as needed
              child: Image.asset(
                'assets/haykir.jpeg',
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              keyNote,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class LyricsScreen extends StatelessWidget {
  // This widget is a new screen for the lyrics of a song.
  final String title;

  const LyricsScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String myTitle = title;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBarForLyrics(myTitle: myTitle),
      body: BlurredBackgroundForLyrics(myTitle: myTitle),
    );
  }
}

class BlurredBackgroundForLyrics extends StatelessWidget {
  final List<String> albumCovers = [
    'assets/haykir.jpeg',
    // Add more album covers as needed
  ];

  final songLyrics = {
    'Dağlardayız Biz Ovalarda': '''
    [Em]Dağlardayız biz [C]ovalarda [Em]
    [Am]Makina başında [C]sıralarda [Em]
    [Am]Sürdürüyoruz kavgamızı
    [D]Zalimler boğulaya[Em]
       
    {start_of_chorus}
    [Em]Alev alan [G]Ateş söner mi hiç
    [Am]Özgürlük türküleri [Em]biter mi hiç
    [Am]Göğe savrulan [G]yumruklar
    [D]Zalim gitmedikçe [Em]iner mi hiç
    {end_of_chorus}
    
    [Em]Haydin çocuklar [G]gençler kadınlar
    [Am]Yükseltelim [Em]feryadımızı
    [Am]ALLAH sözünü [G]hakim kılmak için
    [D]Tağutları yıkalım[Em]
    
    {start_of_chorus}
    [Em]Alev alan [G]Ateş söner mi hiç
    [Am]Özgürlük türküleri [Em]biter mi hiç
    [Am]Göğe savrulan [G]yumruklar
    [D]Zalim gitmedikçe [Em]iner mi hiç
    {end_of_chorus}
    
  ''',
    'Haykır': 'Value_2',
  };

  final String myTitle; // Declare the variable in the SecondScreen class

  // Constructor to receive the variable from the calling class (MyApp in this case)
  BlurredBackgroundForLyrics({super.key, required this.myTitle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 1: Background Image with Blur
        buildBlurredBackground(),

        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        buildLyricsWidget(myTitle),
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

  Widget buildLyricsWidget(String songName) {
    var lyrics = songLyrics[songName]!;

    List<String> lines = lyrics.split('\n');
    List<Widget> widgets = [];

    for (String line in lines) {
      if (line.contains('{start_of_chorus}')) {
        widgets.add(const Text(
          'Nakarat Başlangıcı:',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ));
      } else if (line.contains('{end_of_chorus}')) {
        // Add any additional styling for the end of chorus
        widgets.add(const Text(
          'Nakarat Bitişi.',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ));
      } else {
        List<Widget> chordWidgets = [];
        RegExp regExp = RegExp(r'\[([^\]]*)\]');
        Iterable<RegExpMatch> matches = regExp.allMatches(line);

        int index = 0;
        for (RegExpMatch match in matches) {
          if (match.start > index) {
            chordWidgets.add(
              Text(
                line.substring(index, match.start),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }

          String? chordText = match.group(1);
          if (chordText != null) {
            chordWidgets.add(
              Baseline(
                baseline: 18.0, // Adjust the baseline value as needed
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  chordText,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
            );
          }

          index = match.end;
        }

        if (index < line.length) {
          chordWidgets.add(
            Text(
              line.substring(index),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          );
        }

        widgets.add(
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: chordWidgets,
              ),
              const SizedBox(height: 8),
              // Adjust spacing between chords and lyrics
            ],
          ),
        );
      }
    }

    return Positioned(
      top: 90,
      // Adjust this value based on your app bar height
      left: 0,
      right: 0,
      bottom: 0,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
  }
}

class MyAppBarForLyrics extends StatelessWidget implements PreferredSizeWidget {
  final String myTitle; // Declare the variable in the SecondScreen class

  // Constructor to receive the variable from the calling class (MyApp in this case)
  const MyAppBarForLyrics({super.key, required this.myTitle});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        myTitle,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/metronome.svg', // Replace with the path to your SVG file
            color: Colors.white,
            height: 24.0,
            width: 24.0,
          ),
          onPressed: () {
            // Handle search button press
          },
        ),
      ],
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
