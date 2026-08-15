# 🎓 BCI Campus Management System

> **Mobile Application for Student & Course Administration**  
> *Developed with Flutter, Provider State Management, SOLID Architecture & DRY Principles*

---
## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter SDK](https://flutter.dev/) (Dart 3+)
- **State Management**: [`provider`](https://pub.dev/packages/provider) (`^6.1.2`)
- **Architecture**: SOLID Principles (SRP, OCP, LSP, ISP, DIP) + DRY Component Library
- **Icons**: Material Icons (`uses-material-design: true`)
- **Assets**: Custom BCI Campus branding (`assets/images/bci_logo.png`)

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)
- Dart SDK (v3.0.0 or higher)
- Android Studio / VS Code with Flutter extension
- An Android Emulator, iOS Simulator, or Chrome browser for testing

### Installation & Setup

1. **Clone or navigate to the project directory**:
   ```bash
   cd "BCI-Management-System-mobile-application"
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   # Run on default connected device/emulator
   flutter run

   # Or run explicitly on Web / Desktop:
   flutter run -d chrome
   flutter run -d windows
   ```

4. **Run test suite**:
   ```bash
   flutter test
   ```

---

## ✅ Verification & Quality Assurance

The codebase passes all static analysis and automated test suites:

```bash
flutter analyze
# Output: Analyzing BCI-Management-System-mobile-application...
# No issues found!

flutter test
# Output: 00:02 +15: All tests passed!
```

---

## 📌 Table of Contents

- [Overview](#-overview)
- [SOLID Principles Implementation](#-solid-principles-implementation)
- [DRY Architecture & Reusable Components](#-dry-architecture--reusable-components)
- [Key Features](#-key-features)
- [UI & Design System](#-ui--design-system)
- [Folder Structure](#-folder-structure)
- [Pre-Loaded Sample Data](#-pre-loaded-sample-data)
- [Tech Stack & Dependencies](#-tech-stack--dependencies)
- [Getting Started](#-getting-started)
- [Verification & Quality Assurance](#-verification--quality-assurance)

---

## 📖 Overview

The **BCI Campus Management System** is a mobile application developed with **Flutter** designed to streamline academic administrative tasks at BCI Campus. The app enables university administrators to manage student profiles, course catalogs, and student-to-course enrollments through a responsive, modern interface.

### Key Highlights:
- **Complete CRUD Operations** for both Students and Courses.
- **Bi-directional Course Enrollment System** with real-time course counter updates.
- **Search Capabilities** across student records and course catalogs.
- **SOLID Design Principles**: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion.
- **DRY (Don't Repeat Yourself) Design**: Modular, reusable component library eliminating UI and logic duplication.
- **Premium Light Theme Design System** featuring academic navy, emerald green, and warm amber color schemes.

---

## 🧩 SOLID Principles Implementation

The codebase strictly follows the **SOLID** design principles for maintainability, testability, and scalability:

### 1. Single Responsibility Principle (SRP)
- **Repositories**: Storage & query logic is encapsulated inside dedicated classes (`InMemoryStudentRepository`, `InMemoryCourseRepository`, `InMemoryEnrollmentRepository`).
- **Services**: Initial demo data seeding is isolated inside `SampleDataService`.
- **UI Components**: UI screens delegate search bars, headers, delete dialogs, and empty states to reusable single-responsibility widgets in `lib/widgets/`.

### 2. Open/Closed Principle (OCP)
- Systems can be extended with new storage mechanisms (e.g., SQLite, Hive, REST API) by creating a new class that implements the repository interfaces (`IStudentRepository`, `ICourseRepository`, `IEnrollmentRepository`), without altering state providers or UI screens.

### 3. Liskov Substitution Principle (LSP)
- All concrete repository implementations (`InMemoryStudentRepository`, etc.) fulfill the contracts defined by their abstract interfaces and can replace each other seamlessly without breaking application expectations.

### 4. Interface Segregation Principle (ISP)
- Large monolithic interfaces are segregated into focused role-based contracts (`IStudentReader`, `IStudentWriter`, `ICourseReader`, `ICourseWriter`, `IEnrollmentReader`, `IEnrollmentWriter`). Clients depend only on methods they actually consume.

### 5. Dependency Inversion Principle (DIP)
- High-level modules (`DataProvider`, `SampleDataService`) and state management controllers depend on abstract interfaces (`IStudentRepository`, `ICourseRepository`, `IEnrollmentRepository`), not on concrete implementations.
- Dependencies are injected via constructors in `main.dart` (Composition Root).

---

## 🧩 DRY Architecture & Reusable Components

The application follows the **DRY (Don't Repeat Yourself)** principle by isolating repeating layout structures, form controls, visual headers, dialogs, and styling into dedicated reusable modules:

### 1. Reusable Widgets (`lib/widgets/`)
- **`SliverGradientSearchHeader`**: Unified sliver header with dynamic brand gradients, counter badges, and integrated live search with clear triggers.
- **`EmptyStateView`**: Versatile empty state placeholder handling search zero-states and empty entity lists.
- **`AppTextFormField`**: Consistent form input with custom label styling, prefix icon positioning, and validation rules.
- **`FormHeaderIcon`**: Standardized header icon with gradient glow and contextual subtitle for registration/edit forms.
- **`InitialsAvatar`**: Multi-purpose gradient avatar displaying student initials or course icons with customizable sizing.
- **`CountBadge`**: Semantic pill badges for enrollment counters and course statistics.
- **`ActionIconButton`**: Unified ink-responsive action trigger for card-level operations (edit, delete, unenroll).
- **`SectionHeader`**: Branded section divider with vertical gradient indicator bars.
- **`InfoRowTile`**: Standardized key-value detail row with icon pill and high-contrast typography.

### 2. Centralized Utilities (`lib/utils/`)
- **`app_dialogs.dart`**: Standardized confirmation modals (`showDeleteConfirmDialog`) with callback support.
- **`app_snackbar.dart`**: Consistent floating feedback notifications (`showSuccessSnackBar`, `showErrorSnackBar`, `showInfoSnackBar`).

---

## ✨ Key Features

### 📊 1. Executive Dashboard
- **Overview Stat Cards**: Real-time counts for Total Students, Total Courses, and Active Enrollments.
- **Gradient Quick Actions**: One-tap shortcuts to add new students, create courses, or manage enrollments.
- **Recent Activity**: Quick access lists showing recently registered students and active courses.

### 👨‍🎓 2. Student Record Management (CRUD)
- **Add Student**: Register new students with Full Name, Email Address, Phone Number, and Physical Address.
- **View Student Details**: Profile page displaying personal information and all currently enrolled courses.
- **Edit Student**: Update student contact details and personal info with form validation.
- **Delete Student**: Remove student records with confirmation dialogs.
- **Live Search**: Instant filtering by student name, ID, or email address.

### 📚 3. Course Record Management (CRUD)
- **Add Course**: Create new courses with Course Code (e.g., `BCI 1312`), Course Name, Description, Credit Units (1–6), and Lecturer Name.
- **View Course Details**: Breakdown of course information along with a list of enrolled students.
- **Edit Course**: Modify course details, credit allocation, or assigned lecturer.
- **Delete Course**: Remove courses with cascade handling for enrolled students.
- **Live Search**: Filter courses by course code, name, or lecturer.

### 📝 4. Course Enrollment System
- **Interactive Enrollment Flow**:
  1. Select a student from a searchable dropdown menu.
  2. Toggle course enrollment on/off with immediate state feedback.
- **Enrollment Overview Tab**: Accordion view displaying all students and their enrolled courses.

---

## 🎨 UI & Design System

The application follows a **Premium Academic Light Theme**:

- **Color Palette**:
  - `Scaffold Background`: `#F7F8FC` (Soft light gray)
  - `Primary Navy`: `#162447` – `#2A4494` (BCI Campus Brand Colors)
  - `Emerald Green`: `#065F46` – `#0D9F6F` (Courses & Success indicators)
  - `Warm Amber`: `#B45309` – `#E8841A` (Enrollment System)
  - `Surface Cards`: `#FFFFFF` with multi-layered subtle drop shadows (`BoxShadow`)
- **Typography & Components**:
  - Rounded cards (`BorderRadius: 16px - 24px`) with subtle borders.
  - Interactive ripple inkwells and micro-animations.
  - Animated bottom navigation bar with active indicators.

---

## 🏗️ Folder Structure

```
lib/
├── main.dart                             # Composition Root & App entry point
├── models/
│   ├── student.dart                      # Student data model
│   └── course.dart                       # Course data model
├── repositories/
│   ├── interfaces/                       # Abstractions (ISP / DIP)
│   │   ├── student_repository_interface.dart
│   │   ├── course_repository_interface.dart
│   │   └── enrollment_repository_interface.dart
│   └── implementations/                  # Concrete storage (LSP / SRP)
│       ├── in_memory_student_repository.dart
│       ├── in_memory_course_repository.dart
│       └── in_memory_enrollment_repository.dart
├── services/
│   └── sample_data_service.dart          # Demo data seeding (SRP)
├── providers/
│   └── data_provider.dart                # Central State Coordinator (DIP / ChangeNotifier)
├── theme/
│   └── app_theme.dart                    # Design tokens, gradients & ThemeData
├── utils/
│   ├── app_dialogs.dart                  # Reusable confirmation dialogs
│   └── app_snackbar.dart                 # Standardized SnackBar helpers
├── widgets/
│   ├── action_icon_button.dart           # Reusable action button
│   ├── app_text_form_field.dart          # Reusable styled text field
│   ├── count_badge.dart                  # Reusable count pill badge
│   ├── empty_state_view.dart             # Reusable empty state placeholder
│   ├── form_header_icon.dart             # Reusable form header icon
│   ├── gradient_search_header.dart       # Reusable Sliver gradient search header
│   ├── info_row_tile.dart                # Reusable info row tile
│   ├── initials_avatar.dart              # Reusable initials/icon avatar
│   └── section_header.dart               # Reusable section title with accent bar
└── screens/
    ├── home_screen.dart                  # Dashboard & Bottom Navigation
    ├── students/
    │   ├── student_list_screen.dart      # Student catalog & search
    │   ├── student_form_screen.dart      # Add/Edit student form
    │   └── student_detail_screen.dart    # Student profile & enrollments
    ├── courses/
    │   ├── course_list_screen.dart       # Course catalog & search
    │   ├── course_form_screen.dart       # Add/Edit course form
    │   └── course_detail_screen.dart     # Course details & student list
    └── enrollment/
        └── enrollment_screen.dart        # Enrollment management (Enroll + View tabs)
test/
├── data_provider_test.dart               # State management & CRUD unit tests
├── widget_test.dart                      # App bootstrap & dashboard test
└── widgets_test.dart                     # Reusable widgets unit tests
```

---

## 📦 Pre-Loaded Sample Data

On startup, `SampleDataService` populates realistic demo records:

### Students (5 Records):
- `STU0001` - Ashan Bandara (`ashan.bandara@bci.lk`)
- `STU0002` - Kavindi Perera (`kavindi.perera@bci.lk`)
- `STU0003` - Tharindu Silva (`tharindu.silva@bci.lk`)
- `STU0004` - Nethmi Fernando (`nethmi.fernando@bci.lk`)
- `STU0005` - Sahan Jayawardena (`sahan.jayawardena@bci.lk`)

### Courses (6 Records):
- `BCI 1312` - Mobile Application Development (3 Credits) — Mr. Kamal Perera
- `BCI 1314` - Database Management Systems (3 Credits) — Dr. Nimal Fernando
- `BCI 1316` - Web Application Development (4 Credits) — Ms. Sachini Silva
- `BCI 1318` - Data Structures & Algorithms (4 Credits) — Prof. Anil Jayasuriya
- `BCI 1320` - Computer Networks (3 Credits) — Dr. Ruwan Wickrama
- `BCI 1322` - Software Engineering (3 Credits) — Mr. Dinesh Rajapakse

---

## 📄 License

This project is created for educational and administrative assessment purposes for **BCI Campus**.
