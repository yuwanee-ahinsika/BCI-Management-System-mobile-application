import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/app_controller.dart';
import '../../models/student.dart';
import '../../theme/app_theme.dart';

/// MVC View form for adding or editing a Student.
class StudentFormView extends StatefulWidget {
  final String? studentId;
  const StudentFormView({super.key, this.studentId});
  bool get isEditing => studentId != null;

  @override
  State<StudentFormView> createState() => _StudentFormViewState();
}

class _StudentFormViewState extends State<StudentFormView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final s = context.read<AppController>().getStudentById(widget.studentId!);
        if (s != null) {
          _name.text = s.name;
          _email.text = s.email;
          _phone.text = s.phone;
          _address.text = s.address;
        }
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final controller = context.read<AppController>();
    final student = Student(
      id: widget.studentId ?? '',
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      address: _address.text.trim(),
    );

    if (widget.isEditing) {
      controller.updateStudent(widget.studentId!, student);
    } else {
      controller.addStudent(student);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(widget.isEditing ? 'Student updated' : 'Student added'),
      backgroundColor: AppTheme.success,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBg,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppTheme.textPrimary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.isEditing ? 'Edit Student' : 'New Student'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withAlpha(50),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.isEditing
                        ? Icons.edit_rounded
                        : Icons.person_add_alt_1_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  widget.isEditing
                      ? 'Update Student Details'
                      : 'Register New Student',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 14),
                ),
              ),
              const SizedBox(height: 32),

              _buildField('Full Name', _name, Icons.person_outline_rounded,
                  'Enter student name', TextInputType.name,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 18),
              _buildField('Email Address', _email, Icons.email_outlined,
                  'Enter email', TextInputType.emailAddress,
                  validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!RegExp(r'^[\w.\-]+@[\w.\-]+\.\w+$').hasMatch(v.trim())) {
                  return 'Invalid email';
                }
                return null;
              }),
              const SizedBox(height: 18),
              _buildField('Phone Number', _phone, Icons.phone_outlined,
                  'Enter phone', TextInputType.phone,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 18),
              _buildField('Address', _address, Icons.location_on_outlined,
                  'Enter address', TextInputType.streetAddress,
                  maxLines: 3,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(widget.isEditing ? 'Update Student' : 'Add Student',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon,
      String hint, TextInputType type,
      {int maxLines = 1, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          maxLines: maxLines,
          textCapitalization: type == TextInputType.emailAddress
              ? TextCapitalization.none
              : TextCapitalization.words,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14.5),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: maxLines > 1 ? 40.0 : 0),
              child: Icon(icon, size: 20),
            ),
            alignLabelWithHint: maxLines > 1,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
