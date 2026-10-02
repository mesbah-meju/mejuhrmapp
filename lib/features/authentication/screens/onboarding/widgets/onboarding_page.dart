import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum HrmSlideType { salesPerformance, targetsProgress, commissionGrowth }

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.slideType,
    required this.title,
    required this.subTitle,
  });

  final HrmSlideType slideType;
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Title & Subtitle Top Left (matching the reference design)
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              height: 1.25,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),

          // Main Center Visual Graphic
          Expanded(
            child: Center(
              child: _buildGraphic(context),
            ),
          ),

          const SizedBox(height: 90), // Spacing for bottom navigation
        ],
      ),
    );
  }

  Widget _buildGraphic(BuildContext context) {
    switch (slideType) {
      case HrmSlideType.salesPerformance:
        return _buildSalesPerformanceGraphic();
      case HrmSlideType.targetsProgress:
        return _buildTargetsProgressGraphic();
      case HrmSlideType.commissionGrowth:
        return _buildCommissionGrowthGraphic();
    }
  }

  // =========================================================================
  // SLIDE 1: SALES PERFORMANCE GRAPHIC
  // =========================================================================
  Widget _buildSalesPerformanceGraphic() {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft Mint Radial Backdrop
          Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFD1FAE5).withValues(alpha: 0.8),
                  const Color(0xFFECFDF5).withValues(alpha: 0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.65, 1.0],
              ),
            ),
          ),

          // Main Sales Card
          Container(
            width: 270,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF059669).withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.bar_chart_rounded, color: Color(0xFF059669), size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Sales", style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          SizedBox(height: 2),
                          Text("৳ 2,48,600", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_upward_rounded, size: 11, color: Color(0xFF059669)),
                          SizedBox(width: 2),
                          Text("18%", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Smooth Upward Chart
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _SalesChartPainter(),
                  ),
                ),
              ],
            ),
          ),

          // Floating Trending Up Pill (Bottom Right)
          Positioned(
            right: 12,
            bottom: 36,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF059669).withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.trending_up_rounded, color: Color(0xFF059669), size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SLIDE 2: TARGETS & PROGRESS GRAPHIC
  // =========================================================================
  Widget _buildTargetsProgressGraphic() {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft Mint Radial Backdrop
          Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFD1FAE5).withValues(alpha: 0.8),
                  const Color(0xFFECFDF5).withValues(alpha: 0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.65, 1.0],
              ),
            ),
          ),

          // Center Concentric Target Dartboard
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF059669).withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CustomPaint(
              painter: _DartboardPainter(),
            ),
          ),

          // Floating Card Top-Left: Target 80%
          Positioned(
            left: 14,
            top: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Iconsax.radar, size: 18, color: Color(0xFF059669)),
                  SizedBox(height: 6),
                  Text("Target", style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                  Text("80%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                ],
              ),
            ),
          ),

          // Floating Card Bottom-Right: Achieved 75%
          Positioned(
            right: 14,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF059669),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Achieved", style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                      Text("75%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SLIDE 3: COMMISSION & TEAM GROWTH GRAPHIC
  // =========================================================================
  Widget _buildCommissionGrowthGraphic() {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Ascending Columns & Trend Curve
          Positioned(
            right: 10,
            bottom: 10,
            child: SizedBox(
              width: 250,
              height: 160,
              child: CustomPaint(
                painter: _GrowthColumnsPainter(),
              ),
            ),
          ),

          // Main Foreground Leaderboard Card
          Positioned(
            left: 10,
            top: 20,
            child: Container(
              width: 240,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF059669).withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with Crown & Team Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.workspace_premium_rounded, size: 20, color: Color(0xFFFBBF24)),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.groups_rounded, size: 16, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Leaderboard Item 1
                  _buildLeaderboardRow("1", "Rahim", "৳ 48,200", 0.9, const Color(0xFF059669)),
                  const SizedBox(height: 10),

                  // Leaderboard Item 2
                  _buildLeaderboardRow("2", "Tanvir", "৳ 36,400", 0.7, const Color(0xFF10B981)),
                  const SizedBox(height: 10),

                  // Leaderboard Item 3
                  _buildLeaderboardRow("3", "Nishat", "৳ 28,600", 0.55, const Color(0xFF34D399)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardRow(String rank, String name, String amount, double progress, Color barColor) {
    return Row(
      children: [
        Text(
          rank,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF64748B)),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 11,
          backgroundColor: const Color(0xFFEFF6FF),
          child: Text(
            name[0],
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFF1F5F9),
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
      ],
    );
  }
}

// ===========================================================================
// CUSTOM PAINTERS FOR PIXEL-PERFECT GRAPHICS
// ===========================================================================

class _SalesChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Grid bars
    final barPaint = Paint()
      ..color = const Color(0xFFE2E8F0).withValues(alpha: 0.5)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 3; i++) {
      final y = height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(width, y), barPaint);
    }

    // Chart fill gradient
    final fillPath = Path();
    fillPath.moveTo(0, height * 0.85);
    fillPath.quadraticBezierTo(width * 0.3, height * 0.75, width * 0.5, height * 0.5);
    fillPath.quadraticBezierTo(width * 0.75, height * 0.35, width, height * 0.15);
    fillPath.lineTo(width, height);
    fillPath.lineTo(0, height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF10B981).withValues(alpha: 0.25),
          const Color(0xFF34D399).withValues(alpha: 0.02),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // Chart stroke line
    final linePath = Path();
    linePath.moveTo(0, height * 0.85);
    linePath.quadraticBezierTo(width * 0.3, height * 0.75, width * 0.5, height * 0.5);
    linePath.quadraticBezierTo(width * 0.75, height * 0.35, width, height * 0.15);

    final linePaint = Paint()
      ..color = const Color(0xFF059669)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Indicator node dot at top right
    final dotPoint = Offset(width, height * 0.15);
    canvas.drawCircle(dotPoint, 4.5, Paint()..color = const Color(0xFF059669));
    canvas.drawCircle(dotPoint, 4.5, Paint()..color = Colors.white..strokeWidth = 2..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DartboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final rings = [
      {'r': radius * 0.95, 'color': const Color(0xFF059669)},
      {'r': radius * 0.72, 'color': Colors.white},
      {'r': radius * 0.50, 'color': const Color(0xFF10B981)},
      {'r': radius * 0.28, 'color': Colors.white},
      {'r': radius * 0.12, 'color': const Color(0xFF047857)},
    ];

    for (var ring in rings) {
      final paint = Paint()
        ..color = ring['color'] as Color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, ring['r'] as double, paint);
    }

    // Dart hitting bullseye
    final dartPaint = Paint()
      ..color = const Color(0xFF065F46)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dartEnd = center;
    final dartStart = Offset(size.width * 0.9, size.height * 0.1);
    canvas.drawLine(dartStart, dartEnd, dartPaint);

    // Dart Flights
    final flightPaint = Paint()
      ..color = const Color(0xFF059669)
      ..style = PaintingStyle.fill;

    final flightPath = Path();
    flightPath.moveTo(dartStart.dx, dartStart.dy);
    flightPath.lineTo(dartStart.dx - 14, dartStart.dy + 3);
    flightPath.lineTo(dartStart.dx - 8, dartStart.dy - 8);
    flightPath.close();
    canvas.drawPath(flightPath, flightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GrowthColumnsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final columnWidth = 18.0;
    final gap = 12.0;
    final startX = width * 0.2;

    final heights = [height * 0.35, height * 0.52, height * 0.70, height * 0.90];

    for (int i = 0; i < heights.length; i++) {
      final x = startX + i * (columnWidth + gap);
      final colH = heights[i];
      final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, height - colH, columnWidth, colH),
        const Radius.circular(5),
      );

      final colPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFF34D399).withValues(alpha: 0.7),
            const Color(0xFF6EE7B7).withValues(alpha: 0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(x, height - colH, columnWidth, colH));

      canvas.drawRRect(rRect, colPaint);
    }

    // Upward trend line
    final trendPaint = Paint()
      ..color = const Color(0xFF059669)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final trendPath = Path();
    trendPath.moveTo(0, height * 0.95);
    trendPath.quadraticBezierTo(width * 0.5, height * 0.75, width * 0.95, height * 0.15);
    canvas.drawPath(trendPath, trendPaint);

    final node = Offset(width * 0.95, height * 0.15);
    canvas.drawCircle(node, 4.5, Paint()..color = const Color(0xFF059669));
    canvas.drawCircle(node, 4.5, Paint()..color = Colors.white..strokeWidth = 2..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
