import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/route_model.dart';

// ─── RouteCard ────────────────────────────────────────────────────────────────
// Displays a single route option with safety badge, distance, and time.

class RouteCard extends StatelessWidget {
  final RouteModel route;
  final bool isSelected;
  final VoidCallback? onTap;

  const RouteCard({
    super.key,
    required this.route,
    this.isSelected = false,
    this.onTap,
  });

  Color get _safetyColor {
    switch (route.safetyLevel) {
      case SafetyLevel.low:
        return AppColors.safeGreen;
      case SafetyLevel.moderate:
        return AppColors.moderateOrange;
      case SafetyLevel.high:
        return AppColors.highRiskRed;
    }
  }

  Color get _safetyBg {
    switch (route.safetyLevel) {
      case SafetyLevel.low:
        return AppColors.safeGreenLight;
      case SafetyLevel.moderate:
        return AppColors.moderateOrangeLight;
      case SafetyLevel.high:
        return AppColors.highRiskRedLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        route.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (route.isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _safetyBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    route.safetyLevel.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _safetyColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Safety score bar
            Row(
              children: [
                const Text(
                  'Safety Score',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: route.safetyScore / 100,
                      backgroundColor: AppColors.divider,
                      color: _safetyColor,
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${route.safetyScore}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _safetyColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.access_time,
                  label: '${route.estimatedMinutes} min',
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.straighten,
                  label: '${route.distanceKm} km',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              route.description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
