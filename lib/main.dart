import 'package:flutter/material.dart';
import 'package:test_app/ui/home.dart';

const String appName = 'Geidea Example';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      home: const Home(
        appName: appName,
      ),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: Colors.red,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: Colors.red,
        ),
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
