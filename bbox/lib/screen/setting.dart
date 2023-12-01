import 'package:bbox/screen/login.dart';
import 'package:bbox/screen/menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widget/formText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController server = TextEditingController();
  TextEditingController img = TextEditingController();
  TextEditingController agent = TextEditingController();

  Future<void> loginCheck() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var val = pref.getString('username');
    if (val == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(img: img.text, server: server.text),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(
              img: img.text,
              server: server.text,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.15,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Configuration du server',
                  style: GoogleFonts.raleway(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Enregistrement',
                  style: GoogleFonts.raleway(fontSize: 15),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.09,
              ),
              TextFieldForm(controller: server, text: 'Adresse du serveur'),
              TextFieldForm(controller: img, text: 'Adresse image'),
              Container(
                height: screenHeight * 0.07,
                width: screenWidth,
                child: ElevatedButton(
                    onPressed: () {
                      loginCheck();
                    },
                    child: Text(
                      'Enregistrer',
                      style: GoogleFonts.raleway(fontSize: 18),
                    )),
              ),
              SizedBox(
                height: screenHeight * 0.38,
              ),
              const Center(
                child: Text(
                  'Copy rigth @HelpME',
                  style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
