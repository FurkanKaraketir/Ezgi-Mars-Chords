import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
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
          color: Colors.white,
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
        title: "Haykır · Grup İslami Direniş", cover: 'assets/haykir.jpeg'),
    // Add more album covers as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildGradientOverlay(),
        // Step 3: Album List
        albumList(context),
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
    'Ahzab\'daki Yiğitler': 'F',
    'Dağlardayız Biz Ovalarda': 'G#/m',
    'Haykır': 'D',
    'Bağlanmaz ki Yüreğim': 'F#',
    'Savur İnancsız Külleri': 'F#',
    'Kaçış': 'A',
    'Çocuğum': 'C#',
    'Büyük Şeytana Ölüm': 'D',
    'Ninni': 'F',
    'Müstezafin': 'F#'
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
                    keyNote: songList[snapshot.data![index]] ?? 'Unknown',
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
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: albumCovers.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Container(
                margin: const EdgeInsets.all(32.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the SongsScreen when an album cover is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SongsScreen(albumCover: albumCovers[index].cover),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.0),
                    child: Image.asset(
                      albumCovers[index].cover,
                      fit: BoxFit.fill,
                    ),
                  ),
                )),
            Container(
                margin: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the SongsScreen when an album cover is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SongsScreen(albumCover: albumCovers[index].cover),
                      ),
                    );
                  },
                  child: Text(
                    albumCovers[index].title,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                )),
            Row(children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  // Adjust the margin as needed
                  child: const Divider(),
                ),
              ),
            ]),
            _buildLastPlayedSongs(),
          ],
        );
      },
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
        // Step 2: Gradient Overlay
        buildGradientOverlay(),

        // Step 3: Album List
        albumList(),
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
}

class SongItem extends StatelessWidget {
  // This widget is a custom list item for each song.
  final String title;
  final String keyNote;

  const SongItem({Key? key, required this.title, required this.keyNote})
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
            color: Colors.white,
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
            color: Colors.white,
            height: 30.0,
            width: 30.0,
          ),
          onPressed: () {
            setState(() {
              _isMetronomePlaying = !_isMetronomePlaying;
              // Call your metronome start/stop logic here
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
    Ay ışığı
    Şahit yalnızlığıma
    Kim tutacak
    Mahrum ellerimden
    Kan kusuyor
    Burası benim coğrafyam
    Umudumu
    Bağladım ufuklara
    
    Hadi haykır
    Hiç korkma
    Allah hep yanında
    Hadi diren
    Zalime
    Allah hep seninle
    Vur zillete
    Kır zulmü
    Küffar zincirleri
    Hadi kuşan
    Davayı
    Onurlu sevdayı
    
    Uyan
    Diren
    Özgürleş
    Diren yılma
    Sen kardeş
    Balçıkla sıvanmaz
    Güneş
    Uyan
    Diren
    Özgürleş ki
    Yırtılıp çıksın
    Bağrından karanlığın
    Tüm şafaklar
    
    Yeryüzünü zulüm örter
    Kıyar tüm canlara
    Sömürür zalim efendiler
    Umut biter yarına
    Susar hain işbirlikçi
    Sözde kınar birileri
    Sen de susup haykırmazsan
    Kim haykırır gerçekleri
    
    Gidenler Hüseyin
    Kalanlar
    Zeynep olur
    Sen haykır
    Hiç düşünme
    Ateşler
    Gülistan olur
    Denizler
    Yol olur
    Zindanlar
    Mektep olur
    Hira'dan
    Bir kıvılcım
    Çağlara güneş olur
    Bu kıvılcım
    Sadra düşer
    Gönüllerde
    Umut pişer
    Alnı
    Secdede yükseldi
    İnsan oldu
    Beşer
    Bağrında
    Bir yangın
    Bir bismillah
    Haykır
    Bir yumruk
    Bir kurşun
    Bir slogan
    Haykır
    
    Gün ışığı
    Şahit özgürlüğüme
    Kim duracak
    Şimdi karşımda?
    Destan yazıyor
    Burası
    Benim coğrafyam
    Kıyam düşer
    Mahzun diyarlara
    
    Hadi haykır
    Hiç korkma
    Allah hep yanında
    Hadi diren
    Zalime
    Allah hep seninle
    Vur zillete
    Kır zulmü
    Küffar zincirleri
    Hadi kuşan
    Davayı
    Onurlu sevdayı
    
    Uyan
    Diren
    Özgürleş
    Diren yılma
    Sen kardeş
    Balçıkla sıvanmaz
    Güneş
    Uyan
    Diren
    Özgürleş ki
    Yırtılıp çıksın
    Bağrından karanlığın
    Tüm şafaklar
    
    Güç
    Para
    Şan
    Şöhret
    Putlar artık
    Taştan değil
    Ebreheler şimdileri
    Fil yerine
    Tankla gelir
    Sanılır ki çoğunluklar
    Her zaman galip gelir
    Ebabiller gibi
    Hür çocuklar
    Varken değil
    
    Sakın şaşma
    Hakikat
    Aslında biraz
    Yalnızlıktır
    Vicdanları yutkunanların
    Korkaklıkları azıktır
    Yazıktır
    Bedel zamanı sesleri
    Hep kısıktır
    Ölüm gelip
    Çatsa bile
    Zillet bizden uzaktır
    
    Bir balta kuşan şimdi
    İlahi bir kelimeden
    Özgürlükle oku
    Yıkılsın bu
    Hain düzen
    Umut ek
    Sabır büyüt
    Yılmak nedir bilmeden
    Suni zindanlar yıkılmaz
    Rabbim Allah demeden
    
    Uyan
    Diren
    Özgürleş ki
    Karanlığın
    Bağrından çıkar bütün
    Şafaklar''',
    "Ahzab'daki Yiğitler": '''
    Bir seher
    Vaktinde
    Şafakla
    
    Geleceğiz
    Gün bugün
    Ötesi yok
    Gün bugün
    Durmak yok
    Bir seher vaktinde
    Şafakla geleceğiz
    Gün bugün ötesi yok
    Gün bugün durmak yok
    
    Rabbin müjdesi
    Bizleri bekler
    Zalim yüreği
    Korkudan titrer
    Susmazsa eğer
    Söz veren erler
    Ahzab′daki yiğitler
    Rabbin müjdesi
    Bizleri bekler
    Zalim yüreği
    Korkudan titrer
    Susmazsa eğer
    Söz veren erler
    Ahzab'daki yiğitler
    
    Bir seher
    Vaktinde
    Zaferle
    Geleceğiz
    Müjde bu
    Dönmek yok
    Yatakta ölmek yok
    
    Bir seher
    Vaktinde
    Zaferle
    Geleceğiz
    Müjde bu
    Dönmek yok
    Yatakta ölmek yok
    
    Rabbin müjdesi
    Bizleri bekler
    Zalim yüreği
    Korkudan titrer
    Susmazsa eğer
    Söz veren erler
    Ahzab′daki yiğitler
    Rabbin müjdesi
    Bizleri bekler
    Zalim yüreği
    Korkudan titrer
    Susmazsa eğer
    Söz veren erler
    Ahzab'daki yiğitler
    
    Bir seher
    Vaktinde
    Ölümle
    Geleceğiz
    Od olup
    Sönmek yok
    Şehitsiz
    Dönmek yok
    Bir seher
    Vaktinde
    Ölümle
    Geleceğiz
    Od olup
    Sönmek yok
    Şehitsiz
    Dönmek yok
    
    Rabbin müjdesi
    Bizleri bekler
    Zalim yüreği
    Korkudan titrer
    Susmazsa eğer
    Söz veren erler
    Ahzab'daki yiğitler
    
    Sadıklar
    Şahitler
    Önderler onlar
    Ateşte İbrahim
    Denizde Musa
    Kuyuda Yusuf′tular
    Kerbela′da Hüseyin'di onlar
    Şahitler
    Önderler
    Ölümsüz şehitler
    Onlar
    Direnişin
    Onurlu çocukları
    Onlar
    Müjde dolu laleler
    Onlar
    Yetim bebeklerin
    Şerefli intikamı
    Mazlumun feryadının
    Cevabıdırlar
    
    Korksun bizden
    Zalimler
    Hainler
    Zorbalar
    Bozguncular
    Korksunlar
    Nefretimizden
    Öfkemizden
    Onurumuzdan
    Ve şehadetimizden
    Korksunlar
    Söyleyin beklesinler
    Ansızın kabus olacak
    Direnişimizi
    Bir seher vakti
    Beklesinler
    
    Ey sevdamıza
    Taş koyanlar
    Ey kaybımızdan
    Haz duyanlar
    Ey yeryüzünün
    Fesat
    Fitne
    Nifak kaynakları
    Ey Amerika
    Bakışlarımız çetin
    Nefretimiz büyük
    İntikamımız kısa ve hiddetlidir
    Ve ey İsrail
    Bekle bizi
    Beklediğin her yerde
    Ve bekle bizi
    Beklemediğin her yerde
    
    Rabbin müjdesi
    Bizleri bekler
    Zalim yüreği
    Korkudan titrer
    Susmazsa eğer
    Söz veren erler
    Ahzab′daki yiğitler
    ''',
    "Bağlanmaz ki Yüreğim": '''
    Kurtuluşum
    İslam'dadır
    Kurtuluşum
    Lâ ilahe
    Amacımız
    İllallah'tır
    Tağutlardan
    Kurtulmaktır
    Amacımız
    İllallah'tır
    Tağutlardan
    Kurtulmaktır
    Bağlansa
    Elim ayağım
    Bağlanmaz ki
    Yüreğim
    Alev olur
    Rüzgar olur
    Savurur
    Zulmü yüreğim
    Feryat olur
    Yumruk olur
    Dağıtır
    Zulmü yüreğim
    Savaşımız
    İnançladır
    Coğrafya bilmez
    Fitne kalkmadan
    Bu savaş
    İnan ki bitmez
    Fitne kalkmadan
    Bu savaş
    İnan ki bitmez
    Bağlansa
    Elim ayağım
    Bağlanmaz ki
    Yüreğim
    Alev olur
    Rüzgar olur
    Savurur
    Zulmü yüreğim
    Feryat olur
    Yumruk olur
    Dağıtır
    Zulmü yüreğim
    İşkencelerden
    Geçtik
    Sürgünler yedik
    Kan aktı
    Bedenlerden
    Kurbanlar verdik
    Kan aktı
    Bedenlerden
    Kurbanlar verdik
    Bağlansa
    Elim ayağım
    Bağlanmaz ki
    Yüreğim
    Alev olur
    Rüzgar olur
    Savurur
    Zulmü yüreğim
    Feryat olur
    Yumruk olur
    Dağıtır
    Zulmü yüreğim
    ''',
    "Savur İnancsız Külleri": '''
    Savur inançsız
    Külleri avuçlarından
    O küller ki savruldu
    Put meydanından
    İbrahim mirasından
    Sana kalanla
    Put kıran ellerini
    Kuşan Müslüman
    İbrahim mirasından
    Sana kalanla
    Put kıran ellerini
    Kuşan Müslüman
    
    Direniş
    İbadetim
    Onurum
    Şehadetim
    Ne gam bilir
    Yüreğim
    Korku tatmış
    Değilim
    
    Rabbim Allah’tır benim
    Adım Müslüman benim
    Rabbim Allah’tır benim
    Adım Müslüman benim
    
    Omzunda tevhidin
    İhtişamı var
    Zillet görmemiş alnında
    Secde izi var
    Korkutur zalimi
    Dik duruşun hey
    Her mazlumu
    Saracak
    Merhametin var
    Korkutur zalimi
    Dik duruşun hey
    Her mazlumu
    Saracak
    
    Direniş
    İbadetim
    Onurum
    Şehadetim
    Ne gam bilir
    Yüreğim
    Korku tatmış
    Değilim
    
    Rabbim Allah’tır benim
    Adım Müslüman benim
    Rabbim Allah’tır benim
    Adım Müslüman benim
    Rabbim Allah’tır benim
    Adım Müslüman benim
    ''',
    "Kaçış": '''
    Dün gece
    Yürüdüm
    Yeryüzü denen
    Handa
    Kıyamete boyanmış
    Kabuslar sokaklarda
    Adalet dağıtılmış
    Merhametsiz silahlarla
    Burada hep suçlu doğmuş
    Güneş yüzlü çocuklar
    
    Çürümüş başaklardan
    Kurumuş pınarlardan
    Çalınmış emeklerden
    Parçalanmış canlardan
    Utandım
    Biçare kaldım
    
    İçimde döndü dünya
    Aradım karış karış
    Haykırdı Meryem’ce
    Bir sükûtla
    Yok mu bir kaçış
    Sonra
    Bir sığınış
    Rahmetince sakin
    Bir yere
    Kainattan
    Boşalmış
    
    Sanki dağlar
    Yıkılırmış
    İçimdeki
    Bu sancıdan
    Göğsüm sıkışıp daralmış
    Türlü bela
    Acılardan
    Bir felah ver
    Katından
    Sadrıma ver bir
    Genişlik
    Bir devrim müjdesi
    Bana bir haber gönder
    
    İbrahim gülistanından
    Yusuf’un Kenan’ından
    İsa kundağından
    Tur-i Sina Musa’sından
    Hira’dan bir
    Nefes aldım
    
    İçimde döndü dünya
    Aradım karış karış
    Haykırdı Meryem’ce
    Bir sükûtla
    Yok mu bir kaçış
    Sonra
    Bir sığınış
    Rahmetince sakin
    Bir yere
    Kainattan
    Boşalmış
    ''',
    "Çocuğum": '''
    Vakit akşamüstü çok bekleme
    Zaman çok daraldı koş evine
    Haydi akşamın vakti girmeden yine
    Bekletme babanı çocuğum
    Küçük çocukları küçük kurşunlar
    Sokakta annelerden önce kucaklar
    Melekler cennette yerini hazırlar
    Rabbini bekletme çocuğum
    Karanlık çökmeden bul evini
    Bombalar bastırmadan ezan sesini
    Uyu sen düşünme hiç gerisini
    Rüyalar öldürmez çocuğum
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
    Yetim bebekleri mezar beşiklere yatırmış, toprak örtüler sermiş analardan
    Ağıtlar yankılanıyor arzda
    Avuçları soğuk toprakta bir anne
    Şimdi bir ninni fısıldıyor kainata

    Annesinin minik kuzusu
    Yavrusunun sinmiş kokusu
    Gül rengi gömleğine
    Eee bebeğim
    Yum gözünü baban bekler
    Vuruldun alnından
    Onurlu imanından
    İnsanlık vicdanından
    Eee bebeğim
    Yum gözünü baban bekler
    Mis kokulu can parem benim
    Yitip giden minik çiçeğim
    Sevinç bilmez gözbebeğim
    Eee bebeğim
    Yum gözünü baban bekler
    Ve ölür insan bozulur mizan
    Ölür insan…
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
  };

  List<Widget> widgets = [];

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
                setState(() {
                  if (lyricsFontSize < 26) {
                    lyricsFontSize += 2;
                  } else {
                    lyricsFontSize = 26;
                  }
                  widgets.clear();
                });
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
                  setState(() {
                    if (lyricsFontSize > 8) {
                      lyricsFontSize -= 2;
                    } else {
                      lyricsFontSize = 8;
                    }
                    widgets.clear();
                  });
                }),
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

    widgets.add(Container(
      margin: const EdgeInsets.all(20.0),
      child: Text(
        songName,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
        ),
      ),
    ));

    chords.clear();
    for (String line in lines) {
      if (line.contains('{start_of_chorus}')) {
        widgets.add(Text(
          'Nakarat Başlangıcı:',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: lyricsFontSize, color: Colors.white),
        ));
      } else if (line.contains('{end_of_chorus}')) {
        // Add any additional styling for the end of chorus
        widgets.add(Text(
          'Nakarat Bitişi.',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: lyricsFontSize, color: Colors.white),
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

    return Positioned(
      top: 90,
      // Adjust this value based on your app bar height
      left: 0,
      right: 0,
      bottom: 0,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              color: Colors.white,
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
          setState(() {
            _loadScrollDuration();
            isExpanded = expansion;
          });
        },
        children: [
          //dialog to select the set the scroll duration with right and left arrow buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    metronomeBpm = metronomeBpm - 1;
                    if (metronomeBpm < 10) {
                      metronomeBpm = 10;
                    }
                    SaveMetronomeBpm.saveMetronomeBpm(metronomeBpm);
                  });
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
                  setState(() {
                    metronomeBpm = metronomeBpm + 1;
                    if (metronomeBpm > 200) {
                      metronomeBpm = 200;
                    }
                    SaveMetronomeBpm.saveMetronomeBpm(metronomeBpm);
                  });
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
          setState(() {
            _loadSelectedColor();
            isExpanded = expansion;
          });
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
                    setState(() {
                      selectedColor = color;
                      //save the selected color to shared preferences
                      SaveSelectedColor.saveColor(selectedColor.value);
                    });
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
              color: Colors.white,
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
          setState(() {
            _loadScrollDuration();

            isExpanded = expansion;
          });
        },
        children: [
          //dialog to select the set the scroll duration with right and left arrow buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    scrollDuration = scrollDuration - 10;
                    if (scrollDuration < 10) {
                      scrollDuration = 10;
                    }
                    SaveScrollDuration.saveScrollDuration(scrollDuration);
                  });
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
                  setState(() {
                    scrollDuration = scrollDuration + 10;
                    if (scrollDuration > 900) {
                      scrollDuration = 900;
                    }
                    SaveScrollDuration.saveScrollDuration(scrollDuration);
                  });
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
              color: Colors.white,
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
          )),
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
          )),
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
