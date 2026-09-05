import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/course.dart';
import '../../theme/app_theme.dart';

/// MVC View form for creating or updating a Course.
class CourseFormView extends StatefulWidget {
  final String? courseId;
  const CourseFormView({super.key, this.courseId});
  bool get isEditing => courseId != null;

  @override
  State<CourseFormView> createState() => _CourseFormViewState();
}

class _CourseFormViewState extends State<CourseFormView> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _credits = TextEditingController();
  final _lecturer = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final c =
            context.read<AppController>().getCourseById(widget.courseId!);
        if (c != null) {
          _code.text = c.courseCode;
          _name.text = c.courseName;
          _desc.text = c.description;
          _credits.text = c.credits.toString();
          _lecturer.text = c.lecturer;
        }
      });
    }
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _desc.dispose();
    _credits.dispose();
    _lecturer.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final controller = context.read<AppController>();
    final course = Course(
      id: widget.courseId ?? '',
      courseCode: _code.text.trim().toUpperCase(),
      courseName: _name.text.trim(),
      description: _desc.text.trim(),
      credits: int.tryParse(_credits.text.trim()) ?? 3,
      lecturer: _lecturer.text.trim(),
    );

    if (widget.isEditing) {
      controller.updateCourse(widget.courseId!, course);
    } else {
      controller.addCourse(course);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(widget.isEditing ? 'Course updated' : 'Course added'),
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
        title: Text(widget.isEditing ? 'Edit Course' : 'New Course'),
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
                    gradient: AppTheme.greenGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.success.withAlpha(50),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.isEditing
                        ? Icons.edit_rounded
                        : Icons.library_add_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  widget.isEditing
                      ? 'Update Course Details'
                      : 'Create New Course',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 14),
                ),
              ),
              const SizedBox(height: 32),

              _field('Course Code', _code, Icons.tag_rounded, 'e.g., BCI 1312',
                  TextInputType.text,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 18),
              _field('Course Name', _name, Icons.auto_stories_outlined,
                  'e.g., Mobile Application Development', TextInputType.text,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 18),
              _field('Description', _desc, Icons.description_outlined,
                  'Enter course description', TextInputType.multiline,
                  maxLines: 3,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 18),
              _field('Credits', _credits, Icons.star_outline_rounded,
                  'e.g., 3', TextInputType.number, validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                final n = int.tryParse(v.trim());
                if (n == null || n < 1 || n > 6) return '1-6 only';
                return null;
              }),
              const SizedBox(height: 18),
              _field('Lecturer', _lecturer, Icons.person_outline_rounded,
                  'Enter lecturer name', TextInputType.name,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.success,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(widget.isEditing ? 'Update Course' : 'Add Course',
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

  Widget _field(String label, TextEditingController ctrl, IconData icon,
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
