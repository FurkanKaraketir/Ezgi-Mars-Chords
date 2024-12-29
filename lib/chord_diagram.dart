import 'package:flutter/material.dart';
import 'chord_theory.dart';

class ChordDiagram extends CustomPainter {
  final String chord;
  final ChordPosition chordPosition;
  final bool isDarkTheme;

  ChordDiagram(this.chord, {this.isDarkTheme = true})
      : chordPosition = _getChordPosition(chord);

  static ChordPosition _getChordPosition(String chord) {
    List<List<int>> positions = ChordTheory.generateChordPositions(chord);

    if (positions.isNotEmpty) {
      return ChordPosition.fromFrets(positions.first);
    }

    return ChordPosition(
        frets: List.filled(6, -1), fingers: List.filled(6, -1));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkTheme ? Colors.white : Colors.black
      ..strokeWidth = size.width * 0.01
      ..style = PaintingStyle.stroke;

    // Calculate dimensions
    final double margin = size.width * 0.1;
    final double diagramWidth = size.width - (2 * margin);
    final double diagramHeight = size.height - (2 * margin);
    final double fretWidth = diagramWidth / 6;
    final double fretHeight = diagramHeight / 6;

    // Translate canvas to add margin
    canvas.translate(margin, margin);

    // Draw frets
    for (int i = 0; i <= 5; i++) {
      double y = fretHeight * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(diagramWidth, y),
        paint,
      );
    }

    // Draw strings
    for (int i = 0; i < 6; i++) {
      double x = fretWidth * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, diagramHeight),
        paint,
      );
    }

    // Draw finger positions
    final dotPaint = Paint()
      ..color = isDarkTheme ? Colors.white : Colors.black
      ..style = PaintingStyle.fill;

    for (int string = 0; string < 6; string++) {
      int fret = chordPosition.frets[string];
      double x = fretWidth * string;

      if (fret > 0) {
        // Draw filled circle for fretted position
        canvas.drawCircle(
          Offset(x, fretHeight * (fret - 0.5)),
          fretWidth * 0.35,
          dotPaint,
        );
      } else if (fret == 0) {
        // Draw open string symbol
        canvas.drawCircle(
          Offset(x, -margin * 0.5),
          fretWidth * 0.25,
          Paint()
            ..color = isDarkTheme ? Colors.white : Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = size.width * 0.01,
        );
      } else if (fret == -1) {
        // Draw X for muted string
        final xPaint = Paint()
          ..color = isDarkTheme ? Colors.white : Colors.black
          ..strokeWidth = size.width * 0.015;

        final double xSize = fretWidth * 0.25;
        canvas.drawLine(
          Offset(x - xSize, -margin * 0.5 - xSize),
          Offset(x + xSize, -margin * 0.5 + xSize),
          xPaint,
        );
        canvas.drawLine(
          Offset(x - xSize, -margin * 0.5 + xSize),
          Offset(x + xSize, -margin * 0.5 - xSize),
          xPaint,
        );
      }
    }

    // Draw fret numbers if needed
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Find the lowest fret position that's not 0 or -1
    int lowestFret = chordPosition.frets.where((f) => f > 0).fold(0, min);
    if (lowestFret > 1) {
      textPainter.text = TextSpan(
        text: lowestFret.toString(),
        style: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
          fontSize: size.width * 0.08,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-margin * 0.8, fretHeight * 0.5 - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ChordPosition {
  final List<int> frets;
  final List<int> fingers;

  ChordPosition({required this.frets, required this.fingers});

  static ChordPosition fromFrets(List<int> frets) {
    return ChordPosition(frets: frets, fingers: List.filled(6, -1));
  }
}

int min(int a, int b) => a < b ? a : b;
