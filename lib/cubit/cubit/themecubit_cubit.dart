import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'themecubit_state.dart';

class AppTheme extends Cubit<ThemecubitState> {
  AppTheme() : super(CubitThemeInitial());

  void countheme(ThemeMode themeMode) {
    emit(ThemeCount(currentTheme: themeMode));
  }

  void changeTheme(ThemeMode themeMode) {
    emit(ThemeChange(currentTheme: themeMode));
  }
}
