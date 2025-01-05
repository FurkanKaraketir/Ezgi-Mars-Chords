import 'package:Ezgiler/SongItem.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SongsScreen extends StatelessWidget {
  final String albumId;

  SongsScreen({super.key, required this.albumId});

  String _getAlbumTitle(String id) {
    switch (id) {
      case 'album1':
        return 'Haykır · Grup İslami Direniş';
      case 'album2':
        return 'Arşiv';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    String albumTitle = _getAlbumTitle(albumId);
    return WillPopScope(
      onWillPop: () async {
        context.go('/');
        return false; // Prevent app from closing
      },
      child: Scaffold(
        appBar: MySongListAppBar(myTitle: albumTitle),
        extendBodyBehindAppBar: true,
        body: BlurredBackgroundForSongs(albumTitle: albumTitle),
      ),
    );
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
          context.go('/');
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

class BlurredBackgroundForSongs extends StatelessWidget {
  final String albumTitle;

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
        children: [
          SongItem(
            id: 'song1',
            title: 'Ahzab\'daki Yiğitler',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song2',
            title: 'Dağlardayız Biz Ovalarda',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song3',
            title: 'Haykır',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song4',
            title: 'Bağlanmaz ki Yüreğim',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song5',
            title: 'Savur İnancsız Külleri',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song6',
            title: 'Kaçış',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song7',
            title: 'Çocuğum',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song8',
            title: 'Büyük Şeytana Ölüm',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song9',
            title: 'Ninni',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song10',
            title: 'Müstezafin',
            keyNote: '',
            albumCover: 'assets/haykir.jpeg',
            albumTitle: albumTitle,
          ),
        ],
      );
    } else {
      return ListView(
        children: [
          SongItem(
            id: 'song11',
            title: 'Şehadet Bir Tutku',
            keyNote: '',
            albumCover: 'assets/archive.jpg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song12',
            title: 'Yolunda İslamın',
            keyNote: '',
            albumCover: 'assets/archive.jpg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song13',
            title: 'Adı Bilinmez Müslüman',
            keyNote: '',
            albumCover: 'assets/archive.jpg',
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song14',
            title: "Suskunluğun Bedeli",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song15',
            title: "Bak Ülkeme",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song16',
            title: "Şehitler Ölmez",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song17',
            title: "Şehit Tahtında",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song18',
            title: "Ayrılık Türküsü",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song19',
            title: "Özgürlük Türküleri",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song20',
            title: "Andola",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song21',
            title: "Ey Şehid",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song22',
            title: "Mescid-i Aksa",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song23',
            title: "Kardan Aydınlık",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song24',
            title: "Şehadet Uykusu",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
          SongItem(
            id: 'song25',
            title: "Bilal",
            keyNote: "",
            albumCover: "assets/archive.jpg",
            albumTitle: albumTitle,
          ),
        ],
      );
    }
  }
}
