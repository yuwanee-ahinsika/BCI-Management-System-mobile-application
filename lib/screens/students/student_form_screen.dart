import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../../providers/data_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snackbar.dart';
import '../../widgets/app_text_form_field.dart';
import '../../widgets/form_header_icon.dart';

/// Premium form for adding/editing a student.
class StudentFormScreen extends StatefulWidget {
  final String? studentId;
  const StudentFormScreen({super.key, this.studentId});
  bool get isEditing => studentId != null;

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
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
        final s =
            context.read<DataProvider>().getStudentById(widget.studentId!);
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
    final dp = context.read<DataProvider>();
    final student = Student(
      id: widget.studentId ?? '',
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      address: _address.text.trim(),
    );
    if (widget.isEditing) {
      dp.updateStudent(widget.studentId!, student);
    } else {
      dp.addStudent(student);
    }
    Navigator.pop(context);
    showSuccessSnackBar(
      context,
      widget.isEditing ? 'Student updated' : 'Student added',
    );
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
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppTheme.textPrimary,
            ),
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
              FormHeaderIcon(
                icon: widget.isEditing
                    ? Icons.edit_rounded
                    : Icons.person_add_alt_1_rounded,
                subtitle: widget.isEditing
                    ? 'Update Student Details'
                    : 'Register New Student',
                gradient: AppTheme.accentGradient,
              ),

              AppTextFormField(
                label: 'Full Name',
                controller: _name,
                icon: Icons.person_outline_rounded,
                hint: 'Enter student name',
                keyboardType: TextInputType.name,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 18),
              AppTextFormField(
                label: 'Email Address',
                controller: _email,
                icon: Icons.email_outlined,
                hint: 'Enter email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!RegExp(r'^[\w.\-]+@[\w.\-]+\.\w+$').hasMatch(v.trim())) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              AppTextFormField(
                label: 'Phone Number',
                controller: _phone,
                icon: Icons.phone_outlined,
                hint: 'Enter phone',
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 18),
              AppTextFormField(
                label: 'Address',
                controller: _address,
                icon: Icons.location_on_outlined,
                hint: 'Enter address',
                keyboardType: TextInputType.streetAddress,
                maxLines: 3,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 36),

              // Save
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  widget.isEditing ? 'Update Student' : 'Add Student',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
}
