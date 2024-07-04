import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hudor/core/bloc/admin/add_branch_cubit/add_branch_cubit.dart';
import 'package:hudor/core/bloc/admin/add_user_cubit/add_user_cubit.dart';
import 'package:hudor/core/bloc/attend_cubit/attendance_cubit.dart';
import 'package:hudor/core/bloc/attend_cubit/qr_cubit.dart';
import 'package:hudor/core/bloc/auth_cubit/auth_login_cubit.dart';
import 'package:hudor/core/bloc/form_validator/form_validator_cubit.dart';
import 'package:hudor/firebase_options.dart';
import 'package:hudor/presintation/screens/splash_screen.dart';
import 'package:hudor/core/helpers/firebase_helper/firestore_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BindingBase.debugZoneErrorsAreFatal = true;

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Open all required boxes
  await Hive.openBox('token');
  await Hive.openBox('userName');
  await Hive.openBox('attendanceRecordId');
  await Hive.openBox<bool>('isAttend');
  await Hive.openBox<DateTime>('lastAttendanceTime');
  await Hive.openBox('userRole'); // Open role box

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
        BlocProvider<AuthLoginCubit>(
          create: (context) => AuthLoginCubit(
            Hive.box('token'),
            Hive.box('userName'),
            Hive.box('attendanceRecordId'),
            Hive.box('userRole'), // Pass role box
          ),
        ),
        BlocProvider<FormValidatorCubit>(
          create: (context) => FormValidatorCubit(),
        ),
        BlocProvider<QRScanCubit>(
          create: (context) => QRScanCubit(),
        ),
        BlocProvider<AuthAddUserCubit>(
          create: (context) => AuthAddUserCubit(),
        ),
        BlocProvider<AddBranchCubit>(
          create: (context) => AddBranchCubit(firestoreHelper),
        ),
        BlocProvider<AttendanceCubit>(
          create: (context) => AttendanceCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'حضور',
        theme: ThemeData(
          textTheme: GoogleFonts.cairoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
