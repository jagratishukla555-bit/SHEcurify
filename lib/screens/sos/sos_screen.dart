import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../mock_data/mock_data.dart';
import '../../services/api_service.dart';

// ─── SosScreen ────────────────────────────────────────────────────────────────
// Three-state flow:
//   1. Confirmation dialog state
//   2. Active SOS state (with timer, contact status list)
//   3. Resolved state
//
// FUTURE INTEGRATION:
//   On SOS activate → call ApiService.triggerSos(lat, lng)
//   The Spring Boot backend will then:
//     • Store the SOS event in MySQL
//     • Send SMS/Push notifications to trusted contacts
//     • Broadcast location to nearby verified volunteers
//     • Stream live location updates via WebSocket

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

enum _SosState { confirm, active, resolved }

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  _SosState _state = _SosState.confirm;
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool _locationSharing = false;
  bool _contactsNotified = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.97, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _activateSos() async {
    setState(() {
      _state = _SosState.active;
      _elapsedSeconds = 0;
    });

    // Simulate backend calls with progressive state updates
    await ApiService.triggerSos(12.9716, 77.5946);

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _locationSharing = true);

    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _contactsNotified = true);

    // Start elapsed timer
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  void _resolveSos() {
    _timer?.cancel();
    setState(() => _state = _SosState.resolved);
  }

  String get _formattedTime {
    final m = _elapsedSeconds ~/ 60;
    final s = _elapsedSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<bool> _onBackPressed() async {
    // Prevent accidental back-press when SOS is active
    if (_state == _SosState.active) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('SOS is Active'),
          content: const Text(
              'Are you safe? Tap "I\'m Safe" to resolve the emergency first.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                _resolveSos();
                Navigator.pop(ctx, true);
              },
              child: const Text("I'm Safe",
                  style: TextStyle(color: AppColors.safeGreen)),
            ),
          ],
        ),
      );
      return confirmed ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: false means we handle back ourselves via onPopInvoked
      canPop: _state != _SosState.active,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _state == _SosState.active) {
          final nav = Navigator.of(context);
          _onBackPressed().then((allowed) {
            if (allowed && mounted) nav.pop();
          });
        }
      },
      child: Scaffold(
        backgroundColor: _state == _SosState.active
            ? const Color(0xFF1A0000)
            : AppColors.background,
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _SosState.confirm:
        return _buildConfirm();
      case _SosState.active:
        return _buildActive();
      case _SosState.resolved:
        return _buildResolved();
    }
  }

  // ── STEP 1: Confirmation ───────────────────────────────────────────────────
  Widget _buildConfirm() {
    return Padding(
      key: const ValueKey('confirm'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Spacer(),
          // SOS icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3), width: 2),
            ),
            child: const Icon(Icons.emergency, size: 60, color: AppColors.sos),
          ),
          const SizedBox(height: 32),
          const Text(
            AppStrings.sosConfirmTitle,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppStrings.sosConfirmBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Show contacts that will be notified
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contacts who will be notified:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...MockData.trustedContacts.map(
                  (c) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor:
                              AppColors.primaryLight.withValues(alpha: 0.2),
                          child: Text(
                            c.initials,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${c.name} (${c.relationship})',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          c.phone,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Buttons
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _activateSos,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sos,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                AppStrings.sosActivate,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.divider),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(AppStrings.sosCancel),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── STEP 2: Active SOS ─────────────────────────────────────────────────────
  Widget _buildActive() {
    return Padding(
      key: const ValueKey('active'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // SOS pulsing circle
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnim.value,
              child: child,
            ),
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sos.withValues(alpha: 0.15),
                border: Border.all(
                    color: AppColors.sos.withValues(alpha: 0.4), width: 3),
              ),
              child: const Center(
                child: Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            AppStrings.sosActiveTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.sosActiveSubtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          // Timer
          Text(
            _formattedTime,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.sosLight.withValues(alpha: 0.9),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 28),

          // Status indicators
          _StatusRow(
            icon: Icons.location_on,
            label: AppStrings.sosLocationSharing,
            isActive: _locationSharing,
          ),
          const SizedBox(height: 12),
          _StatusRow(
            icon: Icons.people,
            label: AppStrings.sosContactsNotified,
            isActive: _contactsNotified,
          ),
          const SizedBox(height: 12),
          _StatusRow(
            icon: Icons.volunteer_activism,
            label: 'Notifying nearby volunteers…',
            isActive: _contactsNotified,
          ),

          const Spacer(),

          Text(
            'Your location: ${MockData.currentLocationLabel}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          // Resolve button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _resolveSos,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.safeGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 22),
              label: const Text(
                "I'm Safe – Resolve Emergency",
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── STEP 3: Resolved ───────────────────────────────────────────────────────
  Widget _buildResolved() {
    return Padding(
      key: const ValueKey('resolved'),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.safeGreenLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 56,
              color: AppColors.safeGreen,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Emergency Resolved',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Glad you're safe. Your contacts have been notified that the emergency is over.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Return to Home',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Status row widget ────────────────────────────────────────────────────────
class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _StatusRow({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.safeGreen.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: isActive
              ? const Icon(Icons.check, color: AppColors.safeGreen, size: 18)
              : SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isActive
                ? AppColors.safeGreen
                : Colors.white.withValues(alpha: 0.6),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
