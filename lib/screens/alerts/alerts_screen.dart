import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../mock_data/mock_data.dart';
import '../../models/safety_alert_model.dart';
import '../../widgets/safety_card.dart';

// ─── AlertsScreen ─────────────────────────────────────────────────────────────
// Displays nearby safety alerts from mock data.
//
// FUTURE INTEGRATION:
//   GET /api/alerts/nearby?lat=...&lng=...&radius=2000
//   Pass user's real GPS coordinates to get location-relevant alerts.

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  AlertSeverity? _filterSeverity;

  List<SafetyAlertModel> get _filtered {
    if (_filterSeverity == null) return MockData.nearbyAlerts;
    return MockData.nearbyAlerts
        .where((a) => a.severity == _filterSeverity)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Safety Alerts'),
      ),
      body: Column(
        children: [
          // ── Filter chips ────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _filterSeverity == null,
                  color: AppColors.primary,
                  onTap: () => setState(() => _filterSeverity = null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'High Risk',
                  isSelected: _filterSeverity == AlertSeverity.high,
                  color: AppColors.highRiskRed,
                  onTap: () => setState(() =>
                      _filterSeverity = AlertSeverity.high),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Medium Risk',
                  isSelected: _filterSeverity == AlertSeverity.medium,
                  color: AppColors.moderateOrange,
                  onTap: () => setState(() =>
                      _filterSeverity = AlertSeverity.medium),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Low Risk',
                  isSelected: _filterSeverity == AlertSeverity.low,
                  color: AppColors.safeGreen,
                  onTap: () => setState(
                      () => _filterSeverity = AlertSeverity.low),
                ),
              ],
            ),
          ),

          // ── Alert count ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} alert${_filtered.length == 1 ? '' : 's'} near you',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.near_me, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                const Text(
                  'Within 2 km',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── List ───────────────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text('No alerts found for this filter.',
                        style: TextStyle(color: AppColors.textMuted)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, i) => SafetyAlertCard(
                      alert: _filtered[i],
                      onTap: () => _showAlertDetail(context, _filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showAlertDetail(BuildContext context, SafetyAlertModel alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AlertDetailSheet(alert: alert),
    );
  }
}

// ─── Alert detail bottom sheet ────────────────────────────────────────────────
class _AlertDetailSheet extends StatelessWidget {
  final SafetyAlertModel alert;
  const _AlertDetailSheet({required this.alert});

  Color get _color {
    switch (alert.severity) {
      case AlertSeverity.low:
        return AppColors.safeGreen;
      case AlertSeverity.medium:
        return AppColors.moderateOrange;
      case AlertSeverity.high:
        return AppColors.highRiskRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  alert.severity.label,
                  style: TextStyle(
                    color: _color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                alert.location,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            alert.description,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close'),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ─── Filter chip ──────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
