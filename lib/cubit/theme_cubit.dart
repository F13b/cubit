import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_state.dart';

class InitThemeCubit extends Cubit<ThemeCubitState> {
  InitThemeCubit() : super(ThemecubitInitial());

  void changeTheme(ThemeMode theme) {
    emit(ThemeModeState(curTheme: theme));
  }

  void calculateTheme(ThemeMode theme, bool isDescreasing) {
    var curValue = theme == ThemeMode.light ? 1 : 2;
    if (isDescreasing) {
      curValue = curValue * -1;
    }
    emit(ThemeValueState(
        curTheme: theme,
        curValue: curValue));
  }
}
