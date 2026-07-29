import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../mock_data/mock_data.dart';

// ─── MapScreen ────────────────────────────────────────────────────────────────
// Placeholder map screen. Uses a CustomPainter mock map.
//
// FUTURE INTEGRATION:
//   Replace the CustomPaint with flutter_map + OpenStreetMap:
//
//   FlutterMap(
//     options: MapOptions(center: LatLng(lat, lng), zoom: 15),
//     children: [
//       TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
//       MarkerLayer(markers: [...]),
//     ],
//   )
//
//   Also add location_permission from permission_handler and
//   geolocator for real device position.

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _zoomLevel = 1.0;
  bool _showRoutePreview = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Map & Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers_outlined),
            onPressed: () {},
            tooltip: 'Map layers',
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Map area ───────────────────────────────────────────────────────
          Positioned.fill(
            child: GestureDetector(
              onScaleUpdate: (details) {
                setState(() {
                  _zoomLevel =
                      (_zoomLevel * details.scale).clamp(0.5, 3.0);
                });
              },
              child: CustomPaint(
                painter: _FullMapPainter(zoomLevel: _zoomLevel),
                child: Container(),
              ),
            ),
          ),

          // ── Current location pin ───────────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_pin_circle,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Text(
                    'You are here',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Alert markers ─────────────────────────────────────────────────
          const Positioned(
            top: 80,
            left: 60,
            child: _AlertMarker(
              label: 'Poor Lighting',
              severity: _MarkerSeverity.medium,
            ),
          ),
          const Positioned(
            top: 160,
            right: 80,
            child: _AlertMarker(
              label: 'Unsafe Area',
              severity: _MarkerSeverity.high,
            ),
          ),
          const Positioned(
            bottom: 200,
            left: 100,
            child: _AlertMarker(
              label: 'Isolated Zone',
              severity: _MarkerSeverity.high,
            ),
          ),

          // ── Bottom controls panel ──────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x15000000),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Location',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              MockData.currentLocationLabel,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(
                              () => _showRoutePreview = !_showRoutePreview);
                          Navigator.of(context)
                              .pushNamed(AppRoutes.safeRoute);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                        icon: const Icon(Icons.route, size: 16),
                        label: const Text(
                          'Safe Route',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Safety legend
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _LegendItem(color: AppColors.safeGreen, label: 'Safe'),
                      _LegendItem(
                          color: AppColors.moderateOrange, label: 'Moderate'),
                      _LegendItem(
                          color: AppColors.highRiskRed, label: 'High Risk'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Zoom controls ─────────────────────────────────────────────────
          Positioned(
            right: 12,
            top: 80,
            child: Column(
              children: [
                _MapControlButton(
                  icon: Icons.add,
                  onTap: () => setState(
                      () => _zoomLevel = (_zoomLevel + 0.2).clamp(0.5, 3.0)),
                ),
                const SizedBox(height: 4),
                _MapControlButton(
                  icon: Icons.remove,
                  onTap: () => setState(
                      () => _zoomLevel = (_zoomLevel - 0.2).clamp(0.5, 3.0)),
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.my_location,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Map helpers ──────────────────────────────────────────────────────────────

enum _MarkerSeverity { medium, high }

class _AlertMarker extends StatelessWidget {
  final String label;
  final _MarkerSeverity severity;

  const _AlertMarker({required this.label, required this.severity});

  @override
  Widget build(BuildContext context) {
    final color = severity == _MarkerSeverity.high
        ? AppColors.highRiskRed
        : AppColors.moderateOrange;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.warning_amber, color: Colors.white, size: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MapControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style:
              const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ─── Full map painter ─────────────────────────────────────────────────────────
class _FullMapPainter extends CustomPainter {
  final double zoomLevel;
  const _FullMapPainter({required this.zoomLevel});

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFD4E9F7),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFFB8D9EF)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final step = 30.0 * zoomLevel;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10 * zoomLevel.clamp(0.5, 1.5)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Horizontal road
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      roadPaint,
    );
    // Vertical road
    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.4, size.height),
      roadPaint,
    );

    // Safe zone highlight
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.2,
          size.width * 0.35, size.height * 0.3),
      Paint()..color = AppColors.safeGreen.withValues(alpha: 0.1),
    );

    // Unsafe zone highlight
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.6, size.height * 0.55,
          size.width * 0.35, size.height * 0.35),
      Paint()..color = AppColors.highRiskRed.withValues(alpha: 0.1),
    );
  }

  @override
  bool shouldRepaint(covariant _FullMapPainter old) =>
      old.zoomLevel != zoomLevel;
}
