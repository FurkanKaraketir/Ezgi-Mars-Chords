import 'dart:async';
import 'package:Ezgiler/chords.dart';
import 'package:Ezgiler/main.dart';
import 'package:Ezgiler/settings.dart';
import 'chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'shared.dart';

final ScrollController _scrollController = ScrollController();

var chords = <String>[];

const List<String> CHORD_SEQUENCE = [
  'A',
  'A#',
  'B',
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#'
];

String shiftChord(String chord, int semitones) {
  // Handle minor chords
  bool isMinor = chord.contains('m') && !chord.contains('maj');
  String baseChord = isMinor ? chord.replaceAll('m', '') : chord;

  // Find the root note
  String root =
      baseChord.split('').take(baseChord.contains('#') ? 2 : 1).join();
  String remainder = baseChord.substring(root.length);

  // Find the new root note
  int currentIndex = CHORD_SEQUENCE.indexOf(root);
  if (currentIndex == -1) return chord; // Return original if chord not found

  int newIndex = (currentIndex + semitones) % 12;
  if (newIndex < 0) newIndex += 12;

  // Reconstruct the chord
  return CHORD_SEQUENCE[newIndex] + (isMinor ? 'm' : '') + remainder;
}

class LyricsScreen extends StatelessWidget {
  // This widget is a new screen for the lyrics of a song.
  final String title;

  const LyricsScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBarForLyrics(myTitle: title),
      body: BlurredBackgroundForLyrics(myTitle: title),
    );
  }
}

class MyAppBarForLyrics extends StatefulWidget implements PreferredSizeWidget {
  final String myTitle;

  const MyAppBarForLyrics({Key? key, required this.myTitle}) : super(key: key);

  @override
  _MyAppBarForLyricsState createState() => _MyAppBarForLyricsState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarForLyricsState extends State<MyAppBarForLyrics> {
  bool _isMetronomePlaying = false;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Do something periodically
    });
  }

  void _startStopMetronome() {
    setState(
      () {
        _isPlaying = !_isPlaying;
      },
    );

    if (_isPlaying) {
      _timer = Timer.periodic(
        Duration(milliseconds: (60000 / metronomeBpm).round()),
        (timer) async {
          await _audioPlayer.setAsset("assets/metronome_sound.mp3");
          _audioPlayer.play();
        },
      );
    } else {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/chords_icon.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: 24.0,
            width: 24.0,
          ),
          onPressed: () {
            // Open a new screen to show the chords
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChordsScreen(chords: chords),
              ),
            );
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            'assets/metronome.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            height: 30.0,
            width: 30.0,
          ),
          onPressed: () {
            setState(
              () {
                _isMetronomePlaying = !_isMetronomePlaying;
                // Call your metronome start/stop logic here
                if (_isMetronomePlaying) {
                  _startStopMetronome();
                } else {
                  _startStopMetronome();
                }
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            // Open a new screen to show the settings
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
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
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

class BlurredBackgroundForLyrics extends StatefulWidget {
  final String myTitle; // Declare the variable in the SecondScreen class

  // Constructor to receive the variable from the calling class (MyApp in this case)
  const BlurredBackgroundForLyrics({super.key, required this.myTitle});

  @override
  State<BlurredBackgroundForLyrics> createState() =>
      _BlurredBackgroundForLyricsState();
}

class _BlurredBackgroundForLyricsState
    extends State<BlurredBackgroundForLyrics> {
  final List<String> albumCovers = [
    'assets/haykir.jpeg',
    "assets/archive.jpg",
    // Add more album covers as needed
  ];

  final songYoutubeLinks = {
    "Dağlardayız Biz Ovalarda":
        "https://music.youtube.com/watch?v=vQowm9aCcvM&si=E_dcj0FQvAue6Iai",
    "Ahzab'daki Yiğitler":
        "https://music.youtube.com/watch?v=7WkDq_SKQr0&si=bB2JstB9Iqo6Cceo",
    "Savur İnancsız Külleri":
        "https://music.youtube.com/watch?v=tReX4y-fEkw&si=Ka5nHyWp2fUMwl0V",
    "Kaçış":
        "https://music.youtube.com/watch?v=pvtmgvmDUD4&si=H7qjOwaVWEoa8Asb",
    "Haykır":
        "https://music.youtube.com/watch?v=3o9QlWI0PXQ&si=c6B7_GRRuol0_d7o",
    "Çocuğum":
        "https://music.youtube.com/watch?v=5luvCbuHuXw&si=sLEQ1n4wmoJ1OCO-",
    "Büyük Şeytana Ölüm":
        "https://music.youtube.com/watch?v=kgV9dmAkFfs&si=ZEYiY3Ay8qMjuZc8",
    "Ninni":
        "https://music.youtube.com/watch?v=2jzmQgC7e8k&si=J2GpNsMLOVScOoNL",
    "Müstezafin":
        "https://music.youtube.com/watch?v=ZNLCu6tVpMo&si=VVZZhYxTaPbu4XqP",
    "Bağlanmaz ki Yüreğim":
        "https://music.youtube.com/watch?v=GMuuwEIKAko&si=rORCCwC7JhnmePVk",
    "Şehadet Bir Tutku":
        "https://music.youtube.com/watch?v=FAE7bpBwsjA&si=RcHfMDUofv4WtrXo",
    "Yolunda İslamın":
        "https://music.youtube.com/watch?v=uFm7vAxiK7Y&si=vCX5aT2nkz_Ja6zA",
    "Adı Bilinmez Müslüman":
        "https://music.youtube.com/watch?v=68454zJBR8g&si=6hpZudxbJggQ7bSH",
    "Suskunluğun Bedeli":
        "https://music.youtube.com/watch?v=wB67Tpr2Owc&si=J_Ri7ZIcubwoxZZN",
    "Bak Ülkeme":
        "https://music.youtube.com/watch?v=cD-XZgGSdg4&si=EqrCoUN2YT-mNHFb",
    "Şehitler Ölmez":
        "https://music.youtube.com/watch?v=h9EPKGXV7WQ&si=wzFJAsuKSF7yBv3u",
    "Şehit Tahtında":
        "https://music.youtube.com/watch?v=K-Rr5N_oRvo&si=HHq6n9ATFQi31ZXB",
    "Ayrılık Türküsü":
        "https://music.youtube.com/watch?v=GPaVMLtHfJg&si=U6DMdqXecWPMS06s",
    "Özgürlük Türküleri":
        "https://music.youtube.com/watch?v=Wjk0yWFixRc&si=_wRk2DRmRTZhMj86",
    "Andola":
        "https://music.youtube.com/watch?v=UTo83NLjbtA&si=y1UqFcq3sYachw-c",
    "Ey Şehid":
        "https://music.youtube.com/watch?v=MhYkwLTmcQk&si=WfkGcoN1iosOxeCR",
    "Mescid-i Aksa":
        "https://music.youtube.com/watch?v=DjMmJvcy_qo&si=rWw-5TqJShWqjZjH",
    "Kardan Aydınlık":
        "https://music.youtube.com/watch?v=PkNikj0mBkA&si=ZpFiM4E3hAc32fvI",
    "Şehadet Uykusu":
        "https://music.youtube.com/watch?v=M-E5qQJDhzs&si=aM7Czljuc1SAplmg",
    "Bilal":
        "https://music.youtube.com/watch?v=vTagGK2DFvY&si=cV0UKrrbDf926cSz",
  };

  List<Widget> widgets = [];
  List<Widget> widgets2 = [];

  var scrollDuration = 60;

  int currentTranspose = 0;

  Future<void> _startAutoSlowScroll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    scrollDuration = prefs.getInt('scrollDuration') ?? 60;

    // Adjust the values as needed
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: scrollDuration),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        buildLyricsWidget(widget.myTitle, context),
        Positioned(
          right: 15,
          bottom: 15,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF364259),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
              onPressed: () {
                _startAutoSlowScroll();
              },
            ),
          ),
        ),
        Positioned(
          right: 15,
          bottom: 80,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF364259),
            ),
            //open the youtube link of the song
            child: GestureDetector(
              onTap: () {
                launchUri(Uri.parse(songYoutubeLinks[widget.myTitle]!));
              },
              child: Image.asset(
                'assets/music_icon.png',
                width: 45,
                height: 45,
              ),
            ),
          ),
        ),
        Positioned(
          right: 75,
          bottom: 15,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF364259),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.zoom_in,
                color: Colors.white,
              ),
              onPressed: () {
                setState(
                  () {
                    if (lyricsFontSize < 50) {
                      lyricsFontSize += 2;
                    } else {
                      lyricsFontSize = 50;
                    }
                    widgets.clear();
                    widgets2.clear();
                  },
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 75,
          bottom: 80,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF364259),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.zoom_out,
                color: Colors.white,
              ),
              onPressed: () {
                setState(
                  () {
                    if (lyricsFontSize > 8) {
                      lyricsFontSize -= 2;
                    } else {
                      lyricsFontSize = 8;
                    }
                    widgets.clear();
                    widgets2.clear();
                  },
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 15,
          bottom: 15,
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF364259),
                ),
                child: IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      currentTranspose--;
                      widgets.clear(); // Force rebuild of lyrics
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${currentTranspose > 0 ? '+' : ''}$currentTranspose',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF364259),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      currentTranspose++;
                      widgets.clear(); // Force rebuild of lyrics
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_image_song.png'),
          // Replace with your image asset path
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildLyricsLine(String line, BuildContext context) {
    RegExp regExp = RegExp(r'\[([^\]]*)\]');
    List<Widget> chordWidgets = [];
    String lyricsText = line.replaceAll(regExp, '');
    double currentPosition = 0;

    for (Match match in regExp.allMatches(line)) {
      String originalChord = match.group(1) ?? '';
      String shiftedChord = shiftChord(originalChord, currentTranspose);

      if (!chords.contains(shiftedChord)) {
        chords.add(shiftedChord);
      }

      // Calculate position based on text before the chord
      String textBefore = line.substring(0, match.start).replaceAll(regExp, '');
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: textBefore,
          style: TextStyle(fontSize: lyricsFontSize),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      chordWidgets.add(
        Positioned(
          left: textPainter.width,
          child: GestureDetector(
            onTap: () {
              _showChordImageDialog(shiftedChord, context);
            },
            child: Text(
              shiftedChord,
              style: TextStyle(
                fontSize: lyricsFontSize * 0.8,
                fontWeight: FontWeight.bold,
                color: selectedColor,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: lyricsFontSize * 0.8 + 4), // Space for chords
                Text(
                  lyricsText,
                  style: TextStyle(
                    fontSize: lyricsFontSize,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ...chordWidgets,
          ],
        ),
      ),
    );
  }

  Widget buildLyricsWidget(String songName, BuildContext context) {
    final songLyrics = DictionaryHolder.sharedDictionary;
    var lyrics = songLyrics[songName]!;
    List<String> lines = lyrics.split('\n');

    chords.clear();

    List<Widget> widgets = [
      Container(
        margin: const EdgeInsets.all(20.0),
        child: Text(
          songName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: lyricsFontSize + 4,
            color: Colors.white,
          ),
        ),
      ),
    ];

    for (String line in lines) {
      if (line.contains('{start_of_chorus}')) {
        widgets.add(
          Center(
            child: Text(
              'Nakarat Başlangıcı:',
              style: TextStyle(fontSize: lyricsFontSize, color: selectedColor),
            ),
          ),
        );
      } else if (line.contains('{end_of_chorus}')) {
        widgets.add(
          Center(
            child: Text(
              'Nakarat Bitişi.',
              style: TextStyle(fontSize: lyricsFontSize, color: selectedColor),
            ),
          ),
        );
      } else if (line.contains('{Kapo 4}')) {
        widgets.add(
          Center(
            child: Text(
              'Kapo: 4',
              style: TextStyle(fontSize: lyricsFontSize, color: selectedColor),
            ),
          ),
        );
      } else if (line.contains('{Kapo 2}')) {
        widgets.add(
          Center(
            child: Text(
              'Kapo: 2',
              style: TextStyle(fontSize: lyricsFontSize, color: selectedColor),
            ),
          ),
        );
      } else {
        widgets.add(Center(child: buildLyricsLine(line, context)));
      }
    }

    return Positioned(
      top: 90,
      left: 0,
      right: 0,
      bottom: 0,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  Future<void> launchUri(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

void _showChordImageDialog(String chord, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1C273D),
        title: Text(
          chord,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 200,
          height: 250,
          child: CustomPaint(
            painter: ChordDiagram(chord),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Kapat',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
