import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../providers/data_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snackbar.dart';
import '../../widgets/app_text_form_field.dart';
import '../../widgets/form_header_icon.dart';

/// Premium form for adding/editing a course.
class CourseFormScreen extends StatefulWidget {
  final String? courseId;
  const CourseFormScreen({super.key, this.courseId});
  bool get isEditing => courseId != null;

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
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
            context.read<DataProvider>().getCourseById(widget.courseId!);
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
    final dp = context.read<DataProvider>();
    final course = Course(
      id: widget.courseId ?? '',
      courseCode: _code.text.trim().toUpperCase(),
      courseName: _name.text.trim(),
      description: _desc.text.trim(),
      credits: int.tryParse(_credits.text.trim()) ?? 3,
      lecturer: _lecturer.text.trim(),
    );
    if (widget.isEditing) {
      dp.updateCourse(widget.courseId!, course);
    } else {
      dp.addCourse(course);
    }
    Navigator.pop(context);
    showSuccessSnackBar(
      context,
      widget.isEditing ? 'Course updated' : 'Course added',
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
        title: Text(widget.isEditing ? 'Edit Course' : 'New Course'),
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
                    : Icons.library_add_rounded,
                subtitle: widget.isEditing
                    ? 'Update Course Details'
                    : 'Create New Course',
                gradient: AppTheme.greenGradient,
                shadowColor: AppTheme.success.withAlpha(50),
              ),

              AppTextFormField(
                label: 'Course Code',
                controller: _code,
                icon: Icons.tag_rounded,
                hint: 'e.g., BCI 1312',
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 18),
              AppTextFormField(
                label: 'Course Name',
                controller: _name,
                icon: Icons.auto_stories_outlined,
                hint: 'e.g., Mobile Application Development',
                keyboardType: TextInputType.text,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 18),
              AppTextFormField(
                label: 'Description',
                controller: _desc,
                icon: Icons.description_outlined,
                hint: 'Enter course description',
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 18),
              AppTextFormField(
                label: 'Credits',
                controller: _credits,
                icon: Icons.star_outline_rounded,
                hint: 'e.g., 3',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final n = int.tryParse(v.trim());
                  if (n == null || n < 1 || n > 6) return '1-6 only';
                  return null;
                },
              ),
              const SizedBox(height: 18),
              AppTextFormField(
                label: 'Lecturer',
                controller: _lecturer,
                icon: Icons.person_outline_rounded,
                hint: 'Enter lecturer name',
                keyboardType: TextInputType.name,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.success,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  widget.isEditing ? 'Update Course' : 'Add Course',
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
