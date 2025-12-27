import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CampusMapPainter extends CustomPainter {
  final String? highlightLocation;

  CampusMapPainter({this.highlightLocation});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // --- PALETTE ---
    final groundColor = const Color(0xFFECEFF1); // Clean concrete city base
    final grassColor = const Color(0xFFC8E6C9); // Lush green
    final grassBorder = const Color(0xFFA5D6A7);

    // 1. BASE LAYER
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = groundColor);

    // 2. GREEN SCAPING (With Trees!)
    _drawDetailedLandscaping(canvas, w, h, grassColor, grassBorder);

    // 3. ROAD NETWORK (Asphalt & Markings)
    _drawDetailedRoads(canvas, w, h);

    // 4. BUILDINGS (3D Effect)
    AppConstants.campusLocations.forEach((name, offset) {
      final cx = w * offset.dx;
      final cy = h * offset.dy;
      final isHighlighted =
          (highlightLocation != null && name == highlightLocation);

      _drawDetailedBuilding(canvas, cx, cy, name, isHighlighted);
    });
  }

  void _drawDetailedLandscaping(
    Canvas canvas,
    double w,
    double h,
    Color fill,
    Color border,
  ) {
    final paint = Paint()..color = fill;
    final borderPaint = Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Helper to draw a zone
    void drawZone(Rect rect) {
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(15));
      canvas.drawRRect(rrect, paint);
      canvas.drawRRect(rrect, borderPaint);

      // ADD SPICE: Scatter some "Trees" inside the zone
      final treePaint = Paint()
        ..color = const Color(0xFF81C784); // Darker green for trees
      final random = math.Random(
        rect.top.toInt(),
      ); // Seeded random so trees stay put

      for (int i = 0; i < 8; i++) {
        double dx = rect.left + random.nextDouble() * rect.width;
        double dy = rect.top + random.nextDouble() * rect.height;
        // Don't draw too close to edge
        if (dx > rect.left + 10 &&
            dx < rect.right - 10 &&
            dy > rect.top + 10 &&
            dy < rect.bottom - 10) {
          canvas.drawCircle(Offset(dx, dy), 6, treePaint);
          // Tree highlight
          canvas.drawCircle(
            Offset(dx - 2, dy - 2),
            2,
            Paint()..color = const Color(0xFFA5D6A7),
          );
        }
      }
    }

    // Top Quad
    drawZone(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.30),
        width: w * 0.55,
        height: h * 0.22,
      ),
    );

    // Bottom Park
    drawZone(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.70),
        width: w * 0.4,
        height: h * 0.18,
      ),
    );
  }

  void _drawDetailedRoads(Canvas canvas, double w, double h) {
    final asphaltColor = const Color(0xFF546E7A); // Dark Grey Road
    final markingColor = Colors.white.withOpacity(0.9);

    final mainRoadPaint = Paint()
      ..color = asphaltColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.square;
    final secondaryRoadPaint = Paint()
      ..color = asphaltColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final dashPaint = Paint()
      ..color = markingColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // --- A. DRAW ASPHALT LAYER ---

    // 1. Vertical Spine (Gate -> Auditorium)
    canvas.drawLine(
      Offset(w * 0.5, h * 0.95),
      Offset(w * 0.5, h * 0.15),
      mainRoadPaint,
    );

    // 2. Service Loop
    final loopPath = Path();
    loopPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.55),
          width: w * 0.8,
          height: h * 0.7,
        ),
        const Radius.circular(35),
      ),
    );
    canvas.drawPath(loopPath, secondaryRoadPaint);

    // 3. Cross Streets
    canvas.drawLine(
      Offset(w * 0.1, h * 0.25),
      Offset(w * 0.9, h * 0.25),
      secondaryRoadPaint,
    );
    canvas.drawLine(
      Offset(w * 0.1, h * 0.45),
      Offset(w * 0.9, h * 0.45),
      secondaryRoadPaint,
    );

    // --- B. DRAW MARKINGS (The Spice) ---

    // Center Dashed Line (Vertical)
    double dashY = h * 0.15;
    while (dashY < h * 0.95) {
      canvas.drawLine(
        Offset(w * 0.5, dashY),
        Offset(w * 0.5, dashY + 10),
        dashPaint,
      );
      dashY += 20; // 10px line, 10px gap
    }

    // Zebra Crossings (At intersections)
    _drawZebraCrossing(
      canvas,
      Offset(w * 0.5, h * 0.43),
      width: 24,
      horizontal: true,
    ); // Hub crossing
    _drawZebraCrossing(
      canvas,
      Offset(w * 0.5, h * 0.82),
      width: 24,
      horizontal: true,
    ); // Lower crossing
  }

  void _drawZebraCrossing(
    Canvas canvas,
    Offset center, {
    required double width,
    required bool horizontal,
  }) {
    final paint = Paint()..color = Colors.white;
    double stripeW = 3;
    if (horizontal) {
      // Draw horizontal stripes
      for (double i = -width / 2; i < width / 2; i += 5) {
        canvas.drawRect(
          Rect.fromLTWH(center.dx + i, center.dy - 5, stripeW, 10),
          paint,
        );
      }
    }
  }

  void _drawDetailedBuilding(
    Canvas canvas,
    double cx,
    double cy,
    String name,
    bool isHighlighted,
  ) {
    // 1. Colors & Materials
    Color roofColor;
    Color wallColor;

    if (isHighlighted) {
      roofColor = const Color(0xFFEF5350); // Red 400
      wallColor = const Color(0xFFB71C1C); // Red 900
    } else {
      if (name.contains("Admin") || name.contains("Library")) {
        roofColor = const Color(0xFF90CAF9); // Blue 200
        wallColor = const Color(0xFF1565C0); // Blue 800
      } else if (name.contains("Center")) {
        roofColor = const Color(0xFFFFF59D); // Yellow 200
        wallColor = const Color(0xFFFBC02D); // Yellow 700
      } else if (name.contains("Sports") || name.contains("Gym")) {
        roofColor = const Color(0xFFA5D6A7); // Green 200
        wallColor = const Color(0xFF2E7D32); // Green 800
      } else {
        roofColor = const Color(0xFFEEEEEE); // Grey 200
        wallColor = const Color(0xFF616161); // Grey 700
      }
    }

    // 2. Define Shape
    Path roofPath = Path();
    Rect baseRect;
    double depth = 8.0; // Height of the "3D" wall

    if (name.contains("Auditorium")) {
      baseRect = Rect.fromCenter(center: Offset(cx, cy), width: 80, height: 50);
      roofPath.addArc(baseRect, 3.14, 3.14);
      roofPath.lineTo(baseRect.right, baseRect.bottom);
      roofPath.lineTo(baseRect.left, baseRect.bottom);
      roofPath.close();
    } else if (name.contains("Center")) {
      // Hexagon Hub
      roofPath = _createPolygon(cx, cy, 32, 6);
    } else if (name.contains("Mosque")) {
      baseRect = Rect.fromCenter(center: Offset(cx, cy), width: 35, height: 35);
      roofPath.addRect(baseRect);
    } else {
      // Standard Block
      double w = (name.contains("CS") || name.contains("Eng")) ? 65 : 55;
      baseRect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: 40);
      roofPath.addRect(baseRect);
    }

    // 3. Draw Shadow (Ground Shadow)
    canvas.drawPath(
      roofPath.shift(const Offset(6, 6)),
      Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // 4. Draw Walls (The 3D Extrusion)
    canvas.drawPath(
      roofPath.shift(Offset(0, depth)),
      Paint()..color = wallColor,
    );

    // 5. Draw Roof (Top Surface)
    canvas.drawPath(roofPath, Paint()..color = roofColor);

    // 6. Draw Roof Details (Vents/Lines/Borders) - "The Spice"
    canvas.save();
    canvas.clipPath(roofPath); // Keep details inside roof

    // --- CHANGED: Use Grey for borders and details instead of white ---
    final borderGrey = const Color(0xFF757575); // Grey 600 for the main outline
    final detailGrey = const Color(0xFFBDBDBD); // Grey 400 for inner lines
    final highlightGrey = const Color(0xFFEEEEEE); // Grey 200 for dome shine

    final detailPaint = Paint()
      ..color = detailGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw the main thick border around the roof shape
    canvas.drawPath(
      roofPath,
      Paint()
        ..color = borderGrey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    if (name.contains("Center") || name.contains("Mosque")) {
      // Dome highlight
      canvas.drawCircle(
        Offset(cx - 5, cy - 5),
        5,
        Paint()..color = highlightGrey,
      );
    } else {
      // Linear vents
      canvas.drawLine(
        Offset(cx - 10, cy - 5),
        Offset(cx + 10, cy - 5),
        detailPaint,
      );
      canvas.drawLine(
        Offset(cx - 10, cy + 5),
        Offset(cx + 10, cy + 5),
        detailPaint,
      );
    }

    canvas.restore();

    // 7. Label
    _drawLabel(canvas, cx, cy, name, isHighlighted);
  }

  Path _createPolygon(double cx, double cy, double radius, int sides) {
    final path = Path();
    var angle = (math.pi * 2) / sides;
    Offset firstPoint = Offset(
      cx + radius * math.cos(0.0),
      cy + radius * math.sin(0.0),
    );
    path.moveTo(firstPoint.dx, firstPoint.dy);
    for (int i = 1; i <= sides; i++) {
      double x = cx + radius * math.cos(angle * i);
      double y = cy + radius * math.sin(angle * i);
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  void _drawLabel(
    Canvas canvas,
    double cx,
    double cy,
    String name,
    bool isHighlighted,
  ) {
    if (name == "Sports Ground") return; // No label on the grass itself

    final textStyle = TextStyle(
      color: const Color(0xFF263238),
      fontSize: 8,
      fontWeight: FontWeight.w800,
    );

    final span = TextSpan(text: name.toUpperCase(), style: textStyle);
    final tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    final bgRect = Rect.fromCenter(
      center: Offset(cx, cy + 30),
      width: tp.width + 12,
      height: tp.height + 6,
    );

    // Shadow for label
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        bgRect.shift(const Offset(2, 2)),
        const Radius.circular(8),
      ),
      Paint()..color = Colors.black.withOpacity(0.2),
    );

    // Label BG
    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(8)),
      Paint()
        ..color = isHighlighted
            ? Colors.red[900]!
            : Colors.white.withOpacity(0.95),
    );

    if (isHighlighted) {
      final hSpan = TextSpan(
        text: name.toUpperCase(),
        style: textStyle.copyWith(color: Colors.white),
      );
      final htp = TextPainter(
        text: hSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      htp.layout();
      htp.paint(canvas, Offset(cx - htp.width / 2, cy + 30 - htp.height / 2));
    } else {
      tp.paint(canvas, Offset(cx - tp.width / 2, cy + 30 - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CampusMapPainter oldDelegate) {
    return oldDelegate.highlightLocation != highlightLocation;
  }
}
