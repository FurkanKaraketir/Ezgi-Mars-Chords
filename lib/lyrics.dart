import 'dart:async';
import 'package:Ezgiler/chords.dart';
import 'package:Ezgiler/main.dart';
import 'package:Ezgiler/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
    {Kapo 4}
    [Em]Dağlardayız biz [G]ovalarda [Em]
    [Am]Makina başında [Em]sıralarda
    [Am]Sürdürüyoruz [G]kavgamızı
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
    {Kapo 2}
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
    {Kapo 2}
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
    [Em]Kıyama duracak İslam ümmeti
    [G]Himaye edecek öksüz, yetimi
    [Am]Zalimleri kovmaya [Em]yeminliyiz
    [D]Büyük şeytana ölüm, [C]Kahrol Amerika[Em]
    
    {start_of_chorus}
    [Em]Kahrol Amerika [G]katil Amerika
    [D]Nifağın kaynağı şeytan Amerika
    [Em]Kahrol Amerika [G]katil Amerika
    [D]Nifağın kaynağı şeytan Amerika
    [D]Büyük şeytana ölüm, [C]Kahrol Amerika[Em]
    {end_of_chorus}
    
    [Em]Öfke çektim kınından biledim imanla
    [G]Tek vücut, tek bilek ve tek feryatla
    [Am]Semaya yükselir [Em]Allah-u Ekber
    [D]Büyük şeytana ölüm, [C]Kahrol Amerika[Em]
    
    {start_of_chorus}
    [Em]Kahrol Amerika [G]katil Amerika
    [D]Nifağın kaynağı şeytan Amerika
    [Em]Kahrol Amerika [G]katil Amerika
    [D]Nifağın kaynağı şeytan Amerika
    [D]Büyük şeytana ölüm, [C]Kahrol Amerika[Em]
    {end_of_chorus}
    
    [Em]Kefeni giyip de çıkmışız biz yola
    [G]Endişemiz yoktur asla yarına
    [Am]Kudüs’ünde taşken [Em]meydanda bir slogan
    [D]Büyük şeytana ölüm, [C]Kahrol Amerika[Em]
    
    {start_of_chorus}
    [Em]Kahrol Amerika [G]katil Amerika
    [D]Nifağın kaynağı şeytan Amerika
    [Em]Kahrol Amerika [G]katil Amerika
    [D]Nifağın kaynağı şeytan Amerika
    [D]Büyük şeytana ölüm, [C]Kahrol Amerika[Em]
    {end_of_chorus}
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
    {Kapo 2}
    [Em]Yalnız bırakılsak [G]savaş yolunda
    [Em]Olmasa yanımızda [Dm]yol arkadaşı[Em]
    [Em]Karşımıza çıksa [G]bütün bir dünya
    [Em]Dönmek yok sürdüreceğiz[Dm] savaşı[Em]
    
    {start_of_chorus}
    [Em]Şehadet bir tutku[F], bir [G]özlem bize[Em]
    [Em]Ölüm bir son değil[F], [G]diriliş bize[Em]
    [Em]Şehadet bir tutku[F], bir [G]özlem bize[Em]
    [Em]Ölüm bir son değil[F], [G]diriliş bize[Em]
    {end_of_chorus}
    
    [Em]Sarsılsa acıyla [G]tüm bedenimiz
    [Em]Eğilmez başımız [Dm]düşmana karşı[Em]
    [Em]Her gün yeniden [G]yemin ederiz
    [Em]Dönmek yok sürdüreceğiz[Dm] savaşı[Em]
    
    {start_of_chorus}
    [Em]Şehadet bir tutku[F], bir [G]özlem bize[Em]
    [Em]Ölüm bir son değil[F], [G]diriliş bize[Em]
    [Em]Şehadet bir tutku[F], bir [G]özlem bize[Em]
    [Em]Ölüm bir son değil[F], [G]diriliş bize[Em]
    {end_of_chorus}
    
    [Em]Sayı, silah, zaman [G]hepsi bahane
    [Em]Tutamaz mı ellerim [Dm]yerdeki taşı[Em]
    [Em]İman ve sabır [G]olduğu müddetçe
    [Em]Dönmek yok sürdüreceğiz[Dm] savaşı[Em]
    
    {start_of_chorus}
    [Em]Şehadet bir tutku[F], bir [G]özlem bize[Em]
    [Em]Ölüm bir son değil[F], [G]diriliş bize[Em]
    [Em]Şehadet bir tutku[F], bir [G]özlem bize[Em]
    [Em]Ölüm bir son değil[F], [G]diriliş bize[Em]
    {end_of_chorus}
    
    ''',
    "Yolunda İslamın": '''
    {Kapo 2}
    [Em]Yolunda İslamın [Am]kardeşler olalım[Em]
    [Em]Yolunda İslamın [Am]kardeşler olalım[Em]
    [Am]Acıyı paylaşıp [G]sevgiyle dolalım[Am]
    [Am]Emperyalizmin [G]sağ soluna [D]karşı duralım[Em]
    [Am]Mustaz'afin [G]hakkı için [D]haydi vuralım[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]

    [D]Bir inkılaptır bu [Am]güneş gibi doğdu
    [D]Bir inkılaptır bu [Am]güneş gibi doğdu
    [C]Hakikatin nuru [G]karanlığı [Am]boğdu
    [Am]Allahu ekber [G]bayrağımız [D]dalgalanmakta[Em]
    [Am]Halka be halka [G]halklar Hakta [D]halkalanmakta[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]

    [Em]Yıkıldı firavun Haman[Am] ile Karun[Em]
    [Em]Yıkıldı firavun Haman[Am] ile Karun[Em]
    [Am]Nemruda ne oldu [G]çağdaşlara sorun[Am]
    [Am]Bu inkılap [G]mazlumların en [D]haklı davası[Em]
    [Am]Bu inkılap [G]tağutların [D]korkulu rüyası[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]
    
    [D]Milletimiz İslam, [Am]anayasa Kur'an
    [D]Milletimiz İslam, [Am]anayasa Kur'an
    [C]Vatanımız dünya, [G]parolamız [Am]selam
    [Am]Allahu Ekber [G]bayrağımız [D]dalgalanmakta[Em]
    [Am]Halka ve halka [G]halklar Hakta [D]halkalanmakta[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]
    [G]Allahu Ekber[Em]
    
    
    ''',
    "Adı Bilinmez Müslüman": '''
    [Em]Gece karanlığında bir yiğit çıkmış yola
    [Em]Gece karanlığında bir yiğit çıkmış yola
    [Am]Elinde mavzeriyle [G]alnı sanki [Em]yıldızlarda
    [Am]Elinde mavzeriyle [G]alnı sanki [Em]yıldızlarda
    [Am]Adı bilinmez müslüman [Em]ver elini götür bizi
    [Am]Adı bilinmez müslüman [Em]ver elini götür bizi
    [Am]Götür bizi uzaklara [G]özgürlüğün [Em]diyarına
    [Am]Götür bizi uzaklara [G]özgürlüğün [Em]diyarına

    [Em]Hak uğrunda geçen günler pekiştirmiş yüreğini
    [Em]Hak uğrunda geçen günler pekiştirmiş yüreğini
    [Am]Ekmek değil istediği [G]izzetli bir [Em]yaşam diler
    [Am]Ekmek değil istediği [G]izzetli bir [Em]yaşam diler
    [Am]Adı bilinmez müslüman [Em]ver elini götür bizi
    [Am]Adı bilinmez müslüman [Em]ver elini götür bizi
    [Am]Götür bizi uzaklara [G]özgürlüğün [Em]diyarına
    [Am]Götür bizi uzaklara [G]özgürlüğün [Em]diyarına

    [Am]Ve duası kabul oldu bir kurşun onu buldu
    [Am]Ve duası kabul oldu bir kurşun onu buldu
    [Am]Ondan duyulan son ses [G]Allahüekber[Em] oldu
    [Am]Ondan duyulan son ses [G]Allahüekber[Em] oldu
    [Am]Adı bilinmez müslüman [Em]ver elini götür bizi
    [Am]Adı bilinmez müslüman [Em]ver elini götür bizi
    [Am]Götür bizi uzaklara [G]özgürlüğün [Em]diyarına
    [Am]Götür bizi uzaklara [G]özgürlüğün [Em]diyarına
''',
    "Suskunluğun Bedeli": '''
    Kudüste[Em] puslu [G]bir yaz günü[F]
    Kudüste[Em] puslu [G]bir yaz günü[F]
    Birazdan[Em] kıyamet kopacak[G]
    Küçücük[Am] bir şehit[F] cennete[G] uçacak[F] birazdan[Em]
    
    Birazdan[Em] kıyamet kopacak[G]
    Küçücük[Am] bir şehit[F] cennete[G] uçacak[F] birazdan[Em]
    Birazdan[Em], Birazdan[Em]
    
    Muhammed[Am] yaralı ceylanım kapatma gözlerini
    Muhammed[G] kurbanın olayım bırakma elimi
    Muhammed[Am] ne olur duy beni baba gel gidelim de
    Daha [G]çok görecek günün var acelen ne diye
    Kapıda[Am] annen bekliyor yolunu gözlüyor
    Muhammed[G], Muhammed[Am], Muhammed[Am]
    
    Kudüste[Em] puslu [G]bir yaz günü[F]
    Kudüste[Em] puslu [G]bir yaz günü[F]
    Birazdan[Em] kıyamet kopacak[G]
    Küçücük[Am] bir şehit[F] cennete[G] uçacak[F] birazdan[Em]
    
    Birazdan[Em] kıyamet kopacak[G]
    Küçücük[Am] bir şehit[F] cennete[G] uçacak[F] birazdan[Em]
    Birazdan[Em], Birazdan[Em]
    
    Muhammed[Am] yaralı ceylanım kapatma gözlerini
    Muhammed[G] kurbanın olayım bırakma elimi
    Muhammed[Am] ne olur duy beni baba gel gidelim de
    Daha [G]çok görecek günün var acelen ne diye
    Kapıda[Am] annen bekliyor yolunu gözlüyor
    Muhammed[G], Muhammed[Am], Muhammed[Am], Muhammed[Am]
    
    
''',
    "Bak Ülkeme": '''
    [Em]Bak ülkeme [Dm]paramparça 
    [Am]kim çizmiş bu [Em]sınırları
    [Em]Bak ülkeme [Dm]paramparça 
    [Am]kim çizmiş bu [Em]sınırları
    [Am]Kavuşacak [G]bir gün elbet 
    [F]Ayrı düşmüş [Em]ellerimiz
    [Am]Kavuşacak [G]bir gün elbet 
    [F]Ayrı düşmüş [Em]ellerimiz

    {start_of_chorus}  
    [Am]Ben çeçenim [G]ben arabım [F]kürdüm türküm [Em]ben insanım
    [Am]Düşmanımız bir, [G]zalimlerdir 
    [F]ben ümmetim [Em]müslümanım
    {end_of_chorus}
    
    [Em]Bak dağlara [Dm]bak rengine 
    [Am]kızıl kana [Em]boyanmışlar
    [Em]Bak dağlara [Dm]bak rengine 
    [Am]kızıl kana [Em]boyanmışlar
    
    [Am]Filistinde [G]ah Irakta [F]Kürdistanda [Em]Çeçenyada
    [Am]Ölen benim [G]cephelerde 
    [F]yanan benim [Em]ateşlerde

    {start_of_chorus}  
    [Am]Ben çeçenim [G]ben arabım [F]kürdüm türküm [Em]ben insanım
    [Am]Düşmanımız bir, [G]zalimlerdir 
    [F]ben ümmetim [Em]müslümanım
    {end_of_chorus}

    [Em]Ben Yasinim [Dm]ben Yahyayım 
    [Em]Ben Yasinim [Dm]ben Rantisi'yim 
    [Am]Şikakiyim [Em]Musaviyim
    [Am]el Halilim [G]el Aksayım 
    [F]Felluceyim [Em]Halepçeyim
    [Am]el Halilim [G]el Aksayım 
    [F]Felluceyim [Em]Halepçeyim
    
    {start_of_chorus}  
    [Am]Ben çeçenim [G]ben arabım [F]kürdüm türküm [Em]ben insanım
    [Am]Düşmanımız bir, [G]zalimlerdir 
    [F]ben ümmetim [Em]müslümanım
    {end_of_chorus}
''',
    "Şehitler Ölmez": '''
    {start_of_chorus}
    [Am]şehitler ölmez ölmez
    [Am]şehitler ölmez ölmez
    [G]ölü demeyin aman
    ölü demeyin[F] [Em]aman
    {end_of_chorus}
    
    {start_of_chorus}
    [Am]şehitler ölmez ölmez
    [Am]şehitler ölmez ölmez
    [G]ölü demeyin aman
    ölü demeyin[F] [Em]aman
    {end_of_chorus}
    
    [Am]bir kucak söz senin için
    [Am]bir kucak söz senin için
    [G]bir kucak dua bana
    bir kucak dua[F] [Em]bana
    [Am]birkaç damla göz yaşı
    [Am]birkaç damla göz yaşı
    [G]bir avuç mısra sana
    bir avuç mısra[F] [Em]sana
    
    {start_of_chorus}
    [Am]şehitler ölmez ölmez
    [Am]şehitler ölmez ölmez
    [G]ölü demeyin aman
    ölü demeyin[F] [Em]aman
    {end_of_chorus}
    
    {start_of_chorus}
    [Am]şehitler ölmez ölmez
    [Am]şehitler ölmez ölmez
    [G]ölü demeyin aman
    ölü demeyin[F] [Em]aman
    {end_of_chorus}
    
    bizide bulurmu ölüm
    bizide bulurmu ölüm
    bir cami avlusunda
    bir cami avlusunda
    şehit kanına doysun
    şehit kanına doysun
    bulvarlar ve soğuk beton
    bulvarlar ve soğuk beton
    
    {start_of_chorus}
    [Am]şehitler ölmez ölmez
    [Am]şehitler ölmez ölmez
    [G]ölü demeyin aman
    ölü demeyin[F] [Em]aman
    {end_of_chorus}
    
    {start_of_chorus}
    [Am]şehitler ölmez ölmez
    [Am]şehitler ölmez ölmez
    [G]ölü demeyin aman
    ölü demeyin[F] [Em]aman
    {end_of_chorus}
    
    hasretlerde dizilmiş
    hasretlerde dizilmiş
    şahadetin özlemi
    şahadetin özlemi
    bekler yüreyim şimdi
    bekler yüreyim şimdi
    kahpe vuran bir mermi
    kahpe vuran bir mermi
    
    {start_of_chorus}
    [Am]şehitler ölmez ölmez
    [Am]şehitler ölmez ölmez
    [G]ölü demeyin aman
    ölü demeyin[F] [Em]aman
    {end_of_chorus}
    
    {start_of_chorus}
    [Am]şehitler ölmez ölmez
    [Am]şehitler ölmez ölmez
    [G]ölü demeyin aman
    ölü demeyin[F] [Em]aman
    {end_of_chorus}
    
    
''',
    "Şehit Tahtında": '''
    Şehit tahtında Rabbe gülümser
    Ah binlerce canım olsaydı der
    Şehit tahtında Rabbe gülümser
    Canım bedeli bir sofradan yer
    
    [Em]Ümitsiz olmaz ümitsiz olmaz
    Sevdasız[F] olmaz sevdasız[Em] olmaz
    [Em]Ümitsiz olmaz ümitsiz olmaz
    Sevdasız[F] olmaz sevdasız[Em] olmaz
    
    Dağları[Am] oyup zindan [G]etseler
    Allah [F]nurunu [Em]söndüremezler
    Dağları[Am] oyup zindan [G]etseler
    Davamın[F] önüne [Em]geçemezler
  
    Yarasız olmaz Çilesiz olmaz
    Şehitsiz olmaz Kurbansız olmaz
    Yarasız olmaz Çilesiz olmaz
    Şehitsiz olmaz Kurbansız olmaz
    
    Şehit tahtında Rabbe gülümser
    Ah binlerce canım olsaydı der
    Şehit tahtında Rabbe gülümser
    Canım bedeli bir sofradan yer
   
    Karanlık ölür zulümat ölür
    Gözler önünde ve Ölüm ölür
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
    
    
    ''',
    "Ayrılık Türküsü": '''
    {Kapo 2}
    [Em]Hani anne demiştin [F]ya,
    Gidiyorsun oğul uğurlar ola[Em],
    [Em]Yalnız kalbimde bir [F]yara,
    Sanki gelmezsin bir daha[Em],
    
    Gelesin [Am]oğul, söz ver bana[G],
    Sarılayım [F]sana, son [Em]defa,
    Gelesin [Am]oğul, mutlaka[G],
    Öpeyim [F]seni doya, [Em]doya.
    
    [Em]Ben de sana demiştim [F]ya,
    Gidiyorum anne, hak yoluna[Em],
    [Em]İhtiyacım var dualarına[F],
    Hakkını helal et, anne bana[Em],
    
    Dağları [Am]aşmam gerekse [G]de anne,
    Bekle beni[F] anne geleceğim[Em],
    Yollar bitmek[Am] bilmese de [G]anne,
    Bekle beni[F] anne geleceğim[Em],
    
    [Em]Belki bu son mektup olur anne[F],
    Sana yazdığım gurbet elde[Em],
    [Em]Belki bir cansız beden gelir[F],
    Bakarsın öylece kavuşuruz.[Em]
    
    Cansız bedenim[Am] anne, gelse bile[G],
    Öp alnımdan[F] anne, sarıl[Em],
    Sıcak ellerin[Am] değsin, soğuk dudaklarıma[G],
    Öpeyim[F] anne elini[Em].
    
    [Em]Gelirsen anne, toprağıma[F],
    Kalbinde derin yaralarla[Em],
    [Em]Gözlerin sulasın toprağımı[F],
    Hüzünlü sesin sarsın mekanımı[Em].
    
    Gökler ağlasın[Am] anne, sevgimize,[G]
    Yağmurlar boşalsın[F] üzerimize,[Em]
    Bu ayrılık[Am] türkümüz anne,[G]
    Ulaşsın [F]dertli gönüllere.
    ''',
    "Özgürlük Türküleri": '''
    {Kapo 4}
    [Em]Henüz ondokuzunda 
    [Am]gencecik bir [F]fidan
    [G]Filizlendi, [F]filizlendi,
     [G]filizlendi[F] [G]dağlarda[F] [Em]
    
    [Am]Katıldı kervanına[G] 
    [Am]dağlarla konuşanların[F]
    [Dm]Ve okudu özgür[F]lüüüüüüük[G], 
    [G]özgürlük [F]tür[G]kü[F]sünü[Em]
    
    [Am]Katıldı kervanına [
    F]dağlarla konuşanların
    [Dm]Ve okudu özgürlüüüüüüük, 
    [G]özgürlük [F]tür[G]kü[F]sünü[Em]
    
    [Am]Silahları saz ettiler, 
    [F]kurşunları birer nota
    [Dm]Kanları kalanlar için 
    [G]türkü oldu[F] [G]dağ[F]lar[Em]da
    
    [Em]Güneşi [G]doğdu bu sabah
    Şehadet [G]yolcularının[Em]
    [Em]Güneşi [G]doğdu bu sabah
    Şehadet [G]yolcularının[Em]
    
    [Am]Daha gür okundu [F]bugün
    [G]Özgürlük [Dm]türküleri[Em]
    [Am]Daha gür okundu [F]bugün
    [G]Özgürlük [Dm]türküleri[Em]
    
    [Am]Parladı iman ateşi[F] 
    söndü zalimin güneşi
    [Dm]Bir yiğit daha katıldı 
    [G]Özgürlük [F]ko[G]ro[F]su[Em]na
    
    [Am]Silahları saz ettiler, 
    [F]kurşunları birer nota
    [Dm]Kanları kalanlar için 
    [G]türkü oldu[F] [G]dağ[F]lar[Em]da
    ''',
    "Andola": '''
    {Kapo 2}
    {start_of_chorus}
    [Am]Andola yarına, [Em]Andola akan kana,
    [G]Andola Allah için [Em]çarpışan [Am]kullara.
    [Am]Andola yarına, [Em]Andola akan kana,
    [G]Andola Allah için [Em]çarpışan [Am]kullara.
    {end_of_chorus}
        
    [Am]Müslüman’dır adımız, [Em]tağutlardan korkmayız,
    [G]İbrahim’in yolunda [Em]putları biz [Am]kırarız.
    [Am]Sürgün, işkence, ölüm, [Em]hepsi vız gelir bize,
    [G]Şehadeti seçtik biz, [EM]korku yok [Am]kalbimizde.
    
    {start_of_chorus}
    [Am]Andola yarına, [Em]Andola akan kana,
    [G]Andola Allah için [Em]çarpışan [Am]kullara.
    [Am]Andola yarına, [Em]Andola akan kana,
    [G]Andola Allah için [Em]çarpışan [Am]kullara.
    {end_of_chorus}
    
    [Am]Savaşımız başladı, [Em]zafere dek sürecek,
    [G]Mazlumların ahları [Em]zalimi [Am]devirecek,
    [Am]Rahat yok hepimize, [Em]korku girmez düşlere
    [G]Yolumuz Filistin’e, [Em]sonra Allah [Am]evine.
  
    {start_of_chorus}
    [Am]Andola yarına, [Em]Andola akan kana,
    [G]Andola Allah için [Em]çarpışan [Am]kullara.
    [Am]Andola yarına, [Em]Andola akan kana,
    [G]Andola Allah için [Em]çarpışan [Am]kullara.
    {end_of_chorus}
   
    [Am]Büyük Şeytana ölüm, [Em]işbirlikçiye lanet,
    [G]İhanetin bedeli; [Em]Zalimler [Am]Devrilmeli.
    [Am]Halkların özgürlüğü [Em]ancak İslam’la olur,
    [G]Ümmetin özgürlüğü [Em]ancak Kur’an’la [Am]olur.

    {start_of_chorus}
    [Am]Andola yarına, [Em]Andola akan kana,
    [G]Andola Allah için [Em]çarpışan [Am]kullara.
    [Am]Andola yarına, [Em]Andola akan kana,
    [G]Andola Allah için [Em]çarpışan [Am]kullara.
    {end_of_chorus}
    ''',
    "Ey Şehid": '''
    [Em]Hayat iman [Am]ve cihad, alnımızın [F]yazısı[Em]
    [Em]Hayat iman [Am]ve cihad, alnımızın [F]yazısı[Em]
    
    Gözlerimde [Am]bir hırsı, kamçılayan [G]bir arzu
    Sana ulaşan[F] çağrı Ey Şehid[G], Ey Şehid[Em]
    Gözlerimde [Am]bir hırsı, kamçılayan [G]bir arzu
    Sana ulaşan[F] çağrı Ey Şehid[G], Ey Şehid[Em]
    
    [Em]Alnı öpülesiler[Am] her biri bir [F]dağ gibi[Em]
    [Em]Alnı öpülesiler[Am] her biri bir [F]dağ gibi[Em]
    
    Düşseler vurulup[Am]da kanlarıyla [G]boğacak
    Zulmün soluk [F]sesini Ey Şehid[G], Ey Şehid[Em]
    Düşseler vurulup[Am]da kanlarıyla [G]boğacak
    Zulmün soluk [F]sesini Ey Şehid[G], Ey Şehid[Em]
    
    [Em]Gün geçtikçe [Am]büyüyor gönüllerin [F]ateşi[Em]
    [Em]Gün geçtikçe [Am]büyüyor gönüllerin [F]ateşi[Em]
    
    Taş yürek ses [Am]veriyor doğan İslam [G]güneşi
    İlk düşen sensin[F] yola Ey Şehid[G], Ey Şehid[Em]
    Taş yürek ses [Am]veriyor doğan İslam [G]güneşi
    İlk düşen sensin[F] yola Ey Şehid[G], Ey Şehid[Em]
    
    [Em]Çırpınan kuş [Am]misali kalbim sığmaz [F]kabına[Em]
    [Em]Çırpınan kuş [Am]misali kalbim sığmaz [F]kabına[Em]
    
    Allah için bir [Am]mermi çıkarırken [G]katına
    Çağırsın [F]ardımızdan Ey Şehid[G], Ey Şehid[Em]
    Allah için bir [Am]mermi çıkarırken [G]katına
    Çağırsın [F]ardımızdan Ey Şehid[G], Ey Şehid[Em]
    
    ''',
    "Mescid-i Aksa": '''
    [Em]Dayan kanlı mescit, Mescid[G]i Aksa[F]
    Bu zulüm, [G]işkence [F]sürmez asla[Em]
    Filizleniyor[G] kutsal, yüce dava
    
    {start_of_chorus}
    Kafirlerin[Am] yapmadığı [G]kalmadı
    [Em]Filistin[F], [G]Filistin, [G]rasul [F]yılmadı[Em]
    Kafirlerin[Am] yapmadığı [G]kalmadı
    [Em]Filistin[F], [G]Filistin[Am], [G]rasul [F]yılmadı[Em]
    [Em]Bir uyanış [F]ki [Em]dağlar inliyor[F]
    [Em]Bir uyanış [F]ki [Em]dağlar inliyor[F]
    [Am]Bir cihat ki [G]kalpler titriyor
    Toprağına rahmet yağmuru yağdı[Em]
    [Em]Filistin[F], [G]Filistin[Am], [G]sabret [F]az kaldı[Em]
    [Am]Bir cihat ki [G]kalpler titriyor
    Toprağına rahmet yağmuru yağdı[Em]
    [Em]Filistin[F], [G]Filistin[Am], [G]sabret [F]az kaldı[Em]
    {end_of_chorus}
    
    [Em]Zulüm sende [G]kardeş, sakın boşverme[F]
    Uyku bizi [G]sarmış [F]zehirli meyve[Em]
    Sevdaların[G] en yücesi [Em]sende
    
    {start_of_chorus}
    Kafirlerin[Am] yapmadığı [G]kalmadı
    [Em]Filistin[F], [G]Filistin, [G]rasul [F]yılmadı[Em]
    Kafirlerin[Am] yapmadığı [G]kalmadı
    [Em]Filistin[F], [G]Filistin[Am], [G]rasul [F]yılmadı[Em]
    [Em]Bir uyanış [F]ki [Em]dağlar inliyor[F]
    [Em]Bir uyanış [F]ki [Em]dağlar inliyor[F]
    [Am]Bir cihat ki [G]kalpler titriyor
    Toprağına rahmet yağmuru yağdı[Em]
    [Em]Filistin[F], [G]Filistin[Am], [G]sabret [F]az kaldı[Em]
    [Am]Bir cihat ki [G]kalpler titriyor
    Toprağına rahmet yağmuru yağdı[Em]
    [Em]Filistin[F], [G]Filistin[Am], [G]sabret [F]az kaldı[Em]
    {end_of_chorus}
    ''',
    "Kardan Aydınlık": '''
    [Am]Gergin uykulardan, [G]kör gece[Am]lerden
    [Am]Bir sabah gelecek [Em]kardan [Am]aydınlık
    [Am]Gergin uykulardan, [G]kör gece[Am]lerden
    [Am]Bir sabah gelecek [Em]kardan [Am]aydınlık
    
    [C]Sonra düğüm düğüm [Dm]bilmece[Am]lerden
    [Em]Bir sabah gelecek kardan ay[Am]dınlık
    [C]Sonra düğüm düğüm [Dm]bilmece[Am]lerden
    [E]Bir sabah gelecek kardan ay[Am]dınlık
    
    [Am]Vurulup ömrünün [G]ilkbaharında[Am]
    [Am]Kanından çiçekler [E]açar yanında[Am]
    [Am]Vurulup ömrünün [G]ilkbaharında[Am]
    [Am]Kanından çiçekler [E]açar yanında[Am]
    
    [C]Cümle şehitlerin [Dm]omuzlar[Am]ında
    [E]Bir sabah gelecek kardan ay[Am]dınlık
    [C]Cümle şehitlerin [Dm]omuzlar[Am]ında
    [E]Bir sabah gelecek kardan ay[Am]dınlık
    
    [Am]Gökten yağmur yağmur [G]yağacak [Am]renkler
    [Am]Daha hoş kokacak [E]otlar, çi[Am]çekler
    [Am]Gökten yağmur yağmur [G]yağacak [Am]renkler
    [Am]Daha hoş kokacak [E]otlar, çi[Am]çekler
    
    [C]Ardından bitmeyen [Dm]mutlu ger[Am]çekler
    [E]Bir sabah gelecek kardan ay[Am]dınlık
    [C]Ardından bitmeyen [Dm]mutlu ger[Am]çekler
    [E]Bir sabah gelecek kardan ay[Am]dınlık
    [E]Bir sabah gelecek kardan ay[Am]dınlık
    ''',
    "Şehadet Uykusu": '''
    {Kapo 2}
    [Em]Kara gözler[D]inde mah[Em]murca gül[D]üş
    [Am]Gayrı uya[Em]nılmaz uy[D]kunda mısın[Em]
    
    [Em]Kanın cemre [D]gibi top[Em]rağa düş[D]müş
    [Am]Şehadet yol[Em]unun uf[D]kunda mısın[Em]
    [Am]Şehadet yol[Em]unun uf[D]kunda mısın[Em]

    {start_of_chorus}  
    [Am]Çizgilerle [Em]dolu el[D]lerin yüzün[Em]
    [Am]Otuzunda [Em]mısın kırk[D]ında mısın[Em]
    [Am]Bizi yalnız [Em]koyup gö[D]ğe süzüldün[Em]
    [Am]Acın daya[Em]nılmaz fark[D]ında mısın[Em]
    [Am]Acın daya[Em]nılmaz fark[D]ında mısın[Em]
    {end_of_chorus}
    
    [Em]Dudakların [D]sanki bir [Em]şey söylüy[D]or
    [Am]Yine aynı [Em]sevda şark[D]ında mısın[Em]
    [Em]Melekler bile[D] sana [Em]özeni[D]yor
    [Am]Cennette döş[Em]enmiş taht[D]ında mısın[Em]
    [Am]Cennette döş[Em]enmiş taht[D]ında mısın[Em]
    
    {start_of_chorus}  
    [Am]Çizgilerle [Em]dolu el[D]lerin yüzün[Em]
    [Am]Otuzunda [Em]mısın kırk[D]ında mısın[Em]
    [Am]Bizi yalnız [Em]koyup gö[D]ğe süzüldün[Em]
    [Am]Acın daya[Em]nılmaz fark[D]ında mısın[Em]
    [Am]Acın daya[Em]nılmaz fark[D]ında mısın[Em]
    {end_of_chorus}
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
    
    [Em]Kanlı gömleğimi [Am]göğsüme [G]basıp
    [Am]Tağuta lan[G]et okursun ağlarsın [Em]ana
    
    [Em]Yürekler avuçta [Am]dağlara [G]çıkıp
    [Am]Şehit şehit [G]vardık düşman üstüne [Em]ana
    
    {start_of_chorus}
    [Em]Bilal öldü [Am]derler ise [G]sakın inanma ana
    [Am]Bilki ben [G]şehid olmuşum şehidler ölmez [Em]ana
    [Em]Şehidler [D]ölmez ana şehidler [C]ölmez ana
    Şehidler ölmez ana
    {end_of_chorus}
    
    [Em]Şarapnel altında [Am]kurşun [G]altında
    [Am]Tekbir getiri[G]riz marşlar söyleriz [Em]ana
    
    [Em]Şafakla birlikte [Am]düşman [G]üstüne
    [Am]Cehennem [G]alevi olur yağarız [Em]ana
    
    {start_of_chorus}
    [Em]Bilal öldü [Am]derler ise [G]sakın inanma ana
    [Am]Bilki ben [G]şehid olmuşum şehidler ölmez [Em]ana
    [Em]Şehidler [D]ölmez ana şehidler [C]ölmez ana
    Şehidler ölmez ana
    {end_of_chorus}
    
    [Em]Dağlardan dünya bir [Am]başka [G]görünür
    [Am]Ölüm korkusu [G]gözümden silinir [Em]ana
    
    [Em]Her şehidin kanı [Am]bir lale [G]olmuş
    [Am]Haydi sende [G]katıl bize katıl der [Em]bana
    
    {start_of_chorus}
    [Em]Bilal öldü [Am]derler ise [G]sakın inanma ana
    [Am]Bilki ben [G]şehid olmuşum şehidler ölmez [Em]ana
    [Em]Şehidler [D]ölmez ana şehidler [C]ölmez ana
    Şehidler ölmez ana
    {end_of_chorus}
    
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
      } else if (line.contains('{Kapo 4}')) {
        widgets.add(
          Text(
            'Kapo: 4',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: lyricsFontSize, color: selectedColor),
          ),
        );
      } else if (line.contains('{Kapo 2}')) {
        widgets.add(
          Text(
            'Kapo: 2',
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
