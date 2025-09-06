import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:manzoma/core/di/injection_container.dart' as di;
import 'package:manzoma/core/storage/shared_pref_helper.dart' as storage;

import 'package:manzoma/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:manzoma/features/branches/presentation/cubit/branch_cubit.dart';
import 'package:manzoma/features/clients/presentation/cubit/client_cubit.dart';
import 'package:manzoma/features/users/presentation/cubit/user_cubit.dart';

import 'package:manzoma/core/theme/cubit/theme_cubit.dart';
import 'package:manzoma/core/localization/cubit/locale_cubit.dart';
import 'core/localization/app_localizations.dart';
import 'core/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initializeSupabase();
  await storage.SharedPrefHelper.init();
  await di.init(); // تأكد ان فيه register لـ ThemeCubit و LocaleCubit

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider<LocaleCubit>(create: (_) => di.sl<LocaleCubit>()),
        BlocProvider<ClientCubit>(create: (_) => di.sl<ClientCubit>()),
        BlocProvider<UserCubit>(create: (_) => di.sl<UserCubit>()),
        BlocProvider<AuthCubit>(create: (_) => di.sl<AuthCubit>()),
        BlocProvider<BranchCubit>(create: (_) => di.sl<BranchCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return ScreenUtilInit(
            designSize: const Size(1920, 1080), // غيرها حسب التصميم عندك
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Manzoma',
              theme: context.watch<ThemeCubit>().state.themeData,
              locale: context.watch<LocaleCubit>().state.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}
