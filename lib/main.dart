import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bashkatep/core/bloc/admin/add_branch_cubit/add_branch_cubit.dart';
import 'package:bashkatep/core/bloc/admin/add_user_cubit/add_user_cubit.dart';
import 'package:bashkatep/core/bloc/attend_cubit/attendance_cubit.dart';
import 'package:bashkatep/core/bloc/attend_cubit/qr_cubit.dart';
import 'package:bashkatep/core/bloc/auth_cubit/auth_login_cubit.dart';
import 'package:bashkatep/core/bloc/form_validator/form_validator_cubit.dart';
import 'package:bashkatep/firebase_options.dart';
import 'package:bashkatep/presintation/screens/splash_screen.dart';
import 'package:bashkatep/core/helpers/firebase_helper/firestore_helper.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  BindingBase.debugZoneErrorsAreFatal = true;

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Open all required boxes if not already open
  await Future.wait([
    Hive.openBox('token'),
    Hive.openBox('userName'),
    Hive.openBox('attendanceRecordId'),
    Hive.openBox<bool>('isAttend'),
    Hive.openBox<DateTime>('lastAttendanceTime'),
    Hive.openBox('userRole'),
    Hive.openBox('clientId'),
  ]);

  // Set default value for isAttend box
  var isAttendBox = Hive.box<bool>('isAttend');
  if (isAttendBox.get('isAttend') == null) {
    await isAttendBox.put('isAttend', false);
  }

  // Create an instance of FirestoreHelper
  final firestoreHelper = FirestoreHelper();

  runApp(MyApp(firestoreHelper: firestoreHelper));
}

class MyApp extends StatelessWidget {
  final FirestoreHelper firestoreHelper;

  const MyApp({super.key, required this.firestoreHelper});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthLoginCubit(
            Hive.box('token'),
            Hive.box('userName'),
            Hive.box('userRole'), // Pass role box
            Hive.box('clientId'),
          ),
        ),
        BlocProvider(
          create: (context) => AttendanceCubit(),
        ),
        BlocProvider(
          create: (context) => FormValidatorCubit(),
        ),
        BlocProvider(
          create: (context) => QRScanCubit(),
        ),
        BlocProvider(
          create: (context) => AuthAddUserCubit(),
        ),
        BlocProvider(
          create: (context) =>
              SuperAdminCubit(firestoreHelper: FirestoreHelper())..getClients(),
        ),
        BlocProvider(
          create: (context) => AddBranchCubit(firestoreHelper),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'الباشكاتب',
        theme: ThemeData(
          textTheme: GoogleFonts.cairoTextTheme(
            Theme.of(context).textTheme,
          ),
          scaffoldBackgroundColor: Color(
            0xffF8FAFF,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
