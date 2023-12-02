import 'dart:async';
import 'package:bbox/screen/envoidemande.dart';
import 'package:bbox/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'conversation.dart';
import 'lot.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.img, required this.server});
  final String server;
  final String img;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // StreamController stream = StreamController();
  final data = DateTime.now().toString();
  String? nom = '';
  String? user;

  Future<void> loginCheck() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    nom = pref.getString('identite');
    user = pref.getString('username');
  }

  Future<void> delete() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('username');
    pref.remove('identite');
    pref.remove('zone');
    MaterialPageRoute(
      builder: (context) => LoginPage(
        img: widget.img,
        server: widget.server,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loginCheck();
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
                height: screenHeight * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Bienvenu $nom',
                  style: GoogleFonts.raleway(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Choisiz une operation',
                  style: GoogleFonts.raleway(fontSize: 15),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.08,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MesLotDemande(server: widget.server, user: user!),
                    )),
                child: MenuWidget(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    img: 'assets/parking-lot.png',
                    text: 'Paquet'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnvoiDemande(
                          img: widget.img,
                          server: widget.server,
                        ),
                      ));
                },
                child: MenuWidget(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    img: 'assets/send.png',
                    text: 'Envoi demande'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationUi(
                          id: user!,
                          server: widget.server,
                        ),
                      ));
                },
                child: MenuWidget(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    img: 'assets/boite-de-discussion.png',
                    text: 'Espace chat'),
              ),
              GestureDetector(
                onTap: () {
                  delete;
                },
                child: MenuWidget(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    img: 'assets/power.png',
                    text: 'Deconnexion'),
              ),
              SizedBox(
                height: screenHeight * 0.24,
              ),
              Center(
                child: Text(
                  'Copy rigth @HelpME',
                  style: GoogleFonts.raleway(
                      fontSize: 10, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.img,
    required this.text,
  });

  final double screenHeight;
  final double screenWidth;
  final String img;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        height: screenHeight * 0.1,
        width: screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                img,
                width: screenWidth * 0.1,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: screenWidth * 0.05,
              ),
              Text(
                text,
                style: GoogleFonts.raleway(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
