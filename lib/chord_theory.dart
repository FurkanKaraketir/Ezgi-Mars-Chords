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
      'F': [1, 3, 3, 2, 1, 1], // Added F major
      'B': [-1, 2, 4, 4, 4, 2], // Added B major
    },
    'm': {
      // Minor
      'Em': [0, 2, 2, 0, 0, 0],
      'Am': [-1, 0, 2, 2, 1, 0],
      'Dm': [-1, -1, 0, 2, 3, 1],
      'Gm': [3, 5, 5, 3, 3, 3], // Added G minor
      'Cm': [-1, 3, 5, 5, 4, 3], // Added C minor
      'Fm': [1, 3, 3, 1, 1, 1], // Added F minor
      'Bm': [-1, 2, 4, 4, 3, 2], // Added B minor
    },
    '7': {
      // Dominant 7th
      'E7': [0, 2, 0, 1, 0, 0],
      'A7': [-1, 0, 2, 0, 2, 0],
      'D7': [-1, -1, 0, 2, 1, 2],
      'G7': [3, 2, 0, 0, 0, 1],
      'C7': [-1, 3, 2, 3, 1, 0], // Added C7
      'F7': [1, 3, 1, 2, 1, 1], // Added F7
      'B7': [-1, 2, 1, 2, 0, 2], // Added B7
    },
    'maj7': {
      // Major 7th
      'Emaj7': [0, 2, 1, 1, 0, 0],
      'Amaj7': [-1, 0, 2, 1, 2, 0],
      'Dmaj7': [-1, -1, 0, 2, 2, 2],
      'Gmaj7': [3, 2, 0, 0, 0, 2], // Added Gmaj7
      'Cmaj7': [-1, 3, 2, 0, 0, 0], // Added Cmaj7
      'Fmaj7': [1, -1, 2, 2, 1, 0], // Added Fmaj7
      'Bmaj7': [-1, 2, 4, 3, 4, 2], // Added Bmaj7
    },
    'm7': {
      // Minor 7th
      'Em7': [0, 2, 0, 0, 0, 0],
      'Am7': [-1, 0, 2, 0, 1, 0],
      'Dm7': [-1, -1, 0, 2, 1, 1],
      'Gm7': [3, 5, 3, 3, 3, 3], // Added Gm7
      'Cm7': [-1, 3, 5, 3, 4, 3], // Added Cm7
      'Fm7': [1, 3, 1, 1, 1, 1], // Added Fm7
      'Bm7': [-1, 2, 0, 2, 0, 2], // Added Bm7
    },
    'dim': {
      // Diminished
      'Edim': [0, 1, 2, 0, -1, -1],
      'Adim': [-1, 0, 1, 2, 1, -1],
      'Ddim': [-1, -1, 0, 1, 0, 1], // Added Ddim
      'Gdim': [3, 4, 5, 3, -1, -1], // Added Gdim
      'Cdim': [-1, 3, 4, 2, 4, 2], // Added Cdim
    },
    'sus4': {
      // Suspended 4th
      'Esus4': [0, 2, 2, 2, 0, 0],
      'Asus4': [-1, 0, 2, 2, 3, 0],
      'Dsus4': [-1, -1, 0, 2, 3, 3], // Added Dsus4
      'Gsus4': [3, 5, 5, 5, 3, 3], // Added Gsus4
      'Csus4': [-1, 3, 3, 0, 1, 1], // Added Csus4
    },
    'sus2': {
      // Added Suspended 2nd shapes
      'Esus2': [0, 2, 2, 4, 0, 0],
      'Asus2': [-1, 0, 2, 2, 0, 0],
      'Dsus2': [-1, -1, 0, 2, 3, 0],
      'Gsus2': [3, 0, 0, 0, 3, 3],
      'Csus2': [-1, 3, 0, 0, 1, 0],
    },
    '6': {
      // Added Major 6th shapes
      'E6': [0, 2, 2, 1, 2, 0],
      'A6': [-1, 0, 2, 2, 2, 2],
      'D6': [-1, -1, 0, 2, 0, 2],
      'G6': [3, 2, 0, 0, 0, 0],
      'C6': [-1, 3, 2, 2, 1, 0],
    },
    'm6': {
      // Added Minor 6th shapes
      'Em6': [0, 2, 2, 0, 2, 0],
      'Am6': [-1, 0, 2, 2, 1, 2],
      'Dm6': [-1, -1, 0, 2, 0, 1],
      'Gm6': [3, 5, 5, 3, 3, 3],
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

  // Get all possible positions of a note within first 24 frets (increased from 12)
  static List<int> _getNotePositions(String targetNote, String stringNote) {
    List<int> positions = [];
    for (int fret = 0; fret <= 24; fret++) {
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
      }
    }

    // Get all possible root note positions on low E and A strings
    List<int> eStringPositions = _getNotePositions(rootNote, 'E');
    List<int> aStringPositions = _getNotePositions(rootNote, 'A');

    // Add E-shape barre chords at different positions
    for (int rootFret in eStringPositions) {
      if (rootFret <= 15) {
        // Limit to reasonable playing positions
        List<int> eShape = _getBarreChordShape(rootFret, chordType);
        positions.add(eShape);
      }
    }

    // Add A-shape barre chords at different positions
    for (int rootFret in aStringPositions) {
      if (rootFret <= 15) {
        // Limit to reasonable playing positions
        List<int> aShape = _getAShapeBarreChord(rootFret, chordType);
        positions.add(aShape);
      }
    }

    // Add alternative voicings based on chord type
    List<List<int>> alternativeVoicings =
        _getAlternativeVoicings(rootNote, chordType);
    positions.addAll(alternativeVoicings);

    // Sort positions by complexity (prefer lower fret positions)
    positions.sort((a, b) {
      int aMax = a.where((f) => f > 0).fold(0, max);
      int bMax = b.where((f) => f > 0).fold(0, max);
      return aMax.compareTo(bMax);
    });

    // Return all valid positions
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

  // Get alternative voicings for chords
  static List<List<int>> _getAlternativeVoicings(
      String rootNote, String chordType) {
    List<List<int>> voicings = [];

    // Find root note positions on different strings
    List<int> ePos = _getNotePositions(rootNote, 'E');
    List<int> aPos = _getNotePositions(rootNote, 'A');
    List<int> dPos = _getNotePositions(rootNote, 'D');
    List<int> gPos = _getNotePositions(rootNote, 'G');
    List<int> bPos = _getNotePositions(rootNote, 'B');
    List<int> highEPos = _getNotePositions(rootNote, 'E');

    // Add some common alternative voicings based on chord type
    switch (chordType) {
      case '': // Major
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          // D-shape voicing
          voicings.add([-1, -1, dPos[0], gPos[0], bPos[0], highEPos[0]]);
          // C-shape voicing if possible
          if (aPos.isNotEmpty) {
            voicings.add([-1, aPos[0], dPos[0], gPos[0], bPos[0], highEPos[0]]);
          }
          // G-shape voicing
          if (ePos.isNotEmpty) {
            voicings.add([ePos[0], -1, dPos[0], gPos[0], bPos[0], highEPos[0]]);
          }
          // High register voicing
          voicings.add([-1, -1, -1, gPos[0], bPos[0], highEPos[0]]);
        }
        break;
      case 'm': // Minor
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          // D-shape minor voicing
          voicings.add([-1, -1, dPos[0], gPos[0], bPos[0] - 1, highEPos[0]]);
          // C-shape minor voicing if possible
          if (aPos.isNotEmpty) {
            voicings
                .add([-1, aPos[0], dPos[0], gPos[0], bPos[0] - 1, highEPos[0]]);
          }
          // High register voicing
          voicings.add([-1, -1, -1, gPos[0], bPos[0] - 1, highEPos[0]]);
          // Root on D string voicing
          if (ePos.isNotEmpty) {
            voicings.add([ePos[0], -1, dPos[0], gPos[0], bPos[0] - 1, -1]);
          }
        }
        break;
      case '7': // Dominant 7
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          // D7 shape voicing
          voicings.add([-1, -1, dPos[0], gPos[0] - 1, bPos[0], highEPos[0]]);
          // Alternative 7th voicing
          if (aPos.isNotEmpty) {
            voicings
                .add([-1, aPos[0], dPos[0], gPos[0] - 1, bPos[0], highEPos[0]]);
          }
          // Shell voicing (root, 3rd, 7th)
          if (ePos.isNotEmpty) {
            voicings.add([ePos[0], -1, -1, gPos[0] - 1, -1, -1]);
          }
          // Drop 2 voicing
          voicings
              .add([-1, -1, dPos[0], gPos[0] - 1, bPos[0], highEPos[0] - 2]);
        }
        break;
      case 'maj7': // Major 7
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          // Dmaj7 shape voicing
          voicings.add([-1, -1, dPos[0], gPos[0], bPos[0], highEPos[0] - 1]);
          if (aPos.isNotEmpty) {
            voicings
                .add([-1, aPos[0], dPos[0], gPos[0], bPos[0], highEPos[0] - 1]);
          }
          // Shell voicing (root, 3rd, 7th)
          if (ePos.isNotEmpty) {
            voicings.add([ePos[0], -1, -1, gPos[0], -1, highEPos[0] - 1]);
          }
          // Drop 2 voicing
          voicings
              .add([-1, -1, dPos[0], gPos[0], bPos[0] - 1, highEPos[0] - 1]);
        }
        break;
      case 'm7': // Minor 7
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          // Dm7 shape voicing
          voicings
              .add([-1, -1, dPos[0], gPos[0] - 1, bPos[0] - 1, highEPos[0]]);
          if (aPos.isNotEmpty) {
            voicings.add(
                [-1, aPos[0], dPos[0], gPos[0] - 1, bPos[0] - 1, highEPos[0]]);
          }
          // Shell voicing (root, b3, b7)
          if (ePos.isNotEmpty) {
            voicings.add([ePos[0], -1, -1, gPos[0] - 1, -1, -1]);
          }
          // Drop 2 voicing
          voicings.add(
              [-1, -1, dPos[0], gPos[0] - 1, bPos[0] - 1, highEPos[0] - 2]);
        }
        break;
      case 'sus4': // Suspended 4th
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          voicings.add([-1, -1, dPos[0], gPos[0] + 1, bPos[0], highEPos[0]]);
        }
        break;
      case 'sus2': // Suspended 2nd
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          voicings.add([-1, -1, dPos[0], gPos[0] - 2, bPos[0], highEPos[0]]);
        }
        break;
      case '6': // Major 6th
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          voicings.add([-1, -1, dPos[0], gPos[0], bPos[0] + 2, highEPos[0]]);
        }
        break;
      case 'm6': // Minor 6th
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          voicings
              .add([-1, -1, dPos[0], gPos[0], bPos[0] - 1, highEPos[0] + 2]);
        }
        break;
      case 'dim': // Diminished
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          voicings.add(
              [-1, -1, dPos[0], gPos[0] - 1, bPos[0] - 1, highEPos[0] - 1]);
        }
        break;
      case 'aug': // Augmented
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          voicings
              .add([-1, -1, dPos[0], gPos[0] + 1, bPos[0] + 1, highEPos[0]]);
        }
        break;
      case 'add9': // Added 9th
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          voicings.add([-1, -1, dPos[0], gPos[0], bPos[0], highEPos[0] + 2]);
          if (aPos.isNotEmpty) {
            voicings
                .add([-1, aPos[0], dPos[0], gPos[0], bPos[0], highEPos[0] + 2]);
          }
        }
        break;
      case '9': // Dominant 9th
        if (dPos.isNotEmpty && gPos.isNotEmpty && bPos.isNotEmpty) {
          voicings
              .add([-1, -1, dPos[0], gPos[0] - 1, bPos[0], highEPos[0] + 2]);
          // Shell voicing with 9th
          if (ePos.isNotEmpty) {
            voicings.add([ePos[0], -1, -1, gPos[0] - 1, -1, highEPos[0] + 2]);
          }
        }
        break;
    }

    // Filter out invalid voicings (where any fret position is negative)
    voicings
        .removeWhere((voicing) => voicing.any((fret) => fret > 0 && fret < 0));

    // Sort voicings by complexity (prefer lower fret positions)
    voicings.sort((a, b) {
      int aMax = a.where((f) => f > 0).fold(0, max);
      int bMax = b.where((f) => f > 0).fold(0, max);
      return aMax.compareTo(bMax);
    });

    return voicings;
  }

  static int min(int a, int b) => a < b ? a : b;
  static int max(int a, int b) => a > b ? a : b;

  // Get the actual chord being played when using a capo
  static String getActualChord(String chord, int capoPosition) {
    if (capoPosition == 0) return chord;

    var (rootNote, chordType) = parseChordName(chord);
    if (rootNote.isEmpty) return chord;

    // Find the new root note by moving up the chromatic scale
    int currentIndex = CHROMATIC_SCALE.indexOf(rootNote);
    if (currentIndex == -1) return chord;

    int newIndex = (currentIndex + capoPosition) % 12;
    String newRoot = CHROMATIC_SCALE[newIndex];

    return newRoot + chordType;
  }

  // Get the relative chord when using a capo
  static String getRelativeChord(String actualChord, int capoPosition) {
    if (capoPosition == 0) return actualChord;

    var (rootNote, chordType) = parseChordName(actualChord);
    if (rootNote.isEmpty) return actualChord;

    // Find the new root note by moving down the chromatic scale
    int currentIndex = CHROMATIC_SCALE.indexOf(rootNote);
    if (currentIndex == -1) return actualChord;

    int newIndex = (currentIndex - capoPosition + 12) % 12;
    String newRoot = CHROMATIC_SCALE[newIndex];

    return newRoot + chordType;
  }

  // Get all equivalent positions for a chord with different capo positions
  static List<(String, int)> getCapoAlternatives(String chord) {
    List<(String, int)> alternatives = [];
    var (rootNote, chordType) = parseChordName(chord);
    if (rootNote.isEmpty) return alternatives;

    // Add the original position
    alternatives.add((chord, 0));

    // Check all possible capo positions up to 12
    for (int capo = 1; capo <= 12; capo++) {
      String relativeChord = getRelativeChord(chord, capo);
      // Only add if the chord shape is common (exists in COMMON_SHAPES)
      var (relativeRoot, relativeType) = parseChordName(relativeChord);
      String shapeKey = relativeRoot + relativeType;
      if (COMMON_SHAPES[relativeType]?.containsKey(shapeKey) ?? false) {
        alternatives.add((relativeChord, capo));
      }
    }

    return alternatives;
  }
}

class ChordPosition {
  final List<int> frets;
  final List<int> fingers;

  ChordPosition({required this.frets, required this.fingers}) {
    assert(frets.length == 6 && fingers.length == 6);
  }

  static int min(int a, int b) => a < b ? a : b;
  static int max(int a, int b) => a > b ? a : b;

  // Generate finger positions based on fret positions
  static List<int> generateFingerPositions(List<int> frets) {
    List<int> fingers = List.filled(6, -1);
    Map<int, int> fretToFinger = {};
    int nextFinger = 1;

    // First pass: identify unique fret positions
    List<int> uniqueFrets = frets.where((f) => f > 0).toList()..sort();
    uniqueFrets = uniqueFrets.toSet().toList();

    // Second pass: assign fingers based on position and ergonomics
    for (int i = 0; i < frets.length; i++) {
      int fret = frets[i];
      if (fret > 0) {
        // If this fret position already has a finger assigned
        if (fretToFinger.containsKey(fret)) {
          fingers[i] = fretToFinger[fret]!;
        } else {
          // Assign new finger based on position
          int finger;
          if (uniqueFrets.length == 1) {
            // Barre chord
            finger = 1;
          } else if (fret == uniqueFrets[0]) {
            // Lowest fret gets index finger
            finger = 1;
          } else if (fret == uniqueFrets[uniqueFrets.length - 1]) {
            // Highest fret gets pinky unless it's close to a lower fret
            finger = (fret - uniqueFrets[0] <= 2) ? 2 : 4;
          } else {
            // Middle frets get middle fingers
            finger = uniqueFrets.indexOf(fret) + 1;
          }
          fingers[i] = finger;
          fretToFinger[fret] = finger;
        }
      } else if (fret == 0) {
        fingers[i] = 0; // Open string
      }
      // -1 frets (muted) keep -1 finger assignment
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

  // Check if this is a barre chord
  bool get isBarreChord {
    // Count how many strings use the lowest fret
    int lowestFret = frets.where((f) => f > 0).reduce(ChordPosition.min);
    int lowestFretCount = frets.where((f) => f == lowestFret).length;

    // It's a barre chord if the lowest fret is used on 2 or more strings
    return lowestFretCount >= 2;
  }

  // Get the barre position (if this is a barre chord)
  int get barrePosition {
    if (!isBarreChord) return -1;
    return frets.where((f) => f > 0).reduce(ChordPosition.min);
  }

  // Get the span of the chord (distance between lowest and highest fret)
  int get fretSpan {
    List<int> playedFrets = frets.where((f) => f > 0).toList();
    if (playedFrets.isEmpty) return 0;
    return playedFrets.reduce(ChordPosition.max) -
        playedFrets.reduce(ChordPosition.min);
  }

  // Check if this is an open chord
  bool get isOpenChord {
    return frets.contains(0);
  }
}
