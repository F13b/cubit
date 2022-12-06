part of 'themecubit_cubit.dart';

@immutable
abstract class ThemecubitState {}

class CubitThemeInitial extends ThemecubitState {}

class ThemeChange extends ThemecubitState {
  ThemeMode currentTheme;
  ThemeChange({
    required this.currentTheme,
  });
}

class ThemeCount extends ThemecubitState {
  ThemeMode currentTheme;
  late int Addvalue;
  ThemeCount({
    required this.currentTheme,
  }) {
    if (currentTheme == ThemeMode.dark)
      Addvalue = 2;
    else
      Addvalue = 1;
  }
}
