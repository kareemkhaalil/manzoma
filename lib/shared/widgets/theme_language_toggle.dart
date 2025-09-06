import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manzoma/core/localization/cubit/locale_state.dart';
import 'package:manzoma/core/theme/cubit/theme_cubit.dart';
import 'package:manzoma/core/localization/cubit/locale_cubit.dart';
import 'package:manzoma/core/localization/app_localizations.dart';
import 'package:manzoma/core/theme/cubit/theme_state.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ThemeLanguageToggle extends StatelessWidget {
  const ThemeLanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Language Toggle
        BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return PopupMenuButton<String>(
              icon: Icon(
                Icons.language,
                color: Theme.of(context).iconTheme.color,
              ),
              onSelected: (String languageCode) {
                context.read<LocaleCubit>().changeLanguage(languageCode);
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'en',
                  child: Row(
                    children: [
                      const Icon(Icons.flag),
                      const SizedBox(width: 8),
                      Text(FlutterLocalization.instance.getString(context, 'english')),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'ar',
                  child: Row(
                    children: [
                      const Icon(Icons.flag),
                      const SizedBox(width: 8),
                      Text(FlutterLocalization.instance.getString(context, 'arabic')),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
        // Theme Toggle
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final isDark = themeState.themeData.brightness == Brightness.dark;
            return IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
              tooltip: isDark
                  ? FlutterLocalization.instance.getString(context, 'lightMode')
                  : FlutterLocalization.instance.getString(context, 'darkMode'),
            );
          },
        ),
      ],
    );
  }
}
