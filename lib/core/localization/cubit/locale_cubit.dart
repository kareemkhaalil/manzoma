import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:manzoma/core/localization/cubit/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState(locale: const Locale('en')));

  void changeLanguage(String languageCode) {
    emit(LocaleState(locale: Locale(languageCode)));
  }

  void toggleLanguage() {
    if (state.locale.languageCode == 'en') {
      emit(LocaleState(locale: const Locale('ar')));
    } else {
      emit(LocaleState(locale: const Locale('en')));
    }
  }

  void setEnglish() {
    emit(LocaleState(locale: const Locale('en')));
  }

  void setArabic() {
    emit(LocaleState(locale: const Locale('ar')));
  }
}
