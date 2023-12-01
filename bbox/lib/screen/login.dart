import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'menu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.img, required this.server});
  final String server;
  final String img;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  DateTime data = DateTime.now();

  Future<void> loginSession() async {
    final url = Uri.parse('http://${widget.server}:5000/bboxx/support/login');
    var response = await http.post(url,
        body: ({
          'username': username.text,
          'password': password.text,
          'identifiant': 'agent'
        }));
    if (response.statusCode == 200) {
      final nom = response.body;
      final result = jsonDecode(nom);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('username', result['codeAgent']);
      await pref.setString('identite', result['nom']);
      await pref.setString('zone', result['codeZone']);
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MenuScreen(img: widget.img, server: widget.server),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
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
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Bienvenu a vous',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Connectez vous',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "${data}",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.07,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextFormField(
                    controller: username,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      } else {
                        return 'Veuillez remplir le champs';
                      }
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Matricule',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextFormField(
                    controller: password,
                    obscureText: true,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      } else {
                        return 'Veuillez remplir le champs';
                      }
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      hintText: 'Mot de passe',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    )),
              ),
              Container(
                height: screenHeight * 0.07,
                width: screenWidth,
                child: ElevatedButton(
                    onPressed: () {
                      if (username.text.isNotEmpty &&
                          password.text.isNotEmpty) {
                        loginSession();
                      } else {
                        SnackBar(
                            content: ScaffoldMessenger(
                                child: Text(
                          "Désole veuillez remplir les champs",
                          style: GoogleFonts.raleway(),
                        )));
                      }
                    },
                    child: Text(
                      'Connexion',
                      style: GoogleFonts.raleway(fontSize: 18),
                    )),
              ),
              SizedBox(
                height: screenHeight * 0.36,
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
