import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/safety_alert_model.dart';
import '../models/safety_report_model.dart';

// ─── SafetyCard ───────────────────────────────────────────────────────────────
// Displays a safety alert or report in a consistent card format.

class SafetyAlertCard extends StatelessWidget {
  final SafetyAlertModel alert;
  final VoidCallback? onTap;

  const SafetyAlertCard({super.key, required this.alert, this.onTap});

  Color get _severityColor {
    switch (alert.severity) {
      case AlertSeverity.low:
        return AppColors.safeGreen;
      case AlertSeverity.medium:
        return AppColors.moderateOrange;
      case AlertSeverity.high:
        return AppColors.highRiskRed;
    }
  }

  Color get _severityBg {
    switch (alert.severity) {
      case AlertSeverity.low:
        return AppColors.safeGreenLight;
      case AlertSeverity.medium:
        return AppColors.moderateOrangeLight;
      case AlertSeverity.high:
        return AppColors.highRiskRedLight;
    }
  }

  IconData get _severityIcon {
    switch (alert.severity) {
      case AlertSeverity.low:
        return Icons.info_outline;
      case AlertSeverity.medium:
        return Icons.warning_amber_outlined;
      case AlertSeverity.high:
        return Icons.dangerous_outlined;
    }
  }

  String get _timeAgo {
    final diff = DateTime.now().difference(alert.reportedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _severityBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_severityIcon, color: _severityColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: _severityBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          alert.severity.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _severityColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    alert.location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (alert.distanceKm != null) ...[
                        const Icon(Icons.near_me,
                            size: 11, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text(
                          '${alert.distanceKm!.toStringAsFixed(1)} km away  ·  ',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                      Text(
                        _timeAgo,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SafetyReportCard ─────────────────────────────────────────────────────────
class SafetyReportCard extends StatelessWidget {
  final SafetyReportModel report;
  final VoidCallback? onTap;

  const SafetyReportCard({super.key, required this.report, this.onTap});

  String get _timeAgo {
    final diff = DateTime.now().difference(report.reportedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  report.category.icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          report.category.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (report.isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.safeGreenLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.safeGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    report.location,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    report.description,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _timeAgo,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
