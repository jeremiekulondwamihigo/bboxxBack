import 'dart:async';

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
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingPage(),
          ));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingPage(),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      loginCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/icon.png'),
        ),
      ),
    );
  }
}
