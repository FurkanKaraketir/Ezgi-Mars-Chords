import 'package:Ezgiler/lyrics.dart';
import 'package:Ezgiler/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        selectedColor = Color(prefs.getInt('selectedColor') ?? 0xFFFEA501);
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
