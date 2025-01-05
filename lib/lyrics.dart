import 'dart:async';
import 'package:Ezgiler/app_state.dart';
import 'package:Ezgiler/main.dart';
import 'chord_diagram.dart' as diagram;
import 'chord_theory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'shared.dart';
import 'package:go_router/go_router.dart';

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
  final String songId;

  const LyricsScreen({Key? key, required this.songId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract title and albumTitle from songId
    final albumTitle =
        songId.startsWith('song') ? "Haykır · Grup İslami Direniş" : "Arşiv";

    // Extract the number from the ID (either after 'song' or 'archive')
    final number = songId.replaceAll(RegExp(r'[^0-9]'), '');
    final songIndex = int.tryParse(number) ?? 1;

    // Get the song title based on the album and index
    final songLyrics = DictionaryHolder.sharedDictionary;
    final title = songLyrics.keys.elementAt(songIndex - 1);

    return WillPopScope(
      onWillPop: () async {
        final albumId = _getAlbumId(albumTitle);
        if (albumId.isNotEmpty) {
          context.go('/album/$albumId');
        } else {
          context.go('/');
        }
        return false;  // Always return false to prevent app from closing
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBarForLyrics(
          myTitle: title,
          albumTitle: albumTitle,
          songId: songId,
        ),
        body: BlurredBackgroundForLyrics(myTitle: title),
      ),
    );
  }

  String _getAlbumId(String albumTitle) {
    if (songId.startsWith('song')) {
      // Extract the number from songId
      int songNumber = int.parse(songId.replaceAll(RegExp(r'[^0-9]'), ''));
      // Songs 1-10 belong to album1 (Haykır)
      // Songs 11-25 belong to album2 (Arşiv)
      if (songNumber <= 10) {
        return 'album1';
      } else {
        return 'album2';
      }
    }
    return '';
  }
}

class MyAppBarForLyrics extends StatefulWidget implements PreferredSizeWidget {
  final String myTitle;
  final String albumTitle;
  final String songId;

  const MyAppBarForLyrics({
    Key? key,
    required this.myTitle,
    required this.albumTitle,
    required this.songId,
  }) : super(key: key);

  String _getAlbumId(String albumTitle) {
    if (songId.startsWith('song')) {
      // Extract the number from songId
      int songNumber = int.parse(songId.replaceAll(RegExp(r'[^0-9]'), ''));
      // Songs 1-10 belong to album1 (Haykır)
      // Songs 11-25 belong to album2 (Arşiv)
      if (songNumber <= 10) {
        return 'album1';
      } else {
        return 'album2';
      }
    }
    return '';
  }

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
    setState(() {
      _isPlaying = !_isPlaying;
    });

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
            context.push('/chords', extra: chords);
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
            setState(() {
              _isMetronomePlaying = !_isMetronomePlaying;
              if (_isMetronomePlaying) {
                _startStopMetronome();
              } else {
                _startStopMetronome();
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            context.push('/settings');
          },
        ),
      ],
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          final albumId = widget._getAlbumId(widget.albumTitle);
          context.go('/album/$albumId');
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
  int globalCapo = 0;

  @override
  void initState() {
    super.initState();
    // Initialize globalCapo with song's kapo value
    final songLyrics = DictionaryHolder.sharedDictionary;
    var lyrics = songLyrics[widget.myTitle]!;
    RegExp capoRegex = RegExp(r'\{Kapo (\d+)\}');
    Match? match = capoRegex.firstMatch(lyrics);
    if (match != null) {
      globalCapo = int.parse(match.group(1)!);
    }
  }

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
        // Background
        buildGradientOverlay(),

        // Lyrics content
        buildLyricsWidget(widget.myTitle, context),
        
        // Auto-scroll button
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
        
        // YouTube link button
        Positioned(
          right: 15,
          bottom: 80,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF364259),
            ),
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
        
        // Zoom in button
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
        
        // Zoom out button
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

        // Transpose controls
        Positioned(
          right: 15,
          bottom: 145,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ton',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      (currentTranspose >= 0 ? '+' : '') + currentTranspose.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
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
    double lastChordEndPosition = 0;

    for (Match match in regExp.allMatches(line)) {
      String originalChord = match.group(1) ?? '';
      // Split chord if it contains multiple options (separated by '/')
      List<String> chordOptions = originalChord.split('/');
      // Use only the first chord option for display
      String primaryChord = chordOptions[0].trim();

      // Apply transpose to the chord
      String displayChord = shiftChord(primaryChord, currentTranspose);

      // Store all chord options for the dialog
      List<String> allTransposedOptions = chordOptions.map((chord) {
        return shiftChord(chord.trim(), currentTranspose);
      }).toList();

      // Add all variations to the chords list for the chord diagram
      for (String chord in allTransposedOptions) {
        if (!chords.contains(chord)) {
          chords.add(chord);
        }
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

      // Calculate the width of the current chord
      TextPainter chordPainter = TextPainter(
        text: TextSpan(
          text: displayChord,
          style: TextStyle(fontSize: lyricsFontSize * 0.8),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // Ensure minimum spacing between chords
      double chordPosition = textPainter.width;
      if (chordPosition < lastChordEndPosition) {
        chordPosition = lastChordEndPosition + 10;
      }

      lastChordEndPosition = chordPosition + chordPainter.width;

      chordWidgets.add(
        Positioned(
          left: chordPosition,
          child: GestureDetector(
            onTap: () {
              // Pass all chord options to the dialog
              _showChordImageDialog(
                allTransposedOptions.join(' / '),
                context,
                globalCapo,
              );
            },
            child: Text(
              // Show primary chord with indication if there are alternatives
              allTransposedOptions.length > 1 ? '$displayChord*' : displayChord,
              style: TextStyle(
                fontSize: lyricsFontSize * 0.8,
                fontWeight: FontWeight.bold,
                color: context.watch<AppState>().selectedColor,
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

    // Extract kapo information if present
    int? kapoValue;
    RegExp capoRegex = RegExp(r'\{Kapo (\d+)\}');
    Match? match = capoRegex.firstMatch(lyrics);
    if (match != null) {
      kapoValue = int.parse(match.group(1)!);
    }

    List<Widget> widgets = [
      Container(
        margin: const EdgeInsets.all(20.0),
        child: Text(
          songName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: lyricsFontSize + 4,
            color: context.watch<AppState>().selectedColor,
          ),
        ),
      ),
      if (kapoValue != null)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Kapo: $kapoValue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: lyricsFontSize,
              color: context.watch<AppState>().selectedColor,
              fontWeight: FontWeight.bold,
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
              style: TextStyle(
                  fontSize: lyricsFontSize,
                  color: context.watch<AppState>().selectedColor),
            ),
          ),
        );
      } else if (line.contains('{end_of_chorus}')) {
        widgets.add(
          Center(
            child: Text(
              'Nakarat Bitişi.',
              style: TextStyle(
                  fontSize: lyricsFontSize,
                  color: context.watch<AppState>().selectedColor),
            ),
          ),
        );
      } else if (!line.contains('{Kapo')) {
        // Skip kapo marker lines
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

void _showChordImageDialog(String chord, BuildContext context, int globalCapo) {
  int selectedPosition = 0;
  int defaultCapo = 0;

  // Get capo position from lyrics if available
  final songLyrics = DictionaryHolder.sharedDictionary;
  for (var entry in songLyrics.entries) {
    if (entry.value.contains(chord)) {
      RegExp capoRegex = RegExp(r'\{Kapo (\d+)\}');
      Match? match = capoRegex.firstMatch(entry.value);
      if (match != null) {
        defaultCapo = int.parse(match.group(1)!);
        break;
      }
    }
  }

  // Use the song's kapo value
  int capoPosition = defaultCapo;
  List<List<int>> allPositions = ChordTheory.generateChordPositions(chord);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Create a ChordPosition from the current selected position
          diagram.ChordPosition currentPosition =
              diagram.ChordPosition.fromFrets(
            allPositions.isEmpty
                ? List.filled(6, -1)
                : allPositions[selectedPosition],
          );

          // Adjust for capo position
          if (capoPosition > 0) {
            List<int> adjustedFrets = currentPosition.frets.map((fret) {
              if (fret == -1 || fret == 0) return fret;
              return fret > capoPosition ? fret - capoPosition : fret;
            }).toList();
            currentPosition = diagram.ChordPosition.fromFrets(adjustedFrets);
          }

          // Get the actual chord when capo is applied
          String actualChord = capoPosition > 0 ? ChordTheory.getActualChord(chord, capoPosition) : chord;

          return AlertDialog(
            backgroundColor: const Color(0xFF1C273D),
            title: Column(
              children: [
                Text(
                  // Show the chord as written in the song
                  chord,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (capoPosition > 0)
                  Text(
                    // Show what chord it actually produces
                    'Kapo ${capoPosition} ile: $actualChord',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 8),
                if (allPositions.length > 1) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: selectedPosition > 0
                            ? () {
                                setState(() {
                                  selectedPosition--;
                                });
                              }
                            : null,
                      ),
                      Text(
                        'Position ${selectedPosition + 1}/${allPositions.length}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                        onPressed: selectedPosition < allPositions.length - 1
                            ? () {
                                setState(() {
                                  selectedPosition++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Kapo: $capoPosition',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200,
                  height: 250,
                  child: CustomPaint(
                    painter: diagram.ChordDiagram(
                      chord,
                      capoPosition: capoPosition,
                      position: currentPosition,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Frets: ${currentPosition.frets.map((f) => f == -1 ? "x" : f.toString()).join(" ")}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => context.pop(),
                child: const Text(
                  'Kapat',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
