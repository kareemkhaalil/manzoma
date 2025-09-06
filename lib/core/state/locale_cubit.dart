import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(): super(const Locale('en'));

  void setEnglish() => emit(const Locale('en'));
  void setArabic() => emit(const Locale('ar'));
}
