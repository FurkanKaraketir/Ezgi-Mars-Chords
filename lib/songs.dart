import 'package:Ezgiler/SongItem.dart';
import 'package:flutter/material.dart';

class SongsScreen extends StatelessWidget {
  String albumTitle;

  SongsScreen({super.key, required this.albumTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MySongsPage(
      albumTitle: albumTitle,
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
