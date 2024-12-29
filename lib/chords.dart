import 'package:Ezgiler/lyrics.dart';
import 'package:flutter/material.dart';
import 'chord_diagram.dart';
import 'chord_theory.dart';

class ChordsScreen extends StatelessWidget {
  final List<String> chords;

  const ChordsScreen({super.key, required this.chords});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const MyChordsAppBar(),
      body: ChordsPage(chords: chords),
    );
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
      title: const Text(
        'Akorlar',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

class ChordsPage extends StatefulWidget {
  final List<String> chords;

  const ChordsPage({super.key, required this.chords});

  @override
  State<ChordsPage> createState() => _ChordsPageState();
}

class _ChordsPageState extends State<ChordsPage> {
  late List<String> filteredChords;
  final TextEditingController _searchController = TextEditingController();
  String? searchedChord;

  @override
  void initState() {
    super.initState();
    filteredChords = List.from(widget.chords);
    filteredChords =
        filteredChords.where((chord) => chord.trim().isNotEmpty).toList();
    filteredChords.sort();
  }

  void _filterChords(String query) {
    setState(() {
      if (query.isEmpty) {
        searchedChord = null;
        filteredChords = List.from(widget.chords);
      } else {
        // Check if the query is a valid chord
        var (rootNote, chordType) = ChordTheory.parseChordName(query);
        if (rootNote.isNotEmpty) {
          searchedChord = query;
          // Filter existing chords
          filteredChords = widget.chords
              .where(
                  (chord) => chord.toLowerCase().contains(query.toLowerCase()))
              .toList();
        } else {
          searchedChord = null;
          filteredChords = widget.chords
              .where(
                  (chord) => chord.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      }
      filteredChords.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_image.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterChords,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Akor ara veya gir (örn: Am7)...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.search,
                        color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Searched chord (if valid)
              if (searchedChord != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 4,
                    color: const Color(0xFF1C273D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Aranan Akor',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            searchedChord!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 180,
                            width: 180,
                            child: CustomPaint(
                              size: const Size(180, 180),
                              painter: ChordDiagram(searchedChord!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Existing chords grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredChords.length,
                  itemBuilder: (context, index) {
                    return _buildChordCard(context, filteredChords[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChordCard(BuildContext context, String chord) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF1C273D),
      child: InkWell(
        onTap: () => _showChordDialog(context, chord),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chord,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: CustomPaint(
                  size: const Size(150, 150),
                  painter: ChordDiagram(chord),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChordDialog(BuildContext context, String chord) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1C273D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chord,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CustomPaint(
                    size: const Size(250, 250),
                    painter: ChordDiagram(chord),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Kapat',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
