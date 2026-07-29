import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../mock_data/mock_data.dart';
import '../../models/trusted_contact_model.dart';

// ─── TrustedContactsScreen ────────────────────────────────────────────────────
// Lists, adds, edits, and deletes trusted contacts.
// Uses local state only for now.
//
// FUTURE INTEGRATION:
//   GET    /api/contacts       → load list
//   POST   /api/contacts       → add contact
//   PUT    /api/contacts/{id}  → update contact
//   DELETE /api/contacts/{id}  → remove contact

class TrustedContactsScreen extends StatefulWidget {
  const TrustedContactsScreen({super.key});

  @override
  State<TrustedContactsScreen> createState() => _TrustedContactsScreenState();
}

class _TrustedContactsScreenState extends State<TrustedContactsScreen> {
  late List<TrustedContactModel> _contacts;

  @override
  void initState() {
    super.initState();
    // Clone mock data into local mutable list
    _contacts = List.from(MockData.trustedContacts);
  }

  void _showAddEditDialog({TrustedContactModel? contact}) {
    final isEditing = contact != null;
    final nameCtrl =
        TextEditingController(text: isEditing ? contact.name : '');
    final relCtrl = TextEditingController(
        text: isEditing ? contact.relationship : '');
    final phoneCtrl =
        TextEditingController(text: isEditing ? contact.phone : '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Contact' : 'Add Trusted Contact'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogField(label: 'Full Name', controller: nameCtrl),
              const SizedBox(height: 12),
              _DialogField(
                  label: 'Relationship (e.g. Sister)', controller: relCtrl),
              const SizedBox(height: 12),
              _DialogField(
                label: 'Phone Number',
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  if (isEditing) {
                    final idx =
                        _contacts.indexWhere((c) => c.id == contact.id);
                    if (idx != -1) {
                      _contacts[idx] = contact.copyWith(
                        name: nameCtrl.text.trim(),
                        relationship: relCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                      );
                    }
                  } else {
                    _contacts.add(TrustedContactModel(
                      id: 'tc-${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text.trim(),
                      relationship: relCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                      priority: _contacts.length + 1,
                    ));
                  }
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(isEditing ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _deleteContact(TrustedContactModel contact) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Contact?'),
        content: Text(
            'Remove ${contact.name} from your trusted contacts?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _contacts.removeWhere((c) => c.id == contact.id));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trusted Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: _showAddEditDialog,
            tooltip: 'Add contact',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Info banner ──────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline,
                    color: AppColors.primary, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'These contacts will be notified instantly when you activate an SOS alert.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Contact list ─────────────────────────────────────────────────
          Expanded(
            child: _contacts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64, color: AppColors.divider),
                        SizedBox(height: 16),
                        Text(
                          'No trusted contacts yet.\nTap + to add one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _contacts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final c = _contacts[i];
                      return _ContactListItem(
                        contact: c,
                        onEdit: () => _showAddEditDialog(contact: c),
                        onDelete: () => _deleteContact(c),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEditDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('Add Contact',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ─── Contact list item ────────────────────────────────────────────────────────
class _ContactListItem extends StatelessWidget {
  final TrustedContactModel contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ContactListItem({
    required this.contact,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // Priority badge + avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.15),
                child: Text(
                  contact.initials,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      '${contact.priority}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.relationship,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.phone,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Actions
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                size: 20, color: AppColors.primary),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                size: 20, color: AppColors.error),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

// ─── Dialog text field ────────────────────────────────────────────────────────
class _DialogField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _DialogField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (v) =>
          v == null || v.trim().isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
