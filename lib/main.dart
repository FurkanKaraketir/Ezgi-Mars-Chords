import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';
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

Color selectedColor = const Color(0xFFFFFFFF); // Default selected color
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

class SongsScreen extends StatefulWidget {
  String albumTitle;

  SongsScreen({super.key, required this.albumTitle});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MySongsPage(
      albumTitle: widget.albumTitle,
    ));
  }
}

class MySongsPage extends StatelessWidget {
  final String albumTitle;

  const MySongsPage({super.key, required this.albumTitle});

  // This widget is the home page of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MySongListAppBar(myTitle: albumTitle),
      extendBodyBehindAppBar: true,
      body: BlurredBackgroundForSongs(albumTitle: albumTitle),
    );
  }
}

class MySongListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String myTitle;

  const MySongListAppBar({super.key, required this.myTitle});

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

class BlurredBackgroundForSongs extends StatelessWidget {
  String albumTitle = "";

  BlurredBackgroundForSongs({super.key, required this.albumTitle});

  final List<String> songList = [
    'assets/haykir.jpeg',
    // Add more album covers as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        albumList(albumTitle),
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

  Widget albumList(albumTitle) {
    if (albumTitle == "Haykır · Grup İslami Direniş") {
      return ListView(
        children: const [
          SongItem(
            title: 'Ahzab\'daki Yiğitler',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
          ),
          SongItem(
            title: 'Dağlardayız Biz Ovalarda',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
          ),
          SongItem(
            title: 'Haykır',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
          ),
          SongItem(
            title: 'Bağlanmaz ki Yüreğim',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
          ),
          SongItem(
            title: 'Savur İnancsız Külleri',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
          ),
          SongItem(
            title: 'Kaçış',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
          ),
          SongItem(
            title: 'Çocuğum',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
          ),
          SongItem(
            title: 'Büyük Şeytana Ölüm',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
          ),
          SongItem(
            title: 'Ninni',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
          ),
          SongItem(
            title: 'Müstezafin',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
          ),
        ],
      );
    } else {
      return ListView(
        children: const [
          SongItem(
            title: 'Şehadet Bir Tutku',
            keyNote: '',
            albumCover: 'assets/archive.jpg',
          ),
          SongItem(
            title: 'Yolunda İslamın',
            keyNote: '',
            albumCover: 'assets/archive.jpg',
          ),
          SongItem(
            title: 'Adı Bilinmez Müslüman',
            keyNote: '',
            albumCover: 'assets/archive.jpg',
          ),
          SongItem(
              title: "Suskunluğun Bedeli",
              keyNote: "",
              albumCover: "assets/archive.jpg"),
          SongItem(
            title: "Bak Ülkeme",
            keyNote: "",
            albumCover: "assets/archive.jpg",
          ),
          SongItem(
            title: "Şehitler Ölmez",
            keyNote: "",
            albumCover: "assets/archive.jpg",
          ),
          SongItem(
            title: "Şehit Tahtında",
            keyNote: "",
            albumCover: "assets/archive.jpg",
          ),
          SongItem(
            title: "Ayrılık Türküsü",
            keyNote: "",
            albumCover: "assets/archive.jpg",
          ),
          SongItem(
            title: "Özgürlük Türküleri",
            keyNote: "",
            albumCover: "assets/archive.jpg",
          ),
          SongItem(
              title: "Andola", keyNote: "", albumCover: "assets/archive.jpg"),
          SongItem(
              title: "Ey Şehid", keyNote: "", albumCover: "assets/archive.jpg"),
          SongItem(
              title: "Mescid-i Aksa",
              keyNote: "",
              albumCover: "assets/archive.jpg"),
          SongItem(
              title: "Kardan Aydınlık",
              keyNote: "",
              albumCover: "assets/archive.jpg"),
          SongItem(
              title: "Şehadet Uykusu",
              keyNote: "",
              albumCover: "assets/archive.jpg"),
          SongItem(
              title: "Bilal", keyNote: "", albumCover: "assets/archive.jpg"),
        ],
      );
    }
  }
}

class SongItem extends StatelessWidget {
  // This widget is a custom list item for each song.
  final String title;
  final String keyNote;
  final String albumCover;

  const SongItem(
      {Key? key,
      required this.title,
      required this.keyNote,
      required this.albumCover})
      : super(key: key);

  Future<void> _addToLastPlayedSongs(String song) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? lastPlayedSongs = prefs.getStringList('items') ?? [];

      if (!lastPlayedSongs.contains(song)) {
        lastPlayedSongs.insert(0, song);
      } else {
        lastPlayedSongs.remove(song);
        lastPlayedSongs.insert(0, song);
      }
      //max 10 songs
      if (lastPlayedSongs.length > 7) {
        lastPlayedSongs.removeLast();
      }

      Future<void> loadSelectedColor() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        selectedColor = Color(prefs.getInt('selectedColor') ?? 0xFFFFFFFF);
      }

      Future<void> loadMetronomeBpm() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        metronomeBpm = prefs.getInt('metronomeBpm') ?? 120;
      }

      loadMetronomeBpm();
      loadSelectedColor();
      // Optionally, you can limit the size of the list, e.g., keep only the last N songs
      // const int maxSongs = 10;
      // lastPlayedSongs = lastPlayedSongs.take(maxSongs).toList();

      await prefs.setStringList('items', lastPlayedSongs);
    } catch (e) {
      // Handle any potential exceptions, e.g., if SharedPreferences fails
    }
  }

  void addToLastPlayedSongs(String song) async {
    await _addToLastPlayedSongs(song);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _addToLastPlayedSongs(title);
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
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // You can adjust the radius as needed
              child: Image.asset(
                albumCover,
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

final ScrollController _scrollController = ScrollController();

var chords = <String>[];

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
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer.cancel();
    super.dispose();
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
    'Haykır': '''
    [Em]Ay ışığı[Am] [D]şahit [C]yalnızlığıma
    [Em]Kim tutacak[Am] [D]mahrum [C]ellerimden
    [Em]Kan kusuyor[Am] [D]burası benim [C]coğrafyam
    [Em]Umudumu[Am] [D]bağladım [C]ufuklara
    
    [Em]Hadi haykır [G]hiç korkma [D]Allah hep [C]yanında
    [Em]Hadi diren [G]zalime [D]Allah hep [C]seninle
    [Em]Vur zillete [G]kır zulmü [D]küffar [C]zincirleri
    [Em]Hadi kuşan [G]davayı [D]onurlu [C]sevdayı
    
    [Em]Uyan diren [G]özgürleş[D] [C]
    [Em]Diren yılma [G]sen kardeş[D] [C]
    [Em]Balçıkla sıvanmaz [G]güneş[D] [C]
    
    [G]Uyan diren özgürleş[Bm] ki
    [G]Yırtılıp çıksın bağrından[D] karanlığın tüm şafaklar[Em]
    
    Yeryüzünü zulüm örter kıyar tüm canlara
    Sömürür zalim efendiler, umut biter yarına, 
    Susar hain işbirlikçi, sözde kınar birileri
    Sen de susup haykırmazsan, kim haykırır gerçekleri
    
    Gidenler Hüseyin kalanlar Zeynep olur
    Sen haykır hiç düşünme ateşler gülistan olur
    Denizler yol olur, zindanlar mektep olur
    Hira’dan bir kıvılcım çağlara güneş olur
     
    Bu kıvılcım sadra düşer, gönüllerde umut pişer
    Alnı secdede yükseldi insan oldu beşer
    Bağrında bir yangın bir bismillah haykır
    Bir yumruk, bir kurşun, bir slogan haykır
     
    [Em]Gün ışığı[Am] [D]şahid özgürlüğüme[C]
    [Em]Kim duracak[Am] [D]şimdi [C]karşımda?
    [Em]Destan yazıyor[Am] [D]burası benim [C]coğrafyam
    [Em]Kıyam düşer[Am] [D]mahzun diyarlara[C]
    
    [Em]Hadi haykır [G]hiç korkma [D]Allah hep [C]yanında
    [Em]Hadi diren [G]zalime [D]Allah hep [C]seninle
    [Em]Vur zillete [G]kır zulmü [D]küffar [C]zincirleri
    [Em]Hadi kuşan [G]davayı [D]onurlu [C]sevdayı
    
    [Em]Uyan diren [G]özgürleş[D] [C]
    [Em]Diren yılma [G]sen kardeş[D] [C]
    [Em]Balçıkla sıvanmaz [G]güneş[D] [C]
    
    [G]Uyan diren özgürleş[Bm] ki
    [G]Yırtılıp çıksın bağrından[D] karanlığın tüm şafaklar[Em]
    
    Güç, para, şan, şöhret putlar artık taştan değil
    Ebreheler şimdileri fil yerine tankla gelir
    Sanılır ki çoğunluklar her zaman galip gelir
    Ebabiller gibi hür çocuklar varken değil
    
    Sakın şaşma hakikat aslında biraz yalnızlıktır
    Vicdanları yutkunanların korkaklıkları azıktır
    Yazıktır, bedel zamanı sesleri hep kısıktır
    Ölüm gelip çatsa bile zillet bizden uzaktır
    
    Bir balta kuşan şimdi ilahi bir kelimeden
    Özgürlükle oku hadi yıkılsın bu hain düzen
    Umut ek sabır büyüt yılmak nedir bilmeden
    Suni zindanlar yıkılmaz Rabbim Allah demeden
    
    [G]Uyan Diren özgürleş[Bm] ki
    [G]karanlığın bağrından[D] çıkar bütün şafaklar[Em]
    
    
    
    ''',
    "Ahzab'daki Yiğitler": '''
    [Em]Bir seher vaktinde şafakla geleceğiz
    [F]Gün bugün ötesi yok, gün bugün durmak [Em]yok 
    
    [Em]Bir seher vaktinde şafakla geleceğiz
    [F]Gün bugün ötesi yok, gün bugün durmak [Em]yok 
    
    {start_of_chorus}
    [Am]Rabbin müjdesi [Fmaj7]bizleri bekler [G]zalim yüreği [Em]korkudan titrer
    [Fmaj7]Susmazsa eğer [Dm7]söz veren erler [G]Ahzab′daki[F] yiğitler[Em]
    [Am]Rabbin müjdesi [Fmaj7]bizleri bekler [G]zalim yüreği [Em]korkudan titrer
    [Fmaj7]Susmazsa eğer [Dm7]söz veren erler [G]Ahzab′daki[F] yiğitler[Em]
    {end_of_chorus}
    
    [Em]Bir seher vaktinde zaferle geleceğiz
    [F]Müjde bu dönmek yok, yatakta ölmek [Em]yok
    [Em]Bir seher vaktinde zaferle geleceğiz
    [F]Müjde bu dönmek yok, yatakta ölmek [Em]yok
    
    {start_of_chorus}
    [Am]Rabbin müjdesi [Fmaj7]bizleri bekler [G]zalim yüreği [Em]korkudan titrer
    [Fmaj7]Susmazsa eğer [Dm7]söz veren erler [G]Ahzab′daki[F] yiğitler[Em]
    [Am]Rabbin müjdesi [Fmaj7]bizleri bekler [G]zalim yüreği [Em]korkudan titrer
    [Fmaj7]Susmazsa eğer [Dm7]söz veren erler [G]Ahzab′daki[F] yiğitler[Em]
    {end_of_chorus}
    
    [Em]Bir seher vaktinde ölümle geleceğiz
    [F]Od olup sönmek yok şehitsiz dönmek [Em]yok
    [Em]Bir seher vaktinde ölümle geleceğiz
    [F]Od olup sönmek yok şehitsiz dönmek [Em]yok
    
    {start_of_chorus}
    [Am]Rabbin müjdesi [Fmaj7]bizleri bekler [G]zalim yüreği [Em]korkudan titrer
    [Fmaj7]Susmazsa eğer [Dm7]söz veren erler [G]Ahzab′daki[F] yiğitler[Em]
    [Am]Rabbin müjdesi [Fmaj7]bizleri bekler [G]zalim yüreği [Em]korkudan titrer
    [Fmaj7]Susmazsa eğer [Dm7]söz veren erler [G]Ahzab′daki[F] yiğitler[Em]
    {end_of_chorus}
    
    ''',
    "Bağlanmaz ki Yüreğim": '''
    
    [Am]Kurtuluşum [Bdim]İslam’dadır 
    [Dm]Kurtuluşum [Fmaj7]Lâ ilahe
    [Am]Amacımız [Bdim]illallah’tır 
    [Dm]Tağutlardan [Fmaj7]kurtulmaktır
    [Am]Amacımız [Bdim]illallah’tır 
    [Dm]Tağutlardan [Fmaj7]kurtulmaktır

    {start_of_chorus}
    [Am]Bağlansa [F]elim ayağım 
    [Dm]Bağlanmaz [F]ki yüreğim[Am]
    [Am]Alev olur [F]rüzgar olur  
    [Dm]Savurur zulmü[F] yüreğim[Am]
    [Am]Feryat olur [F]yumruk olur  
    [Dm]Dağıtır zulmü[F] yüreğim[Am]
    {end_of_chorus}
    
    [Am]Savaşımız [Bdim]inançladır 
    [Dm]Coğrafya [Fmaj7]bilmez
    [Am]Fitne kalkmadan [Bdim]bu savaş 
    [Dm]İnan ki [Fmaj7]bitmez
    [Am]Fitne kalkmadan [Bdim]bu savaş 
    [Dm]İnan ki [Fmaj7]bitmez
    
    {start_of_chorus}
    [Am]Bağlansa [F]elim ayağım 
    [Dm]Bağlanmaz [F]ki yüreğim[Am]
    [Am]Alev olur [F]rüzgar olur  
    [Dm]Savurur zulmü[F] yüreğim[Am]
    [Am]Feryat olur [F]yumruk olur  
    [Dm]Dağıtır zulmü[F] yüreğim[Am]
    {end_of_chorus}
    
    [Am]İşkencelerden [Bdim]geçtik 
    [Dm]Sürgünler [Fmaj7]yedik
    [Am]Kan aktı [Bdim]bedenlerden 
    [Dm]Kurbanlar [Fmaj7]verdik 
    
    {start_of_chorus}
    [Am]Bağlansa [F]elim ayağım 
    [Dm]Bağlanmaz [F]ki yüreğim[Am]
    [Am]Alev olur [F]rüzgar olur  
    [Dm]Savurur zulmü[F] yüreğim[Am]
    [Am]Feryat olur [F]yumruk olur  
    [Dm]Dağıtır zulmü[F] yüreğim[Am]
    {end_of_chorus}
    ''',
    "Savur İnancsız Külleri": '''
    [Em]Savur inançsız külleri [D]avuçlarından[Em]
    [Em]O küller ki savruldu [D]put meydanından[Em]
    [Am]İbrahim [Em]mirasından [F#dim]sana kalanla[G]
    [Am]Put kıran [Em]ellerini [D]kuşan Müslüman[Em]
    [Am]İbrahim [Em]mirasından [F#dim]sana kalanla[G]
    [Am]Put kıran [Em]ellerini [D]kuşan Müslüman[Em]
    
    [Em]Direniş [Am]ibadetim
    [F#dim]Onurum [C]şehadetim
    [Em]Ne gam bilir [Am]yüreğim
    [F#dim]Korku tatmış [Em]değilim
    
    [Em]Rabbim Allah’tır[C] benim
    [D]Adım Müslüman[Em] benim
    [Em]Rabbim Allah’tır[C] benim
    [D]Adım Müslüman[Em] benim
    
    [Em]Omzunda tevhidin [D]ihtişamı [Em]var
    [Em]Zillet görmemiş alnında [D]secde izi [Em]var
    [Am]Korkutur [Em]zalimi [F#dim]dik duruşun [G]hey
    [Am]Her mazlumu [Em]saracak [D]merhametin [Em]var
    [Am]Korkutur [Em]zalimi [F#dim]dik duruşun [G]hey
    [Am]Her mazlumu [Em]saracak [D]merhametin [Em]var
    
    [Em]Direniş [Am]ibadetim
    [F#dim]Onurum [C]şehadetim
    [Em]Ne gam bilir [Am]yüreğim
    [F#dim]Korku tatmış [Em]değilim
    
    [Em]Rabbim Allah’tır[C] benim
    [D]Adım Müslüman[Em] benim
    [Em]Rabbim Allah’tır[C] benim
    [D]Adım Müslüman[Em] benim
    
    
    ''',
    "Kaçış": '''
    [Em]Dün gece [C]yürüdüm [D]yeryüzü denen [Em]handa
    [Em]Kıyamete [C]boyanmış [D]kabuslar [Em]sokaklarda
    [Em]Adalet [C]dağıtılmış [D]merhametsiz [Em]silahlarla
    [Em]Burada hep [C]suçlu doğmuş [D]güneş yüzlü [Em]çocuklar
    
    [C]Çürümüş [D]başaklardan
    [C]Kurumuş [D]pınarlardan
    [C]Çalınmış [D]emeklerden
    Parçalanmış canlardan
    [Bm7]Utandım biçare kaldım
    
    {start_of_chorus}
    [C]İçimde döndü[D] dünya
    Aradım[Am] karış[Em] karış
    Haykırdı [D]Meryem’ce
    Bir [Am]sükûtla[Em]
    [Em]Yok mu bir [D]kaçış
    Sonra[Am]
    Bir [Em]sığınış
    [C]Rahmetince [D]sakin
    Bir [Em]yere
    [Bm7]Kainattan
    Boşalmış[Em]
    {end_of_chorus}
    
    [Em]Sanki [C]dağlar yıkılırmış [D]içimdeki [Em]bu sancıdan
    [Em]Göğsüm [C]sıkışıp daralmış [D]türlü bela [Em]acılardan
    [Em]Bir felah ver [C]katından [D]sadrıma ver bir [Em]genişlik
    [Em]Bir devrim [C]müjdesi bana [D]bir haber [Em]gönder
    
    [C]İbrahim [D]gülistanından
    [C]Yusuf’un [D]Kenan’ından
    [C]İsa [D]kundağından
    Tur-i Sina Musa’sından
    [Bm7]Hira’dan bir
    Nefes aldım[Em]
    
    {start_of_chorus}
    [C]İçimde döndü[D] dünya
    Aradım[Am] karış[Em] karış
    Haykırdı [D]Meryem’ce
    Bir [Am]sükûtla[Em]
    [Em]Yok mu bir [D]kaçış
    Sonra[Am]
    Bir [Em]sığınış
    [C]Rahmetince [D]sakin
    Bir [Em]yere
    [Bm7]Kainattan
    Boşalmış[Em]
    {end_of_chorus}
    ''',
    "Çocuğum": '''
    [Am]Vakit akşamüstü [F]çok bekleme[E]
    [Am]Zaman çok daraldı [F]koş evine[E]
    [E]Haydi akşamın vakti girmeden [F]yine
    [Em]Bekletme babanı çocuğum[Am]
    
    {start_of_chorus}
    [Am]Küçük çocukları [E]küçük kurşunlar
    Sokakta annelerden [F]önce kucaklar
    Melekler cennette yerini[Am] hazırlar[E]
    Rabbini bekletme[F] [F] çocuğum[Am]
    {end_of_chorus}

    [Am]Karanlık çökmeden [F]bul evini[E]
    [Am]Bombalar bastırmadan [F]ezan sesini[E]
    [E]Uyu sen düşünme hiç gerisini[F]
    [E]Rüyalar öldürmez çocuğum[Am]
    ''',
    "Büyük Şeytana Ölüm": '''
    Kıyama duracak İslam ümmeti
    Himaye edecek öksüz, yetimi
    Zalimleri kovmaya yeminliyiz
    Büyük şeytana ölüm, Kahrol Amerika
    Kahrol Amerika katil Amerika
    Nifağın kaynağı şeytan Amerika
    Büyük şeytana ölüm, Kahrol Amerika
    Öfke çektim kınından biledim imanla
    Tek vücut, tek bilek ve tek feryatla
    Semaya yükselir Allah-u Ekber
    Büyük şeytana ölüm, Kahrol Amerika
    Kefeni giyip de çıkmışız biz yola
    Endişemiz yoktur asla yarına
    Kudüs’ünde taşken meydanda bir slogan
    Büyük şeytana ölüm, Kahrol Amerika
    ''',
    "Ninni": '''
    Susmayan çığlıklar duyuyorum
    Bir köşe başında babasını kaybetmiş çocuklardan
    Uyutmayan kabuslar görüyorum
    Yetim bebekleri mezar beşiklere yatırmış, 
    toprak örtüler sermiş analardan
    Ağıtlar yankılanıyor arzda
    Avuçları soğuk toprakta bir anne
    Şimdi bir ninni fısıldıyor kainata

    [Am9]Annesinin minik[Fmaj9]kuzusu
    [Em7]Yavrusunun sinmiş[Cmaj7]kokusu
    [Fmaj7]Gül rengi[G] gömleğine[Am9]
    
    [Am9]Eeeeeee [Fmaj7]eeeee bebeğim[Cmaj7]
    [Fmaj7]Yum [G]gözünü baban[Am9] bekler
    
    {start_of_chorus}
    [Am9]Vuruldun [Fmaj7]alnından
    [Em7]Onurlu [Am9]imanından
    [Fmaj7]İnsanlık vicdanından
    [Dm7]Eeeeeee eeeee bebeğim[Em7]
    [Fmaj7]Yum [G]gözünü baban[Am9] bekler
    {end_of_chorus}

    [Am9]Mis kokulu can[Fmaj7] parem benim
    [Em7]Yitip giden minik[Cmaj7] çiçeğim
    [Fmaj7]Sevinç bilmez[G] gözbebeğim[Am9]
    
    {start_of_chorus}
    [Am9]Vuruldun [Fmaj7]alnından
    [Em7]Onurlu [Am9]imanından
    [Fmaj7]İnsanlık vicdanından
    [Dm7]Eeeeeee eeeee bebeğim[Em7]
    [Fmaj7]Yum [G]gözünü baban[Am9] bekler
    {end_of_chorus}
    
    [Am9]Ve ölür insan [Fmaj7]bozulur mizan
    [G]Ölür insan…[Am]
    ''',
    "Müstezafin": '''
    Kaldır başını çocuğum sil göz yaşını bacım
    Savaşırım senin için yaralı kardeşim
    Savaşırım senin için müstezaf kardeşim
    Müstezafin müstezafin
    Emeği sömürülen, hakkı yenilen yaralı kardeşim
    Haber verin yiğitlere kuşansınlar şehadeti
    Kıyam günüdür, kıyam bugün zaferdir nihayeti
    Kıyam günüdür, kıyam bugün şehadet hediyesi
    ''',
    "Şehadet Bir Tutku": '''
    Yalnız bırakılsak savaş yolunda
    Olmasa yanımızda yol arkadaşı
    Karşımıza çıksa bütün bir dünya
    Dönmek yok sürdüreceğiz savaşı
    
    Şehadet bir tutku, bir özlem bize
    Ölüm bir son değil, diriliş bize
    
    Sarsılsa acıyla tüm bedenimiz
    Eğilmez başımız kullara karşı
    Her gün yeniden yemin ederiz
    Dönmek yok sürdüreceğiz savaşı
    
    Şehadet bir tutku, bir özlem bize
    Ölüm bir son değil, diriliş bize
    
    Sayı, silah, zaman hepsi bahane
    Tutamaz mı elim yerdeki taşı
    İman ve sabır olduğu müddetçe
    Dönmek yok sürdüreceğiz savaşı
    
    Şehadet bir tutku, bir özlem bize
    Ölüm bir son değil, diriliş bize
    Şehadet bir tutku, bir özlem bize
    Ölüm bir son değil, diriliş bize
    
    Şehadet bir tutku, bir özlem bize
    Ölüm bir son değil, diriliş bize
    ''',
    "Yolunda İslamın": '''
    Yolunda İslamın kardeşler olalım
    Acıyı paylaşıp sevgiyle dolalım
    Emperyalizmin sağ soluna karşı duralım
    Müstezafinin hakkı için haydi vuralım

    Allahu Ekber , Allahu Ekber
    Bir inkılaptır bu güneş gibi doğdu
    Hakikatin nuru karanlığı boğdu
    Allahu ekber bayrağımız dalgalanmakta
    Halka be halka halklar Hakta halkalanmakta
    Allahu Ekber , Allahu Ekber
    Allahu Ekber , Allahu Ekber
    Allahu Ekber , Allahu Ekber

    Allahu Ekber , Allahu Ekber
    Yıkıldı firavun Haman ile Karun
    Nemruda ne oldu çağdaşlara sorun
    Bu inkılap tağutların korkulu rüyası
    Bu inkılap mazlumların en haklı davası

    Allahu Ekber , Allahu Ekber
    Bir inkılaptır bu güneş gibi doğdu
    Hakikatin nuru karanlığı boğdu
    Allahu ekber bayrağımız dalgalanmakta
    Halka be halka halklar Hakta halkalanmakta
    Allahu Ekber , Allahu Ekber
    Allahu Ekber , Allahu Ekber
    Allahu Ekber , Allahu Ekber
    ''',
    "Adı Bilinmez Müslüman": '''
    Gece karanlığında bir yiğit çıkmış yola
    Elinde mavzeriyle alnı sanki yıldızlarda
    Adı bilinmez müslüman ver elini götür bizi
    Götür bizi uzaklara özgürlüğün diyarına

    Hak uğrunda geçen günler pekiştirmiş yüreğini
    Ekmek değil istediği izzetli bir yaşam diler
    Adı bilinmez müslüman ver elini götür bizi
    Götür bizi uzaklara özgürlüğün diyarına

    Ve duası kabul oldu bir kurşun onu buldu
    Ondan duyulan son ses Allahüekber oldu
    Adı bilinmez müslüman ver elini götür bizi
    Götür bizi uzaklara özgürlüğün diyarına
''',
    "Suskunluğun Bedeli": '''
    Suskunluğun bedeli çaresizliğin diyetidir Muhammed
    Ve şimdi kudüs şahittirki semaların küçük şehidi
    Nazlı çiçeğidir Muhammed
    
    Kudüste puslu bir yaz günü
    Kudüste puslu bir yaz günü
    Birazdan kıyamet kopacak
    Küçücük bir şehit cennete uçacak birazdan
    
    Birazdan kıyamet kopacak
    Küçücük bir şehit cennete uçacak birazdan, birazdan
    
    Muhammed yaralı ceylanım kapatma gözlerini
    Muhammed kurbanın olayım bırakma elimi
    Muhammed ne olur duy beni baba gel gidelim de
    Daha çok görecek günün var acelen ne diye
    Kapıda annen bekliyor yolunu gözlüyor
    Muhammed, Muhammed, Muhammed
    
    Kudüste puslu bir yaz günü
    Kudüste puslu bir yaz günü
    Birazdan kıyamet kopacak
    Küçücük bir şehit cennete uçacak birazdan
    
    Birazdan kıyamet kopacak
    Küçücük bir şehit cennete uçacak birazdan, birazdan
    
    Muhammed yaralı ceylanım kapatma gözlerini
    Muhammed kurbanın olayım bırakma elimi
    Muhammed ne olur duy beni baba gel gidelim de
    Daha çok görecek günün var acelen ne diye
    Kapıda annen bekliyor yolunu gözlüyor
    Muhammed, Muhammed, Muhammed, Muhammed
''',
    "Bak Ülkeme": '''
    Bak ülkeme paramparça kim çizmiş bu sınırları
    kavuşacak bir gün elbet ayrı düşmüş ellerimiz

    Ben çeçenim ben arabım kürdüm türküm ben insanım
    Düşmanımız bir, zalimlerdir ben ümmetim müslümanım

    Bak dağlara bak rengine kızıl kana boyanmışlar
    Filistinde Irakta Kürdistanda Çeçenyada
    Ölen benim cephelerde yanan benim ateşlerde

    Ben Yasinim ben Yahyayım Şikakiyim Musaviyim
    el Halilim el Aksayım Felluceyim Halepçeyim
''',
    "Şehitler Ölmez": '''
    şehitler ölmez ölmez
    şehitler ölmez ölmez
    ölü demeyin aman
    ölü demeyin aman
    
    birkucak söz senin için
    bir kucak dua bana
    bir kaçdamla göz yaşı
    bir avuç mısra sana
    
    şehitler ölmez ölmez
    şehitler ölmez ölmez
    ölü demeyin aman
    ölü demeyin aman
    
    hasretlerde düzülmüş
    şahadetin özlemi
    bekler yüreyim şimdi
    kahpe vuran bir mermi
    
    şehitler ölmez ölmez
    şehitler ölmez ölmez
    ölü demeyin aman
    ölü demeyin aman
    
    bizide bulurmu ölüm
    bir cami avlusunda
    şehit kanına doysun
    bulvarlar ve soğuk betonlar
    
    şehitler ölmez ölmez
    şehitler ölmez ölmez
    ölü demeyin aman
    ölü demeyin aman
''',
    "Şehit Tahtında": '''
    Şehit tahtında Rabbe gülümser
    Ah binlerce canım olsaydı der
    Şehit tahtında Rabbe gülümser
    Canım bedeli bir sofradan yer
    
    Ümitsiz olmaz ümitsiz olmaz
    Sevdasız olmaz sevdasız olmaz
    
    Dağları oyup zindan etseler
    Allah nurunu söndüremezler
    Dağları oyup zindan etseler
    Davamın önüne geçemezler
  
    Yarasız olmaz Çilesiz olmaz
    Şehitsiz olmaz Kurbansız olmaz
    
    Şehit tahtında Rabbe gülümser
    Ah binlerce canım olsaydı der
    Şehit tahtında Rabbe gülümser
    Canım bedeli bir sofradan yer
   
    Karanlık ölür zulümat ölür
    Gözler önünde ve Ölüm ölür
   
    Anladım artık Uhud ve Bedir
    Ve Ümit sevda Şehadet nedir
    Soludum Kabri Mahşer anını
    Ümidi Şehidi ve Sevdayı
  
    Şehit tahtında Rabbe gülümser
    Ah binlerce canım olsaydı der
    Şehit tahtında Rabbe gülümser
    Canım bedeli bir sofradan yer
  
    Bilmem nideyim, Allah Allah
    Aşkın elinden, hay hay
    Kande gideyim, aşkın elinden.
    Sallallahu alâ Muhammed
    Sallallahu aleyke Ahmed

    Meskenim dağlar, Allah Allah
    Gözyaşı çağlar, hay hay
    Durmaz kan ağlar, aşkın-elinden.
    Sallallahu alâ Muhammed
    Sallallahu aleyke Ahmed

    Varım vereyim, Allah Allah
    Kadre ereyim, hay hay
    Üryan olayım, aşkın elinden.
    Sallallahu alâ Muhammed
    Sallallahu aleyke Ahmed.
  
    Yunus’un sözü, Allah Allah
    Kül olmuş özü, hay hay
    Kan ağlar gözü, aşkın elinden.
    Sallallahu alâ Muhammed
    Sallallahu aleyke Ahmed.
    ''',
    "Ayrılık Türküsü": '''
    Hani anne demiştin ya,
    Gidiyorsun oğul uğurlar ola,
    Yalnız kalbimde bir yara,
    Sanki gelmezsin bir daha,
    Gelesin oğul, söz ver bana,
    Sarılayım sana, son defa,
    Gelesin oğul, mutlaka,
    Öpeyim seni doya, doya.
    Ben de sana demiştim ya,
    Gidiyorum anne, hak yoluna,
    İhtiyacım var dualarına,
    Hakkını helal et, anne bana,
    Dağları aşmam gerekse de anne,
    Bekle beni anne geleceğim,
    Yollar bitmek bilmese de anne,
    Bekle beni anne geleceğim,
    Belki bu son mektup olur anne,
    Sana yazdığım gurbet elde,
    Belki bir cansız beden gelir,
    Bakarsın öylece kavuşuruz.
    Cansız bedenim anne, gelse bile,
    Öp alnımdan anne, sarıl,
    Sıcak ellerin değsin, soğuk dudaklarıma,
    Öpeyim anne elini.
    Gelirsen anne, toprağıma,
    Kalbinde derin yaralarla,
    Gözlerin sulasın toprağımı,
    Hüzünlü sesin sarsın mekanımı.
    Gökler ağlasın anne, sevgimize,
    Yağmurlar boşalsın üzerimize,
    Bu ayrılık türkümüz anne,
    Ulaşsın dertli gönüllere.
    ''',
    "Özgürlük Türküleri": '''
    Henüz ondokuzunda gencecik bir fidan
    Filizlendi, filizlendi, filizlendi dağlarda
    Katıldı kervanına dağlarla konuşanların
    Ve okudu özgürlük, özgürlük türküsünü
    
    Katıldı kervanına dağlarla konuşanların
    Ve okudu özgürlük, özgürlük türküsünü
    Silahları saz ettiler, kurşunları birer nota
    Kanları kalanlar için türkü oldu dağlarda
    
    Güneşi doğdu bu sabah
    Şehadet yolcularının
    Güneşi doğdu bu sabah
    Şehadet yolcularının
    
    Daha gür okundu bugün
    Özgürlük türküleri
    Daha gür okundu bugün
    Özgürlük türküleri
    
    Parladı iman ateşi söndü zalimin güneşi
    Bir yiğit daha katıldı özgürlük korosuna
    Silahları saz ettiler, kurşunları birer nota
    Kanları kalanlar için türkü oldu dağlarda
    ''',
    "Andola": '''
    Andola yarına, Andola akan kana,
    Andola Allah için çarpışan kullara.
    
    Müslüman’dır adımız, tağutlardan korkmayız,
    İbrahim’in yolunda putları biz kırarız.
    Sürgün, işkence, ölüm, hepsi vız gelir bize,
    Şehadeti seçtik biz, korku yok kalbimizde.
    
    Andola yarına, Andola akan kana,
    Andola Allah için çarpışan kullara.
   
    Savaşımız başladı, zafere dek sürecek,
    Mazlumların ahları zalimi devirecek,
    Rahat yok hepimize, korku girmez düşlere
    Yolumuz Filistin’e, sonra Allah evine.
  
    Andola yarına, Andola akan kana,
    Andola Allah için çarpışan kullara.
   
    Büyük Şeytana (Amerika’ya) ölüm, işbirlikçiye lanet,
    İhanetin bedeli; Zalimler Devrilmeli.
    Halkların özgürlüğü ancak İslam’la olur,
    Ümmetin özgürlüğü ancak Kur’an’la olur.

    Andola yarına, Andola akan kana,
    Andola Allah için çarpışan kullara.
    ''',
    "Ey Şehid": '''
    Hayat iman ve cihad, alnımızın yazısı
    Hayat iman ve cihad, alnımızın yazısı
    Gözlerimde bir hırsı, kamçılayan bir arzu
    Sana ulaşan çağrı Ey Şehid, Ey Şehid
    
    Gözlerimde bir hırsı, kamçılayan bir arzu
    Sana ulaşan çağrı Ey Şehid, Ey Şehid
    Alnı öpülesiler her biri bir dağ gibi
    Alnı öpülesiler her biri bir dağ gibi
    Düşseler vurulupta kanlarıyla boğacak
    Zulmün soluk sesini Ey Şehid, Ey Şehid
    
    Düşseler vurulupta kanlarıyla boğacak
    Zulmün soluk sesini Ey Şehid, Ey Şehid
    Çırpınan kuş misali kalbim sığmaz kabına
    Çırpınan kuş misali kalbim sığmaz kabına
    Allah için bir mermi çıkarırken katına
    Çağırsın ardımızdan Ey Şehid, Ey Şehid
    
    Allah için bir mermi çıkarırken katına
    Çağırsın ardımızdan Ey Şehid, Ey Şehid
    Ey Şehid, Ey Şehid
    Ey Şehid, Ey Şehid
    ''',
    "Mescid-i Aksa": '''
    Dayan kanlı mescit, Mescid-i Aksa
    Bu zulüm, işkence sürmez asla
    Filizleniyor kutsal, yüce dava
    Kafirlerin yapmadığı kalmadı
    Filistin, Filistin, rasul yılmadı
    Kafirlerin yapmadığı kalmadı
    Filistin, Filistin, rasul yılmadı
    Bir uyanış ki dağlar inliyor
    Bir kıyam ki gökler gürlüyor
    Bir uyanış ki dağlar inliyor
    Bir kıyam ki gökler gürlüyor
    Bir cihat ki kalpler titriyor
    Toprağına rahmet yağmuru yağdı
    Filistin, Filistin sabret az kaldı
    Bir cihat ki kalpler titriyor
    Toprağına rahmet yağmuru yağdı
    Filistin, Filistin sabret az kaldı
    Zulüm sende kardeş, sakın boşverme
    Uyku bizi sarmış zehirli meyve
    Sevdaların en yücesi sende
    Kafirlerin yapmadığı kalmadı
    Filistin, Filistin rasul yılmadı
    Kafirlerin yapmadığı kalmadı
    Filistin, Filistin rasul yılmadı
    Bir uyanış ki dağlar inliyor
    Bir kıyam ki gökler gürlüyor
    Bir uyanış ki dağlar inliyor
    Bir kıyam ki gökler gürlüyor
    Bir cihat ki kalpler titriyor
    Toprağına rahmet yağmuru yağdı
    Filistin, Filistin sabret az kaldı
    Bir cihat ki kalpler titriyor
    Toprağına rahmet yağmuru yağdı
    Filistin, Filistin sabret az kaldı
    ''',
    "Kardan Aydınlık": '''
    Gergin uykulardan, kör gecelerden
    Bir sabah gelecek kardan aydınlık
    Gergin uykulardan, kör gecelerden
    Bir sabah gelecek kardan aydınlık
    
    Sonra düğüm düğüm bilmecelerden
    Bir sabah gelecek kardan aydanlık
    Sonra düğüm düğüm bilmecelerden
    Bir sabah gelecek kardan aydanlık
    
    Vurulup ömrünün ilkbaharında
    Kanından çiçekler açar yanında
    Vurulup ömrünün ilkbaharında
    Kanından çiçekler açar yanında
    
    Cümle şehitlerin omuzlarında
    Bir sabah gelecek kardan aydınlık
    Cümle şehitlerin omuzlarında
    Bir sabah gelecek kardan aydınlık
    
    Gökten yağmur yağmur yağacak renkler
    Daha hoş kokacak otlar, çiçekler
    Gökten yağmur yağmur yağacak renkler
    Daha hoş kokacak otlar, çiçekler
    
    Ardından bitmeyen mutlu gerçekler
    Bir sabah gelecek kardan aydınlık
    Ardından bitmeyen mutlu gerçekler
    Bir sabah gelecek kardan aydınlık
    Bir sabah gelecek kardan aydınlık
    ''',
    "Şehadet Uykusu": '''
    Kara gözlerinde mahmurca gülüş
    Gayrı uyanılmaz uykunda mısın
    Gayrı uyanılmaz uykunda mısın
    
    Kanın cemre gibi toprağa düşmüş
    Şehadet yolunun ufkunda mısın
    Şehadet yolunun ufkunda mısın
    
    Çizgilerle dolu ellerin yüzün
    Otuzunda mısın kırkında mısın
    Bizi yalnız koyup göğe süzüldün
    Acın dayanılmaz farkında mısın
    
    Dudakların sanki bir şey söylüyor
    Yine aynı sevda şarkında mısın
    Yine aynı sevda şarkında mısın
    
    Melekler bile sana özeniyor
    Cennette döşenmiş tahtında mısın
    Cennette döşenmiş tahtında mısın
    
    Çizgilerle dolu ellerin yüzün
    Otuzunda mısın kırkında mısın
    Bizi yalnız koyup göğe süzüldün
    Acın dayanılmaz farkında mısın
    
    Acın dayanılmaz farkında mısın
    Farkında mısın
    Melekler bile sana özeniyor
    Cennette döşenmiş tahtında mısın
    Yine aynı sevda şarkında mısın
    Şarkında mısın
''',
    "Bilal": '''
    Yine dağların sevdası düştü yüreğime anne
    Kurşunların sevdası,
    Zulümlerden bıktım usandım
    Yüreğim kanıyor anne,
    Kara bulutlar bir sağanaktır tutturmuş gider
    Dünya zulüm, zulüm kokar anne
    
    Bir bahar düşlüyorum anne
    Gözlerimiz güneşe doymuş ışıl ışıl
    Şehadet rüzgarına kapıldık yüreğimiz göçüyor anne
    Bu savaş bitecek, bu savaş bitecek,
    Hemde karanlığa kalmadan anne
    
    Kanlı gömleğimi göğsüme basıp
    Tağuta lanet okursun ağlarsın ana
    
    Yürekler avuçta dağlara çıkıp
    Şehit şehit vardık düşman üstüne ana
    
    Bilal öldü derler ise sakın inanma ana
    Bilki ben şehid olmuşum şehidler ölmez ana
    
    Şarapnel altında kurşun altında
    Tekbir getiririz marşlar söyleriz ana
    
    Şafakla birlikte düşman üstüne
    Cehennem alevi olur yağarız ana
    
    Bilal öldü derler ise sakın inanma ana
    Bilki ben şehid olmuşum şehidler ölmez ana
    
    Dağlardan dünya bir başka görünür
    Ölüm korkusu gözümden silinir ana
    
    Her şehidin kanı bir lale olmuş
    Haydi sende katıl bize katıl der ana
    
    Bilal öldü derler ise sakın inanma ana
    Bilki ben şehid olmuşum şehidler ölmez ana
    
    Ve 29 ekim 1987
    Bilal de can evinden vuruldu
    Yaprak yaprak düştü
    Şehit kanlarının karıştığı toprağa
    Görün dağlar
    Görün nasıl döne döne savaşıldığını
    Görün sözlerinde duranları
    Ve sonrakilerin nasıl sözlerinde durduklarını
    '''
  };
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

  Widget buildLyricsWidget(String songName, BuildContext context) {
    var lyrics = songLyrics[songName]!;
    List<String> lines = lyrics.split('\n');

    widgets.add(
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
    );

    chords.clear();
    for (String line in lines) {
      if (line.contains('{start_of_chorus}')) {
        widgets.add(
          Text(
            'Nakarat Başlangıcı:',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: lyricsFontSize, color: selectedColor),
          ),
        );
      } else if (line.contains('{end_of_chorus}')) {
        // Add any additional styling for the end of chorus
        widgets.add(
          Text(
            'Nakarat Bitişi.',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: lyricsFontSize, color: selectedColor),
          ),
        );
      } else {
        List<Widget> chordWidgets = [];
        RegExp regExp = RegExp(r'\[([^\]]*)\]');
        Iterable<RegExpMatch> matches = regExp.allMatches(line);
        int index = 0;
        for (RegExpMatch match in matches) {
          if (match.start > index) {
            chordWidgets.add(
              Text(
                "\n${line.substring(index, match.start)}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: lyricsFontSize, color: Colors.white),
              ),
            );
          }

          String? chordText = match.group(1);
          if (chordText != null) {
            if (!chords.contains(chordText)) {
              chords.add(chordText);
            }
            chordWidgets.add(
              GestureDetector(
                onTap: () {
                  // Handle the click event, for example, show a dialog with the chord image
                  _showChordImageDialog(chordText, context);
                },
                child: Text(
                  chordText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: lyricsFontSize,
                    fontWeight: FontWeight.bold,
                    color: selectedColor,
                  ),
                ),
              ),
            );
          }

          index = match.end;
        }

        if (index < line.length) {
          chordWidgets.add(
            Text(
              "\n${line.substring(index)}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: lyricsFontSize, color: Colors.white),
            ),
          );
        }

        widgets.add(
          Column(
            children: [
              Row(
                children: chordWidgets,
              ),
              const SizedBox(height: 8),
              // Adjust spacing between chords and lyrics
            ],
          ),
        );
      }
    }
    widgets2.add(
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ),
      ),
    );
    return Positioned(
      top: 90,
      // Adjust this value based on your app bar height
      left: 0,
      right: 0,
      bottom: 0,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets2,
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
  // Here you can implement the logic to show a dialog with the image of the chord
  // You can use Flutter's built-in dialog or a custom solution.
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(chord),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          // Set your desired corner radius
          child: Image.asset(
            'assets/chord_images/$chord.png',
            fit: BoxFit.fill,
          ),
        ),
        // Adjust the path
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Kapat'),
          ),
        ],
      );
    },
  );
}

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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SettingsPage());
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // This widget is the home page of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MySettingsAppBar(),
      extendBodyBehindAppBar: true,
      body: BlurredBackgroundForSettings(),
    );
  }
}

class BlurredBackgroundForSettings extends StatefulWidget {
  const BlurredBackgroundForSettings({super.key});

  @override
  _BlurredBackgroundForSettingsState createState() {
    return _BlurredBackgroundForSettingsState();
  }
}

class _BlurredBackgroundForSettingsState
    extends State<BlurredBackgroundForSettings> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        settingsList(context),
      ],
    );
  }

  Widget buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_settings.png'),
          // Replace with your image asset path
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  List<Color> colorOptions = [
    const Color(0xFFCD5D5C),
    const Color(0xFFFEA501),
    const Color(0xFF90EE90),
    const Color(0xFF3FE0D0),
    const Color(0xFFAED8E6),
    const Color(0xFFC0C0C0),
    const Color(0xFF9470DC),
    const Color(0xFFFFFFFF),
  ];

  //get the selected color from shared preferences
  Future<void> _loadSelectedColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedColor = Color(prefs.getInt('selectedColor') ?? 0xFFFFFFFF);
  }

  Future<void> _loadScrollDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    scrollDuration = prefs.getInt('scrollDuration') ?? 120;
  }

  Widget settingsList(BuildContext context) {
    return ListView(children: [
      const SizedBox(height: 20),
      ExpansionTile(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/metronome.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 50.0,
              width: 50.0,
            ),
            const SizedBox(width: 6),
            // Adjust the spacing between the icon and text
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Metronom Hızı",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Metronom Hızını Ayarlayın",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(isExpanded ? Icons.arrow_downward : Icons.arrow_forward),
        onExpansionChanged: (bool expansion) {
          setState(
            () {
              _loadScrollDuration();
              isExpanded = expansion;
            },
          );
        },
        children: [
          //dialog to select the set the scroll duration with right and left arrow buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(
                    () {
                      metronomeBpm = metronomeBpm - 1;
                      if (metronomeBpm < 10) {
                        metronomeBpm = 10;
                      }
                      SaveMetronomeBpm.saveMetronomeBpm(metronomeBpm);
                    },
                  );
                },
              ),
              Text(
                "$metronomeBpm BPM",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () {
                  setState(
                    () {
                      metronomeBpm = metronomeBpm + 1;
                      if (metronomeBpm > 200) {
                        metronomeBpm = 200;
                      }
                      SaveMetronomeBpm.saveMetronomeBpm(metronomeBpm);
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 20),
      ExpansionTile(
        title: const Row(
          children: [
            Image(
              image: AssetImage('assets/ChordColor.png'),
              height: 40,
              width: 40,
            ),
            SizedBox(width: 8),
            // Adjust the spacing between the icon and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Akor Rengi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Akor rengini seçin",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(isExpanded ? Icons.arrow_downward : Icons.arrow_forward),
        onExpansionChanged: (bool expansion) {
          // Update the expansion state when the tile is expanded or collapsed
          setState(
            () {
              _loadSelectedColor();
              isExpanded = expansion;
            },
          );
        },
        children: [
          SizedBox(
            height: 70, // Set a fixed height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colorOptions.length,
              itemBuilder: (context, index) {
                Color color = colorOptions[index];
                return InkWell(
                  onTap: () {
                    setState(
                      () {
                        selectedColor = color;
                        //save the selected color to shared preferences
                        SaveSelectedColor.saveColor(selectedColor.value);
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    // Adjust the padding as needed
                    child: Container(
                      width: 50,
                      // Set a fixed width for each color box
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the corner radius as needed
                      ),
                      child: selectedColor == color
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.black38,
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      const SizedBox(height: 20),
      ExpansionTile(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/arrow_downward_circle.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 30.0,
              width: 30.0,
            ),
            const SizedBox(width: 15),
            // Adjust the spacing between the icon and text
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Yavaş Kaydırma",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Şarkı sözlerini yavaşça kaydırın",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(isExpanded ? Icons.arrow_downward : Icons.arrow_forward),
        onExpansionChanged: (bool expansion) {
          setState(
            () {
              _loadScrollDuration();

              isExpanded = expansion;
            },
          );
        },
        children: [
          //dialog to select the set the scroll duration with right and left arrow buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(
                    () {
                      scrollDuration = scrollDuration - 10;
                      if (scrollDuration < 10) {
                        scrollDuration = 10;
                      }
                      SaveScrollDuration.saveScrollDuration(scrollDuration);
                    },
                  );
                },
              ),
              Text(
                "$scrollDuration Saniye",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () {
                  setState(
                    () {
                      scrollDuration = scrollDuration + 10;
                      if (scrollDuration > 900) {
                        scrollDuration = 900;
                      }
                      SaveScrollDuration.saveScrollDuration(scrollDuration);
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 20),
      ListTile(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/info.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 30.0,
              width: 30.0,
            ),
            const SizedBox(width: 15),
            // Adjust the spacing between the icon and text
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hakkında",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Uygulama Hakkında Bilgi",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Handle the tap event
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AboutScreen(),
            ),
          );
        },
      ),
      const SizedBox(height: 20)
    ]);
  }
}

class SaveSelectedColor {
  static const String _selectedColorKey = "selectedColor";

  SaveSelectedColor(Color color);

  // Save the selected color to shared preferences
  static Future<void> saveColor(int selectedColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedColorKey, selectedColor);
  }

  // Retrieve the selected color from shared preferences
  static Future<String?> getSelectedColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedColorKey);
  }
}

class SaveScrollDuration {
  static const String scrollDurationKey = "scrollDuration";

  SaveScrollDuration(int scrollDuration);

  // Save the selected color to shared preferences
  static Future<void> saveScrollDuration(int scrollDuration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(scrollDurationKey, scrollDuration);
  }
}

class SaveMetronomeBpm {
  static const String metronomeBpmKey = "metronomeBpm";

  SaveMetronomeBpm(int metronomeBpm);

  // Save the selected color to shared preferences
  static Future<void> saveMetronomeBpm(int metronomeBpm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(metronomeBpmKey, metronomeBpm);
  }
}

class MySettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MySettingsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Ayarlar',
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
          Future<void> loadSelectedColor() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            selectedColor = Color(prefs.getInt('selectedColor') ?? 0xFFFFFFFF);
          }

          Future<void> loadMetronomeBpm() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            metronomeBpm = prefs.getInt('metronomeBpm') ?? 120;
          }

          loadMetronomeBpm();
          loadSelectedColor();
          Navigator.of(context).pop();
        },
      ),

      // Replace with your desired icon
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AboutPage());
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAboutAppBar(),
      extendBodyBehindAppBar: true,
      body: BlurredBackgroundForAbout(),
    );
  }
}

class BlurredBackgroundForAbout extends StatelessWidget {
  const BlurredBackgroundForAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        aboutList(),
      ],
    );
  }

  Widget buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_settings.png'),
          // Replace with your image asset path
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget aboutList() {
    Future<void> launchUri(Uri url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: const Center(
          //make text center

          child: Text(
            'Grup İslami Direniş',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: const Center(
          //make text center

          child: Text(
            'Ezgi ve Marş Uygulaması',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(20.0),
        //make text center

        child: const Text(
          'İlk ve tek albümünü 1992 yılında Özgürlük İçin İslami Direniş adıyla yayınlayan grup, yeni üyeleriyle 2013 yılından beri çalışmalarına devam etmektedir.',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(20.0),
        //make text center

        child: const Text(
          'Linkler',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(20.0),
        //make text center

        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                launchUri(Uri.parse('https://instagram.com/grupislamidirenis'));
              },
              child: Image.asset(
                'assets/instagram_icon.png',
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    launchUri(
                        Uri.parse('https://instagram.com/grupislamidirenis'));
                  },
                  child: const Text(
                    'Instagram',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchUri(
                        Uri.parse('https://instagram.com/grupislamidirenis'));
                  },
                  child: const Text(
                    'instagram.com/grupislamidirenis',
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.all(20.0),
        //make text center

        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                launchUri(Uri.parse('https://twitter.com/gislamidirenis'));
              },
              child: Image.asset(
                'assets/x_icon.png',
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    launchUri(Uri.parse('https://twitter.com/gislamidirenis'));
                  },
                  child: const Text(
                    'Twitter',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchUri(Uri.parse('https://twitter.com/gislamidirenis'));
                  },
                  child: const Text(
                    'twitter.com/grupislamidirenis',
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.all(20.0),
        //make text center

        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                launchUri(Uri.parse('https://facebook.com/grupislamidirenis'));
              },
              child: Image.asset(
                'assets/facebook_icon.png',
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    launchUri(
                        Uri.parse('https://facebook.com/grupislamidirenis'));
                  },
                  child: const Text(
                    'Facebook',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchUri(
                        Uri.parse('https://facebook.com/grupislamidirenis'));
                  },
                  child: const Text(
                    'facebook.com/grupislamidirenis',
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}

class MyAboutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAboutAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Hakkında',
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
    );
  }
}

class Song {
  final String title;
  final String cover;

  const Song({required this.title, required this.cover});
}
