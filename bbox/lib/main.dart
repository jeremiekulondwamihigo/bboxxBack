
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screen/setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // var box = await Hive.openBox('bbooxx');
  // final all = box.toMap();
  // final url = all['url'];
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingPage(),
    );
  }
}
