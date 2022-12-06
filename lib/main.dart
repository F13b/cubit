import 'package:cubit_pr/cubit/cubit/themecubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;
    return BlocProvider(
      create: (ctx) => AppTheme(),
      child: Builder(builder: (context) {
        return BlocBuilder<AppTheme, ThemecubitState>(
          builder: (context, state) {
            if (state is ThemeChange) {
              themeMode = state.currentTheme;
            }

            return MaterialApp(
              theme: ThemeData(
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
              ),
              themeMode: themeMode,
              title: 'Material App',
              home: Scaffold(
                appBar: AppBar(
                  title: Text('Material App Bar'),
                ),
                body: body(),
              ),
            );
          },
        );
      }),
    );
  }
}

class body extends StatefulWidget {
  body({
    Key? key,
  }) : super(key: key);

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  int currentValue = 0;

  List<String> currentValues = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () => context.read<AppTheme>().changeTheme(
                    Theme.of(context).brightness == Brightness.light
                        ? ThemeMode.dark
                        : ThemeMode.light),
                child: Text("Change theme")),
            ElevatedButton(
                onPressed: () => context.read<AppTheme>().countheme(
                    Theme.of(context).brightness == Brightness.light
                        ? ThemeMode.light
                        : ThemeMode.dark),
                child: Text("Add value")),
          ],
        ),
        BlocListener<AppTheme, ThemecubitState>(
            listener: (context, state) {
              if (state is ThemeCount) {
                setState(() {
                  currentValue += state.Addvalue;
                  currentValues.add(
                      "Current theme - ${state.currentTheme.name}, count - ${currentValue.toString()}");
                });
              }
            },
            child: Expanded(
              child: ListView(
                children: currentValues.map((e) => Text(e)).toList(),
              ),
            ))
      ],
    );
  }
}
