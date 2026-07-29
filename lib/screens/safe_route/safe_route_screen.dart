import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../mock_data/mock_data.dart';
import '../../widgets/route_card.dart';

// ─── SafeRouteScreen ──────────────────────────────────────────────────────────
// Shows route options ranked by safety score.
// Mock data from MockData.suggestedRoutes.
//
// FUTURE INTEGRATION:
//   When the user fills pickup + destination and taps "Find Safe Routes":
//     1. Call Spring Boot /api/routes/suggest?from=...&to=...
//     2. Pass real coordinates obtained from geolocator / geocoding
//     3. The backend computes safety scores and returns RouteModel list
//     4. Replace the static MockData.suggestedRoutes with that response

class SafeRouteScreen extends StatefulWidget {
  const SafeRouteScreen({super.key});

  @override
  State<SafeRouteScreen> createState() => _SafeRouteScreenState();
}

class _SafeRouteScreenState extends State<SafeRouteScreen> {
  final _fromController = TextEditingController(text: MockData.currentLocationLabel);
  final _toController = TextEditingController();
  int _selectedRouteIndex = 0;
  bool _hasSearched = false;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _findRoutes() {
    if (_toController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a destination.')),
      );
      return;
    }
    // In a real app: call ApiService.fetchRoutes(from, to)
    // For now just reveal the mock results
    setState(() => _hasSearched = true);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Safe Route'),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search card ──────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // From field
                  _RouteInputField(
                    icon: Icons.trip_origin,
                    iconColor: AppColors.primary,
                    hint: 'Pickup / Current Location',
                    controller: _fromController,
                  ),
                  // Connector line
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 1,
                          height: 20,
                          color: AppColors.divider,
                        ),
                      ],
                    ),
                  ),
                  // To field
                  _RouteInputField(
                    icon: Icons.location_on,
                    iconColor: AppColors.accent,
                    hint: 'Enter Destination',
                    controller: _toController,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: _findRoutes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.search, size: 18),
                      label: const Text(
                        'Find Safe Routes',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_hasSearched) ...[
              const SizedBox(height: 24),

              // ── Safety info banner ─────────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Safety scores are calculated based on community reports, lighting data, and historical safety records.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.info,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Available Routes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${MockData.suggestedRoutes.length} routes found — sorted by safety',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 14),

              // ── Route list ─────────────────────────────────────────────────
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MockData.suggestedRoutes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) => RouteCard(
                  route: MockData.suggestedRoutes[i],
                  isSelected: _selectedRouteIndex == i,
                  onTap: () => setState(() => _selectedRouteIndex = i),
                ),
              ),

              const SizedBox(height: 20),

              // ── Start navigation button ────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.map);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.safeGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.navigation, size: 20),
                  label: const Text(
                    'Start Navigation',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.route,
                      size: 72,
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Enter your destination above\nto find safe routes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _RouteInputField extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String hint;
  final TextEditingController controller;
  const _RouteInputField({
    required this.icon,
    required this.iconColor,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  fontSize: 14, color: AppColors.textMuted),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            ),
          ),
        ),
      ],
    );
  }
}
