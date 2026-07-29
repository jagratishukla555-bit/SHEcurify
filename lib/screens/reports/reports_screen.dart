import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../mock_data/mock_data.dart';
import '../../models/safety_report_model.dart';
import '../../services/api_service.dart';
import '../../widgets/safety_card.dart';

// ─── ReportsScreen ────────────────────────────────────────────────────────────
// Shows recent community safety reports and allows submitting new ones.
//
// FUTURE INTEGRATION:
//   GET  /api/reports?page=0&size=20 → load reports list
//   POST /api/reports                → submit new report (with optional image)

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _reports = List.from(MockData.recentReports);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Safety Reports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Community Reports'),
            Tab(text: 'Submit Report'),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ReportsList(reports: _reports.cast<SafetyReportModel>()),
          _SubmitReportForm(
            onSubmitted: (report) {
              setState(() {
                _reports.insert(0, report);
                _tabController.animateTo(0);
              });
            },
          ),
        ],
      ),
    );
  }
}

// ─── Reports List Tab ─────────────────────────────────────────────────────────
class _ReportsList extends StatelessWidget {
  final List<SafetyReportModel> reports;
  const _ReportsList({required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const Center(
        child: Text('No reports yet.',
            style: TextStyle(color: AppColors.textMuted)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => SafetyReportCard(report: reports[i]),
    );
  }
}

// ─── Submit Report Tab ────────────────────────────────────────────────────────
class _SubmitReportForm extends StatefulWidget {
  final void Function(SafetyReportModel) onSubmitted;
  const _SubmitReportForm({required this.onSubmitted});

  @override
  State<_SubmitReportForm> createState() => _SubmitReportFormState();
}

class _SubmitReportFormState extends State<_SubmitReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _locationCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  ReportCategory _selectedCategory = ReportCategory.poorLighting;
  bool _isLoading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _locationCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await ApiService.submitReport(
      category: _selectedCategory.name,
      location: _locationCtrl.text.trim(),
      description: _descCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _submitted = success;
    });

    if (success) {
      final newReport = SafetyReportModel(
        id: 'rpt-${DateTime.now().millisecondsSinceEpoch}',
        category: _selectedCategory,
        location: _locationCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        reportedAt: DateTime.now(),
        isVerified: false,
      );
      widget.onSubmitted(newReport);
    }
  }

  void _resetForm() {
    _locationCtrl.clear();
    _descCtrl.clear();
    setState(() {
      _selectedCategory = ReportCategory.poorLighting;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return _SuccessState(onReset: _resetForm);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Location ──────────────────────────────────────────────────
            const _FieldLabel('Location'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _locationCtrl,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter the location'
                  : null,
              decoration: _inputDecor(
                'e.g. Main Road near Bus Stop',
                Icons.location_on_outlined,
              ),
            ),

            const SizedBox(height: 18),

            // ── Category ──────────────────────────────────────────────────
            const _FieldLabel('Report Category'),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: ReportCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return InkWell(
                    onTap: () =>
                        setState(() => _selectedCategory = cat),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryLight.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(cat.icon,
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              cat.label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle,
                                color: AppColors.primary, size: 20),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 18),

            // ── Description ───────────────────────────────────────────────
            const _FieldLabel('Description'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _descCtrl,
              maxLines: 4,
              maxLength: AppConstants.maxDescriptionLength,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please describe what you observed'
                  : null,
              decoration: _inputDecor(
                'Describe the safety concern in detail…',
                null,
              ).copyWith(prefixIcon: null),
            ),

            const SizedBox(height: 12),

            // ── Image placeholder ─────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.divider, style: BorderStyle.solid),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 32, color: AppColors.textMuted),
                  SizedBox(height: 6),
                  Text(
                    'Add Photo (optional)',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                  Text(
                    'Photo upload available after backend integration',
                    style: TextStyle(
                        fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.flag, size: 18),
                label: Text(
                  _isLoading ? 'Submitting…' : AppStrings.submitReport,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecor(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      filled: true,
      fillColor: AppColors.surfaceVariant,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}

// ─── Success state ────────────────────────────────────────────────────────────
class _SuccessState extends StatelessWidget {
  final VoidCallback onReset;
  const _SuccessState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: AppColors.safeGreenLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  size: 50, color: AppColors.safeGreen),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.reportSuccess,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              AppStrings.reportSuccessBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Submit Another Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Field label ──────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}

