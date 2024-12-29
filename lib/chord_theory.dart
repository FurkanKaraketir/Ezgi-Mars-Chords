import 'package:flutter/material.dart';

class ChordTheory {
  // Standard guitar tuning from low to high string
  static const List<String> STANDARD_TUNING = ['E', 'A', 'D', 'G', 'B', 'E'];

  // All notes in chromatic scale
  static const List<String> CHROMATIC_SCALE = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];

  // Intervals for different chord types
  static const Map<String, List<int>> CHORD_INTERVALS = {
    '': [0, 4, 7], // Major
    'm': [0, 3, 7], // Minor
    '7': [0, 4, 7, 10], // Dominant 7th
    'm7': [0, 3, 7, 10], // Minor 7th
    'maj7': [0, 4, 7, 11], // Major 7th
    'dim': [0, 3, 6], // Diminished
    'aug': [0, 4, 8], // Augmented
    'sus4': [0, 5, 7], // Suspended 4th
    'sus2': [0, 2, 7], // Suspended 2nd
    'add9': [0, 4, 7, 14], // Add 9
    '6': [0, 4, 7, 9], // Major 6th
    'm6': [0, 3, 7, 9], // Minor 6th
    '9': [0, 4, 7, 10, 14], // Dominant 9th
    'maj9': [0, 4, 7, 11, 14], // Major 9th
    'm9': [0, 3, 7, 10, 14], // Minor 9th
    '11': [0, 4, 7, 10, 14, 17], // Dominant 11th
    '13': [0, 4, 7, 10, 14, 21], // Dominant 13th
    '5': [0, 7], // Power chord
    'dim7': [0, 3, 6, 9], // Diminished 7th
    'aug7': [0, 4, 8, 10], // Augmented 7th
    '7sus4': [0, 5, 7, 10], // 7sus4
    '7b5': [0, 4, 6, 10], // 7 flat 5
    '7#5': [0, 4, 8, 10], // 7 sharp 5
    'm7b5': [0, 3, 6, 10], // Half diminished
  };

  // Common chord shapes for each chord type
  static const Map<String, Map<String, List<int>>> COMMON_SHAPES = {
    '': {
      // Major
      'E': [0, 2, 2, 1, 0, 0],
      'A': [-1, 0, 2, 2, 2, 0],
      'D': [-1, -1, 0, 2, 3, 2],
      'G': [3, 2, 0, 0, 0, 3],
      'C': [-1, 3, 2, 0, 1, 0],
    },
    'm': {
      // Minor
      'Em': [0, 2, 2, 0, 0, 0],
      'Am': [-1, 0, 2, 2, 1, 0],
      'Dm': [-1, -1, 0, 2, 3, 1],
    },
    '7': {
      // Dominant 7th
      'E7': [0, 2, 0, 1, 0, 0],
      'A7': [-1, 0, 2, 0, 2, 0],
      'D7': [-1, -1, 0, 2, 1, 2],
      'G7': [3, 2, 0, 0, 0, 1],
    },
    'maj7': {
      // Major 7th
      'Emaj7': [0, 2, 1, 1, 0, 0],
      'Amaj7': [-1, 0, 2, 1, 2, 0],
      'Dmaj7': [-1, -1, 0, 2, 2, 2],
    },
    'm7': {
      // Minor 7th
      'Em7': [0, 2, 0, 0, 0, 0],
      'Am7': [-1, 0, 2, 0, 1, 0],
      'Dm7': [-1, -1, 0, 2, 1, 1],
    },
    'dim': {
      // Diminished
      'Edim': [0, 1, 2, 0, -1, -1],
      'Adim': [-1, 0, 1, 2, 1, -1],
    },
    'sus4': {
      // Suspended 4th
      'Esus4': [0, 2, 2, 2, 0, 0],
      'Asus4': [-1, 0, 2, 2, 3, 0],
    },
  };

  // Get note index in chromatic scale
  static int _getNoteIndex(String note) {
    return CHROMATIC_SCALE.indexOf(note.replaceAll('b', '#'));
  }

  // Get note at specific fret on a string
  static String _getNoteAtFret(String openNote, int fret) {
    int noteIndex = _getNoteIndex(openNote);
    return CHROMATIC_SCALE[(noteIndex + fret) % 12];
  }

  // Get all possible positions of a note within first 12 frets
  static List<int> _getNotePositions(String targetNote, String stringNote) {
    List<int> positions = [];
    for (int fret = 0; fret <= 12; fret++) {
      if (_getNoteAtFret(stringNote, fret) == targetNote) {
        positions.add(fret);
      }
    }
    return positions;
  }

  // Generate chord notes based on root note and chord type
  static List<String> _getChordNotes(String rootNote, String chordType) {
    int rootIndex = _getNoteIndex(rootNote);
    List<int> intervals = CHORD_INTERVALS[chordType] ?? CHORD_INTERVALS['']!;

    return intervals.map((interval) {
      return CHROMATIC_SCALE[(rootIndex + interval) % 12];
    }).toList();
  }

  // Parse chord name into root note and type
  static (String, String) parseChordName(String chord) {
    // Handle special cases first
    if (chord == 'N.C.' || chord.isEmpty) {
      return ('', '');
    }

    // Regular expression to match chord components
    RegExp regExp = RegExp(r'^([A-G][#b]?)(.*)$');
    Match? match = regExp.firstMatch(chord);

    if (match == null) {
      return ('', '');
    }

    String rootNote = match.group(1)!;
    String chordType = match.group(2) ?? '';

    // Normalize chord type
    if (chordType.startsWith('maj')) {
      chordType = 'maj${chordType.substring(3)}';
    } else if (chordType.startsWith('min')) {
      chordType = 'm${chordType.substring(3)}';
    }

    return (rootNote, chordType);
  }

  // Generate possible chord positions
  static List<List<int>> generateChordPositions(String chord) {
    var (rootNote, chordType) = parseChordName(chord);
    if (rootNote.isEmpty) {
      return [List.filled(6, -1)]; // Return muted strings for invalid chords
    }

    List<List<int>> positions = [];

    // Try to find a predefined shape
    if (COMMON_SHAPES.containsKey(chordType)) {
      var shapes = COMMON_SHAPES[chordType]!;
      String shapeKey = rootNote + chordType;
      if (shapes.containsKey(shapeKey)) {
        positions.add(shapes[shapeKey]!);
        return positions;
      }
    }

    // If no predefined shape, generate basic positions
    // Start with E-shape barre chord
    int rootFret = _getNotePositions(rootNote, 'E')[0];
    List<int> eShape = _getBarreChordShape(rootFret, chordType);
    positions.add(eShape);

    // Add A-shape barre chord if possible
    int aRootFret = _getNotePositions(rootNote, 'A')[0];
    if (aRootFret >= 0) {
      List<int> aShape = _getAShapeBarreChord(aRootFret, chordType);
      positions.add(aShape);
    }

    return positions;
  }

  // Get barre chord shape based on E shape
  static List<int> _getBarreChordShape(int rootFret, String chordType) {
    List<int> baseShape;
    switch (chordType) {
      case 'm':
        baseShape = [0, 2, 2, 0, 0, 0]; // Em shape
        break;
      case '7':
        baseShape = [0, 2, 0, 1, 0, 0]; // E7 shape
        break;
      case 'm7':
        baseShape = [0, 2, 0, 0, 0, 0]; // Em7 shape
        break;
      case 'maj7':
        baseShape = [0, 2, 1, 1, 0, 0]; // Emaj7 shape
        break;
      case 'dim':
        baseShape = [0, 1, 2, 0, -1, -1]; // Edim shape
        break;
      case 'sus4':
        baseShape = [0, 2, 2, 2, 0, 0]; // Esus4 shape
        break;
      default:
        baseShape = [0, 2, 2, 1, 0, 0]; // E shape
    }

    return baseShape.map((fret) => fret == -1 ? -1 : fret + rootFret).toList();
  }

  // Get barre chord shape based on A shape
  static List<int> _getAShapeBarreChord(int rootFret, String chordType) {
    List<int> baseShape;
    switch (chordType) {
      case 'm':
        baseShape = [-1, 0, 2, 2, 1, 0]; // Am shape
        break;
      case '7':
        baseShape = [-1, 0, 2, 0, 2, 0]; // A7 shape
        break;
      case 'm7':
        baseShape = [-1, 0, 2, 0, 1, 0]; // Am7 shape
        break;
      case 'maj7':
        baseShape = [-1, 0, 2, 1, 2, 0]; // Amaj7 shape
        break;
      case 'dim':
        baseShape = [-1, 0, 1, 2, 1, -1]; // Adim shape
        break;
      case 'sus4':
        baseShape = [-1, 0, 2, 2, 3, 0]; // Asus4 shape
        break;
      default:
        baseShape = [-1, 0, 2, 2, 2, 0]; // A shape
    }

    return baseShape.map((fret) => fret == -1 ? -1 : fret + rootFret).toList();
  }
}

class ChordPosition {
  final List<int> frets;
  final List<int> fingers;

  ChordPosition({required this.frets, required this.fingers}) {
    assert(frets.length == 6 && fingers.length == 6);
  }

  // Generate finger positions based on fret positions
  static List<int> generateFingerPositions(List<int> frets) {
    List<int> fingers = List.filled(6, -1);
    int nextFinger = 1;

    // First pass: assign fingers to fretted positions
    for (int i = 0; i < frets.length; i++) {
      if (frets[i] > 0) {
        fingers[i] = nextFinger++;
      } else if (frets[i] == 0) {
        fingers[i] = 0;
      }
    }

    return fingers;
  }

  // Create a ChordPosition from fret positions
  static ChordPosition fromFrets(List<int> frets) {
    return ChordPosition(
      frets: frets,
      fingers: generateFingerPositions(frets),
    );
  }
}
