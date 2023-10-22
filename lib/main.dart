import 'package:flutter/material.dart';
import 'package:multi_counter_app/all_groups_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadAppValues();
  runApp(const MyApp());
}

Future<void> loadAppValues() async {
  final prefs = await SharedPreferences.getInstance();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AllGroupsScreen(),
    );
  }
}
