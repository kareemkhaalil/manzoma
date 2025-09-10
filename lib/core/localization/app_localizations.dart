import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);
  static AppLocalizations? instance(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  static AppLocalizations off(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  // Example translations
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'k_Drawer': 'Drawer',
    },
    'ar': {
      'k_Drawer': 'القائمة',
    },
  };

  String tr(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }

  // Common strings
  String get appTitle => locale.languageCode == 'ar'
      ? 'هيوما بلس - نظام الحضور والرواتب الذكي'
      : 'HumaPlus - Smart Attendance & Payroll';

  String get dashboard =>
      locale.languageCode == 'ar' ? 'لوحة التحكم' : 'Dashboard';
  String get users => locale.languageCode == 'ar' ? 'المستخدمين' : 'Users';
  String get clients => locale.languageCode == 'ar' ? 'العملاء' : 'Clients';
  String get branches => locale.languageCode == 'ar' ? 'الفروع' : 'Branches';
  String get payroll => locale.languageCode == 'ar' ? 'الرواتب' : 'Payroll';
  String get reports => locale.languageCode == 'ar' ? 'التقارير' : 'Reports';
  String get settings => locale.languageCode == 'ar' ? 'الإعدادات' : 'Settings';
  String get attendance =>
      locale.languageCode == 'ar' ? 'الحضور' : 'Attendance';

  // Actions
  String get add => locale.languageCode == 'ar' ? 'إضافة' : 'Add';
  String get edit => locale.languageCode == 'ar' ? 'تعديل' : 'Edit';
  String get delete => locale.languageCode == 'ar' ? 'حذف' : 'Delete';
  String get save => locale.languageCode == 'ar' ? 'حفظ' : 'Save';
  String get cancel => locale.languageCode == 'ar' ? 'إلغاء' : 'Cancel';
  String get search => locale.languageCode == 'ar' ? 'بحث' : 'Search';
  String get filter => locale.languageCode == 'ar' ? 'تصفية' : 'Filter';
  String get submit => locale.languageCode == 'ar' ? 'إرسال' : 'Submit';
  String get close => locale.languageCode == 'ar' ? 'إغلاق' : 'Close';
  String get view => locale.languageCode == 'ar' ? 'عرض' : 'View';
  String get update => locale.languageCode == 'ar' ? 'تحديث' : 'Update';
  String get create => locale.languageCode == 'ar' ? 'إنشاء' : 'Create';
  String get refresh => locale.languageCode == 'ar' ? 'تحديث' : 'Refresh';
  String get loading =>
      locale.languageCode == 'ar' ? 'جاري التحميل...' : 'Loading...';
  String get noData =>
      locale.languageCode == 'ar' ? 'لا توجد بيانات' : 'No Data';
  String get error => locale.languageCode == 'ar' ? 'خطأ' : 'Error';
  String get success => locale.languageCode == 'ar' ? 'نجح' : 'Success';
  String get warning => locale.languageCode == 'ar' ? 'تحذير' : 'Warning';
  String get info => locale.languageCode == 'ar' ? 'معلومات' : 'Info';

  // Login Screen
  String get welcomeBack =>
      locale.languageCode == 'ar' ? 'مرحباً بعودتك' : 'Welcome Back';
  String get signInToAccount => locale.languageCode == 'ar'
      ? 'سجل دخولك إلى حسابك'
      : 'Sign in to your account';
  String get email =>
      locale.languageCode == 'ar' ? 'البريد الإلكتروني' : 'Email';
  String get enterEmail => locale.languageCode == 'ar'
      ? 'أدخل بريدك الإلكتروني'
      : 'Enter your email';
  String get password =>
      locale.languageCode == 'ar' ? 'كلمة المرور' : 'Password';
  String get enterPassword =>
      locale.languageCode == 'ar' ? 'أدخل كلمة المرور' : 'Enter your password';
  String get forgotPassword =>
      locale.languageCode == 'ar' ? 'نسيت كلمة المرور؟' : 'Forgot Password?';
  String get signIn => locale.languageCode == 'ar' ? 'تسجيل الدخول' : 'Sign In';
  String get demoAccounts =>
      locale.languageCode == 'ar' ? 'حسابات تجريبية' : 'Demo Accounts';
  String get admin => locale.languageCode == 'ar' ? 'مدير' : 'Admin';
  String get employee => locale.languageCode == 'ar' ? 'موظف' : 'Employee';
  String get smartAttendancePayroll => locale.languageCode == 'ar'
      ? 'إدارة الحضور والرواتب الذكية'
      : 'Smart Attendance & Payroll Management';

  // Validation Messages
  String get pleaseEnterEmail => locale.languageCode == 'ar'
      ? 'يرجى إدخال البريد الإلكتروني'
      : 'Please enter your email';
  String get pleaseEnterValidEmail => locale.languageCode == 'ar'
      ? 'يرجى إدخال بريد إلكتروني صحيح'
      : 'Please enter a valid email';
  String get pleaseEnterPassword => locale.languageCode == 'ar'
      ? 'يرجى إدخال كلمة المرور'
      : 'Please enter your password';
  String get passwordMinLength => locale.languageCode == 'ar'
      ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
      : 'Password must be at least 6 characters';
  String get pleaseEnterName =>
      locale.languageCode == 'ar' ? 'يرجى إدخال الاسم' : 'Please enter name';
  String get pleaseEnterPhone => locale.languageCode == 'ar'
      ? 'يرجى إدخال رقم الهاتف'
      : 'Please enter phone number';
  String get pleaseEnterValidPhone => locale.languageCode == 'ar'
      ? 'يرجى إدخال رقم هاتف صحيح'
      : 'Please enter a valid phone number';
  String get pleaseSelectRole =>
      locale.languageCode == 'ar' ? 'يرجى اختيار الدور' : 'Please select role';
  String get pleaseEnterCompany => locale.languageCode == 'ar'
      ? 'يرجى إدخال اسم الشركة'
      : 'Please enter company name';
  String get pleaseEnterAddress => locale.languageCode == 'ar'
      ? 'يرجى إدخال العنوان'
      : 'Please enter address';
  String get pleaseEnterLocation => locale.languageCode == 'ar'
      ? 'يرجى إدخال الموقع'
      : 'Please enter location';

  // User related
  String get addUser =>
      locale.languageCode == 'ar' ? 'إضافة مستخدم' : 'Add User';
  String get userName =>
      locale.languageCode == 'ar' ? 'اسم المستخدم' : 'User Name';
  String get fullName =>
      locale.languageCode == 'ar' ? 'الاسم الكامل' : 'Full Name';
  String get phone => locale.languageCode == 'ar' ? 'رقم الهاتف' : 'Phone';
  String get role => locale.languageCode == 'ar' ? 'الدور' : 'Role';
  String get selectRole =>
      locale.languageCode == 'ar' ? 'اختر الدور' : 'Select Role';
  String get userCreated => locale.languageCode == 'ar'
      ? 'تم إنشاء المستخدم بنجاح'
      : 'User created successfully';
  String get userUpdated => locale.languageCode == 'ar'
      ? 'تم تحديث المستخدم بنجاح'
      : 'User updated successfully';
  String get userDeleted => locale.languageCode == 'ar'
      ? 'تم حذف المستخدم بنجاح'
      : 'User deleted successfully';
  String get editUser =>
      locale.languageCode == 'ar' ? 'تعديل المستخدم' : 'Edit User';
  String get deleteUser =>
      locale.languageCode == 'ar' ? 'حذف المستخدم' : 'Delete User';
  String get confirmDeleteUser => locale.languageCode == 'ar'
      ? 'هل أنت متأكد من حذف هذا المستخدم؟'
      : 'Are you sure you want to delete this user?';

  // Client related
  String get addClient =>
      locale.languageCode == 'ar' ? 'إضافة عميل' : 'Add Client';
  String get clientName =>
      locale.languageCode == 'ar' ? 'اسم العميل' : 'Client Name';
  String get company => locale.languageCode == 'ar' ? 'الشركة' : 'Company';
  String get address => locale.languageCode == 'ar' ? 'العنوان' : 'Address';
  String get clientCreated => locale.languageCode == 'ar'
      ? 'تم إنشاء العميل بنجاح'
      : 'Client created successfully';
  String get clientUpdated => locale.languageCode == 'ar'
      ? 'تم تحديث العميل بنجاح'
      : 'Client updated successfully';
  String get clientDeleted => locale.languageCode == 'ar'
      ? 'تم حذف العميل بنجاح'
      : 'Client deleted successfully';
  String get editClient =>
      locale.languageCode == 'ar' ? 'تعديل العميل' : 'Edit Client';
  String get deleteClient =>
      locale.languageCode == 'ar' ? 'حذف العميل' : 'Delete Client';
  String get confirmDeleteClient => locale.languageCode == 'ar'
      ? 'هل أنت متأكد من حذف هذا العميل؟'
      : 'Are you sure you want to delete this client?';

  // Branch related
  String get addBranch =>
      locale.languageCode == 'ar' ? 'إضافة فرع' : 'Add Branch';
  String get branchName =>
      locale.languageCode == 'ar' ? 'اسم الفرع' : 'Branch Name';
  String get location => locale.languageCode == 'ar' ? 'الموقع' : 'Location';
  String get branchCreated => locale.languageCode == 'ar'
      ? 'تم إنشاء الفرع بنجاح'
      : 'Branch created successfully';
  String get branchUpdated => locale.languageCode == 'ar'
      ? 'تم تحديث الفرع بنجاح'
      : 'Branch updated successfully';
  String get branchDeleted => locale.languageCode == 'ar'
      ? 'تم حذف الفرع بنجاح'
      : 'Branch deleted successfully';
  String get editBranch =>
      locale.languageCode == 'ar' ? 'تعديل الفرع' : 'Edit Branch';
  String get deleteBranch =>
      locale.languageCode == 'ar' ? 'حذف الفرع' : 'Delete Branch';
  String get confirmDeleteBranch => locale.languageCode == 'ar'
      ? 'هل أنت متأكد من حذف هذا الفرع؟'
      : 'Are you sure you want to delete this branch?';

  // Attendance related
  String get checkIn =>
      locale.languageCode == 'ar' ? 'تسجيل الدخول' : 'Check In';
  String get checkOut =>
      locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Check Out';
  String get attendanceHistory =>
      locale.languageCode == 'ar' ? 'سجل الحضور' : 'Attendance History';
  String get checkedIn => locale.languageCode == 'ar'
      ? 'تم تسجيل الدخول بنجاح'
      : 'Checked in successfully';
  String get checkedOut => locale.languageCode == 'ar'
      ? 'تم تسجيل الخروج بنجاح'
      : 'Checked out successfully';
  String get totalHours =>
      locale.languageCode == 'ar' ? 'إجمالي الساعات' : 'Total Hours';
  String get workingHours =>
      locale.languageCode == 'ar' ? 'ساعات العمل' : 'Working Hours';
  String get overtime =>
      locale.languageCode == 'ar' ? 'ساعات إضافية' : 'Overtime';
  String get absent => locale.languageCode == 'ar' ? 'غائب' : 'Absent';
  String get present => locale.languageCode == 'ar' ? 'حاضر' : 'Present';
  String get late => locale.languageCode == 'ar' ? 'متأخر' : 'Late';
  String get early => locale.languageCode == 'ar' ? 'مبكر' : 'Early';

  // Payroll related
  String get salary => locale.languageCode == 'ar' ? 'الراتب' : 'Salary';
  String get basicSalary =>
      locale.languageCode == 'ar' ? 'الراتب الأساسي' : 'Basic Salary';
  String get allowances =>
      locale.languageCode == 'ar' ? 'البدلات' : 'Allowances';
  String get deductions =>
      locale.languageCode == 'ar' ? 'الخصومات' : 'Deductions';
  String get netSalary =>
      locale.languageCode == 'ar' ? 'صافي الراتب' : 'Net Salary';
  String get grossSalary =>
      locale.languageCode == 'ar' ? 'إجمالي الراتب' : 'Gross Salary';
  String get payrollHistory =>
      locale.languageCode == 'ar' ? 'سجل الرواتب' : 'Payroll History';
  String get generatePayroll =>
      locale.languageCode == 'ar' ? 'إنشاء كشف راتب' : 'Generate Payroll';
  String get payrollGenerated => locale.languageCode == 'ar'
      ? 'تم إنشاء كشف الراتب بنجاح'
      : 'Payroll generated successfully';
  String get month => locale.languageCode == 'ar' ? 'الشهر' : 'Month';
  String get year => locale.languageCode == 'ar' ? 'السنة' : 'Year';
  String get payDate =>
      locale.languageCode == 'ar' ? 'تاريخ الدفع' : 'Pay Date';
  String get status => locale.languageCode == 'ar' ? 'الحالة' : 'Status';
  String get paid => locale.languageCode == 'ar' ? 'مدفوع' : 'Paid';
  String get pending => locale.languageCode == 'ar' ? 'معلق' : 'Pending';
  String get cancelled => locale.languageCode == 'ar' ? 'ملغي' : 'Cancelled';

  // Dashboard related
  String get totalEmployees =>
      locale.languageCode == 'ar' ? 'إجمالي الموظفين' : 'Total Employees';
  String get totalClients =>
      locale.languageCode == 'ar' ? 'إجمالي العملاء' : 'Total Clients';
  String get totalBranches =>
      locale.languageCode == 'ar' ? 'إجمالي الفروع' : 'Total Branches';
  String get todayAttendance =>
      locale.languageCode == 'ar' ? 'حضور اليوم' : 'Today\'s Attendance';
  String get recentActivities =>
      locale.languageCode == 'ar' ? 'الأنشطة الحديثة' : 'Recent Activities';
  String get quickActions =>
      locale.languageCode == 'ar' ? 'إجراءات سريعة' : 'Quick Actions';
  String get statistics =>
      locale.languageCode == 'ar' ? 'الإحصائيات' : 'Statistics';
  String get overview => locale.languageCode == 'ar' ? 'نظرة عامة' : 'Overview';

  // Theme and Language
  String get darkMode =>
      locale.languageCode == 'ar' ? 'الوضع المظلم' : 'Dark Mode';
  String get lightMode =>
      locale.languageCode == 'ar' ? 'الوضع الفاتح' : 'Light Mode';
  String get language => locale.languageCode == 'ar' ? 'اللغة' : 'Language';
  String get arabic => locale.languageCode == 'ar' ? 'العربية' : 'Arabic';
  String get english => locale.languageCode == 'ar' ? 'الإنجليزية' : 'English';
  String get theme => locale.languageCode == 'ar' ? 'المظهر' : 'Theme';
  String get changeLanguage =>
      locale.languageCode == 'ar' ? 'تغيير اللغة' : 'Change Language';
  String get changeTheme =>
      locale.languageCode == 'ar' ? 'تغيير المظهر' : 'Change Theme';

  // Navigation and UI
  String get home => locale.languageCode == 'ar' ? 'الرئيسية' : 'Home';
  String get profile =>
      locale.languageCode == 'ar' ? 'الملف الشخصي' : 'Profile';
  String get logout => locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Logout';
  String get menu => locale.languageCode == 'ar' ? 'القائمة' : 'Menu';
  String get back => locale.languageCode == 'ar' ? 'رجوع' : 'Back';
  String get next => locale.languageCode == 'ar' ? 'التالي' : 'Next';
  String get previous => locale.languageCode == 'ar' ? 'السابق' : 'Previous';
  String get page => locale.languageCode == 'ar' ? 'صفحة' : 'Page';
  String get of => locale.languageCode == 'ar' ? 'من' : 'of';
  String get total => locale.languageCode == 'ar' ? 'المجموع' : 'Total';
  String get items => locale.languageCode == 'ar' ? 'عناصر' : 'items';
  String get showMore =>
      locale.languageCode == 'ar' ? 'عرض المزيد' : 'Show More';
  String get showLess => locale.languageCode == 'ar' ? 'عرض أقل' : 'Show Less';

  // Date and Time
  String get today => locale.languageCode == 'ar' ? 'اليوم' : 'Today';
  String get yesterday => locale.languageCode == 'ar' ? 'أمس' : 'Yesterday';
  String get tomorrow => locale.languageCode == 'ar' ? 'غداً' : 'Tomorrow';
  String get thisWeek =>
      locale.languageCode == 'ar' ? 'هذا الأسبوع' : 'This Week';
  String get thisMonth =>
      locale.languageCode == 'ar' ? 'هذا الشهر' : 'This Month';
  String get thisYear =>
      locale.languageCode == 'ar' ? 'هذا العام' : 'This Year';
  String get date => locale.languageCode == 'ar' ? 'التاريخ' : 'Date';
  String get time => locale.languageCode == 'ar' ? 'الوقت' : 'Time';
  String get startDate =>
      locale.languageCode == 'ar' ? 'تاريخ البداية' : 'Start Date';
  String get endDate =>
      locale.languageCode == 'ar' ? 'تاريخ النهاية' : 'End Date';
  String get startTime =>
      locale.languageCode == 'ar' ? 'وقت البداية' : 'Start Time';
  String get endTime =>
      locale.languageCode == 'ar' ? 'وقت النهاية' : 'End Time';

  // Common Messages
  String get confirmAction =>
      locale.languageCode == 'ar' ? 'تأكيد الإجراء' : 'Confirm Action';
  String get areYouSure =>
      locale.languageCode == 'ar' ? 'هل أنت متأكد؟' : 'Are you sure?';
  String get thisActionCannotBeUndone => locale.languageCode == 'ar'
      ? 'لا يمكن التراجع عن هذا الإجراء'
      : 'This action cannot be undone';
  String get operationCompleted => locale.languageCode == 'ar'
      ? 'تمت العملية بنجاح'
      : 'Operation completed successfully';
  String get operationFailed =>
      locale.languageCode == 'ar' ? 'فشلت العملية' : 'Operation failed';
  String get tryAgain =>
      locale.languageCode == 'ar' ? 'حاول مرة أخرى' : 'Try again';
  String get connectionError =>
      locale.languageCode == 'ar' ? 'خطأ في الاتصال' : 'Connection error';
  String get serverError =>
      locale.languageCode == 'ar' ? 'خطأ في الخادم' : 'Server error';
  String get notFound =>
      locale.languageCode == 'ar' ? 'غير موجود' : 'Not found';
  String get accessDenied =>
      locale.languageCode == 'ar' ? 'تم رفض الوصول' : 'Access denied';
  String get sessionExpired =>
      locale.languageCode == 'ar' ? 'انتهت صلاحية الجلسة' : 'Session expired';
  String get pleaseLoginAgain => locale.languageCode == 'ar'
      ? 'يرجى تسجيل الدخول مرة أخرى'
      : 'Please login again';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
