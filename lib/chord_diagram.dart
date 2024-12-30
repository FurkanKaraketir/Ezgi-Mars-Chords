import 'package:flutter/material.dart';
import 'chord_theory.dart';

class ChordDiagram extends CustomPainter {
  final String chord;
  final ChordPosition chordPosition;
  final bool isDarkTheme;
  final int capoPosition;

  ChordDiagram(
    this.chord, {
    this.isDarkTheme = true,
    this.capoPosition = 0,
    ChordPosition? position,
  }) : chordPosition = position ?? _getChordPosition(chord, capoPosition);

  static ChordPosition _getChordPosition(String chord, int capoPosition) {
    List<List<int>> positions = ChordTheory.generateChordPositions(chord);

    if (positions.isEmpty) {
      return ChordPosition(
          frets: List.filled(6, -1), fingers: List.filled(6, -1));
    }

    // Adjust fret positions for capo
    List<int> adjustedFrets = positions.first.map((fret) {
      if (fret == -1) return -1;
      return fret - capoPosition;
    }).toList();

    return ChordPosition.fromFrets(adjustedFrets);
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

    // Draw capo if needed
    if (capoPosition > 0) {
      final capoPaint = Paint()
        ..color = isDarkTheme ? Colors.white70 : Colors.black87
        ..style = PaintingStyle.fill;

      // Draw capo bar with rounded corners and shadow
      final capoRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          -margin * 0.2,
          -fretHeight * 0.15,
          diagramWidth + margin * 0.4,
          fretHeight * 0.3,
        ),
        Radius.circular(fretHeight * 0.15),
      );

      // Draw shadow
      canvas.drawRRect(
        capoRect.shift(Offset(2, 2)),
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      // Draw capo bar
      canvas.drawRRect(
        capoRect,
        capoPaint,
      );

      // Draw capo text in a more elegant way
      final TextPainter capoPainter = TextPainter(
        text: TextSpan(
          text: 'CAPO',
          style: TextStyle(
            color: isDarkTheme ? Colors.black : Colors.white,
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      capoPainter.layout();

      // Position text centered on the capo bar
      capoPainter.paint(
        canvas,
        Offset(
          (diagramWidth - capoPainter.width) / 2,
          -fretHeight * 0.15 + (fretHeight * 0.3 - capoPainter.height) / 2,
        ),
      );

      // Draw position number
      final TextPainter positionPainter = TextPainter(
        text: TextSpan(
          text: capoPosition.toString(),
          style: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black,
            fontSize: size.width * 0.08,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      positionPainter.layout();

      // Position number to the left of the diagram
      positionPainter.paint(
        canvas,
        Offset(
          -margin * 0.8,
          -fretHeight * 0.15 + (fretHeight * 0.3 - positionPainter.height) / 2,
        ),
      );
    }

    // Draw frets with varying thickness
    for (int i = 0; i <= 5; i++) {
      paint.strokeWidth = i == 0 ? size.width * 0.02 : size.width * 0.01;
      double y = fretHeight * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(diagramWidth, y),
        paint,
      );
    }

    // Draw strings with varying thickness
    for (int i = 0; i < 6; i++) {
      paint.strokeWidth =
          size.width * (0.01 - (i * 0.001)); // Thicker for bass strings
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

        // Draw finger number if available
        if (chordPosition.fingers[string] > 0) {
          final TextPainter fingerPainter = TextPainter(
            text: TextSpan(
              text: chordPosition.fingers[string].toString(),
              style: TextStyle(
                color: isDarkTheme ? Colors.black : Colors.white,
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          );
          fingerPainter.layout();
          fingerPainter.paint(
            canvas,
            Offset(
              x - fingerPainter.width / 2,
              fretHeight * (fret - 0.5) - fingerPainter.height / 2,
            ),
          );
        }
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
      String fretText = lowestFret.toString();
      textPainter.text = TextSpan(
        text: fretText,
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
