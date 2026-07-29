import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

// ─── SettingsScreen ───────────────────────────────────────────────────────────
// All settings presented in grouped, clean sections.
// All toggles are local state only for now.
//
// FUTURE INTEGRATION:
//   Load preferences from Spring Boot /api/users/preferences (or SharedPrefs)
//   Save changes via PATCH /api/users/preferences

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ── Notification preferences ─────────────────────────────────────────────
  bool _pushNotifications = true;
  bool _sosAlerts = true;
  bool _nearbyAlerts = true;
  bool _communityReports = false;

  // ── Location preferences ──────────────────────────────────────────────────
  bool _locationAlwaysOn = false;
  bool _shareLocationSos = true;
  bool _backgroundLocation = false;

  // ── Emergency preferences ─────────────────────────────────────────────────
  bool _autoSosCountdown = true;
  bool _notifyVolunteers = true;
  bool _shareWithEmergencyServices = false;

  // ── Privacy ───────────────────────────────────────────────────────────────
  bool _anonymousReporting = false;
  bool _dataSharingCommunity = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Notifications ─────────────────────────────────────────────
          _SettingSection(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            children: [
              _ToggleItem(
                label: 'Push Notifications',
                subtitle: 'Receive app notifications',
                value: _pushNotifications,
                onChanged: (v) =>
                    setState(() => _pushNotifications = v),
              ),
              _ToggleItem(
                label: 'SOS Alerts',
                subtitle: 'Notifications when someone near you triggers SOS',
                value: _sosAlerts,
                onChanged: (v) => setState(() => _sosAlerts = v),
              ),
              _ToggleItem(
                label: 'Nearby Safety Alerts',
                subtitle: 'Alerts about safety risks near your location',
                value: _nearbyAlerts,
                onChanged: (v) => setState(() => _nearbyAlerts = v),
              ),
              _ToggleItem(
                label: 'Community Reports',
                subtitle: 'Notifications when new reports are submitted nearby',
                value: _communityReports,
                onChanged: (v) =>
                    setState(() => _communityReports = v),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Location ──────────────────────────────────────────────────
          _SettingSection(
            title: 'Location',
            icon: Icons.location_on_outlined,
            children: [
              _ToggleItem(
                label: 'Always-On Location',
                subtitle: 'Allow SHEcurify to access your location at all times',
                value: _locationAlwaysOn,
                onChanged: (v) =>
                    setState(() => _locationAlwaysOn = v),
              ),
              _ToggleItem(
                label: 'Share Location During SOS',
                subtitle: 'Automatically share location when SOS is activated',
                value: _shareLocationSos,
                onChanged: (v) =>
                    setState(() => _shareLocationSos = v),
              ),
              _ToggleItem(
                label: 'Background Location',
                subtitle: 'Required for proactive safety alerts',
                value: _backgroundLocation,
                onChanged: (v) =>
                    setState(() => _backgroundLocation = v),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Emergency ─────────────────────────────────────────────────
          _SettingSection(
            title: 'Emergency Preferences',
            icon: Icons.emergency_outlined,
            children: [
              _ToggleItem(
                label: 'Auto-SOS Countdown',
                subtitle:
                    'Show a 5-second countdown before activating SOS',
                value: _autoSosCountdown,
                onChanged: (v) =>
                    setState(() => _autoSosCountdown = v),
              ),
              _ToggleItem(
                label: 'Notify Nearby Volunteers',
                subtitle: 'Alert verified volunteers in your area during SOS',
                value: _notifyVolunteers,
                onChanged: (v) =>
                    setState(() => _notifyVolunteers = v),
              ),
              _ToggleItem(
                label: 'Alert Emergency Services',
                subtitle:
                    'Automatically notify emergency services (coming soon)',
                value: _shareWithEmergencyServices,
                onChanged: (v) =>
                    setState(() => _shareWithEmergencyServices = v),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Privacy ───────────────────────────────────────────────────
          _SettingSection(
            title: 'Privacy',
            icon: Icons.privacy_tip_outlined,
            children: [
              _ToggleItem(
                label: 'Anonymous Reporting',
                subtitle: 'Submit safety reports without revealing your identity',
                value: _anonymousReporting,
                onChanged: (v) =>
                    setState(() => _anonymousReporting = v),
              ),
              _ToggleItem(
                label: 'Share Data with Community',
                subtitle: 'Help improve safety scores for your area',
                value: _dataSharingCommunity,
                onChanged: (v) =>
                    setState(() => _dataSharingCommunity = v),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── About ─────────────────────────────────────────────────────
          _SettingSection(
            title: 'About',
            icon: Icons.info_outline,
            children: [
              _TapItem(
                label: 'About SHEcurify',
                onTap: () {},
              ),
              _TapItem(
                label: 'Terms of Service',
                onTap: () {},
              ),
              _TapItem(
                label: 'Privacy Policy',
                onTap: () {},
              ),
              _TapItem(
                label: 'Version',
                trailing: '1.0.0 (UI Prototype)',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Danger zone ───────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                _TapItem(
                  label: 'Sign Out',
                  isDestructive: true,
                  onTap: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoutes.login, (_) => false),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Section wrapper ──────────────────────────────────────────────────────────
class _SettingSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: children.asMap().entries.map((e) {
              final isLast = e.key == children.length - 1;
              return Column(
                children: [
                  e.value,
                  if (!isLast)
                    const Divider(
                        height: 1, indent: 16, color: AppColors.divider),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─── Toggle item ──────────────────────────────────────────────────────────────
class _ToggleItem extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleItem({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primaryLight,
          ),
        ],
      ),
    );
  }
}

// ─── Tap item ─────────────────────────────────────────────────────────────────
class _TapItem extends StatelessWidget {
  final String label;
  final String? trailing;
  final bool isDestructive;
  final VoidCallback onTap;

  const _TapItem({
    required this.label,
    this.trailing,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDestructive
                      ? AppColors.error
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing!,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.chevron_right,
              size: 20,
              color: isDestructive
                  ? AppColors.error
                  : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
