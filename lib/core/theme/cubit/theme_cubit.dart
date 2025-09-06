import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:manzoma/core/theme/cubit/theme_state.dart';
import 'package:manzoma/core/theme/app_themes.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeData: AppThemes.lightTheme));

  void toggleTheme() {
    if (state.themeData.brightness == Brightness.light) {
      emit(ThemeState(themeData: AppThemes.darkTheme));
    } else {
      emit(ThemeState(themeData: AppThemes.lightTheme));
    }
  }

  void setLightTheme() {
    emit(ThemeState(themeData: AppThemes.lightTheme));
  }

  void setDarkTheme() {
    emit(ThemeState(themeData: AppThemes.darkTheme));
  }
}
