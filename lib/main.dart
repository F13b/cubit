import 'dart:async';

import 'package:cubit_pr/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  ThemeMode currentMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: currentMode,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      title: 'Cubit App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cubit PR App Bar'),
        ),
        body: BlocProvider(
          create: (context) => InitThemeCubit(),
          child: BodyWidget(
            changeMode: (currentMode) => setState(() {
              this.currentMode = currentMode;
            }),
          ),
        ),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  BodyWidget({Key? key, required this.changeMode}) : super(key: key);
  void Function(ThemeMode currentMode) changeMode;

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  List<String> values = [];
  late Timer _timer;
  SharedPreferences? currentPrefs;
  int currentValue = 0;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      currentPrefs = value;
      if (currentPrefs!.containsKey("count")) {
        setState(() {
          currentPrefs = value;
          values = value.getStringList("count")!;
          currentValue = value.getInt("value")!;
        });
      }
      if (currentPrefs!.containsKey('theme')) {
        context
            .read<InitThemeCubit>()
            .changeTheme(ThemeMode.values[value.getInt('theme')!]);
      }
    });
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      context.read<InitThemeCubit>().calculateTheme(
          Theme.of(context).brightness == Brightness.light
              ? ThemeMode.light
              : ThemeMode.dark,
          false);
    });
    super.initState();
  }

  Timer getTimer() => Timer.periodic(Duration(seconds: 5), (timer) {
        context.read<InitThemeCubit>().calculateTheme(
            Theme.of(context).brightness == Brightness.light
                ? ThemeMode.light
                : ThemeMode.dark,
            false);
      });

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitThemeCubit, ThemeCubitState>(
      listener: (context, state) {
        if (state is ThemeValueState) {
          setState(() {
            currentValue += state.curValue;
            values.add(
                "Theme: ${state.curTheme.name}, Count: $currentValue");
          });

          currentPrefs?.setStringList("count", values);
          currentPrefs?.setInt("value", currentValue);
        } else if (state is ThemeModeState) {
          widget.changeMode(state.curTheme);
          currentPrefs?.setInt("theme", state.curTheme.index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView(
                children: values.map((e) => Center(child: Text(e))).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    FloatingActionButton(
                        onPressed: () {
                          _timer.cancel();
                          _timer = getTimer();
                          context.read<InitThemeCubit>().calculateTheme(
                              Theme.of(context).brightness == Brightness.light
                                  ? ThemeMode.light
                                  : ThemeMode.dark,
                              false);
                        },
                        child: Icon(Icons.add)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          _timer.cancel();
                          _timer = getTimer();
                          context.read<InitThemeCubit>().calculateTheme(
                              Theme.of(context).brightness == Brightness.light
                                  ? ThemeMode.light
                                  : ThemeMode.dark,
                              true);
                        },
                        child: Icon(Icons.remove),
                      ),
                    ),
                  ],
                ),
                Text(currentValue.toString()),
                Column(
                  children: [
                    FloatingActionButton(
                      onPressed: () => context.read<InitThemeCubit>().changeTheme(
                          Theme.of(context).brightness == Brightness.light
                              ? ThemeMode.dark
                              : ThemeMode.light),
                      child: Icon(Icons.favorite_border_outlined),
                    ),
                    if (currentPrefs != null &&
                        currentPrefs!.containsKey("count"))
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            currentPrefs!.clear();
                            setState(() {
                              values.clear();
                              currentValue = 0;
                              _timer.cancel();
                          _timer = getTimer();
                            });
                          },
                          child: Icon(Icons.delete),
                        ),
                      ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
