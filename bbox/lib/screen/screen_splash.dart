import 'package:bbox/screen/setting.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../upload.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  Future<void> loginCheck() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var val = pref.getString('username');
    if (val == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingPage(),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Upload(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Icon(
          Icons.app_settings_alt_outlined,
          color: Colors.blue,
        ),
      ),
    );
  }
}
