part of 'theme_cubit.dart';

@immutable
abstract class ThemeCubitState {}

class ThemecubitInitial extends ThemeCubitState {
  ThemecubitInitial();
}

class ThemeModeState extends ThemeCubitState {
  ThemeMode curTheme;
  ThemeModeState({
    required this.curTheme,
  });
}


class ThemeValueState extends ThemeCubitState {
  ThemeMode curTheme;
  int curValue;
  ThemeValueState(
      {required this.curTheme, required this.curValue});
}
