import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bbox/model/demande.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/demande_controller.dart';
import 'widget/formText.dart';

class ReponseDemande extends StatefulWidget {
  const ReponseDemande(
      {super.key, required this.img, required this.server, required this.lot});
  final String server;
  final String img;
  final String lot;

  @override
  State<ReponseDemande> createState() => _ReponseDemandeState();
}

class _ReponseDemandeState extends State<ReponseDemande> {
  List<ModelDemande> demande = [];
  bool isVisible = false;
  String id = '1010';
  late String? user;
  TextEditingController message = TextEditingController();

  Future chechLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = pref.getString('username');
    if (user != null) {
      final response =
          await ApiService.allData(widget.server, user!, widget.lot);
      setState(() {
        demande = response;
      });
    } else {
      print('error 404');
    }
  }

  Future<void> saveMessage(String id) async {
    final url =
        Uri.parse('http://${widget.server}:5000/bboxx/support/reclamation');
    var response = await http.post(url,
        body: ({
          '_id': id,
          'message': message.text,
          'sender': 'agent',
          'codeAgent': user
        }));
    if (response.statusCode == 200) {
      final nom = response.body;
      final result = jsonDecode(nom);
      print(result);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'Message envoye',
        style: GoogleFonts.raleway(color: Colors.red),
      )));
      message.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    chechLogin();
  }

  void showmodalBottom(
    String id,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 130,
            // width: double.infinity,
            color: Colors.white,
            child: Column(children: [
              TextFieldForm(text: id, controller: message),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        saveMessage(id);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Envoyez',
                        style: GoogleFonts.raleway(fontSize: 15),
                      )),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Mes demandes',
            style: GoogleFonts.raleway(color: Colors.blue, fontSize: 15),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_circle_left_outlined,
                color: Colors.blue,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isVisible = true;
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.blue,
                  )),
            ),
            Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: screenWidth * 0.5,
                        child: TextFormField(),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = false;
                            });
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              children: demande
                  .map((e) => Column(
                        children: [
                          GestureDetector(
                            onTap: () => showmodalBottom(
                              e.id,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: screenWidth * 0.85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        double minWidth = constraints.minWidth;
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const CircleAvatar(
                                                backgroundColor:
                                                    Colors.redAccent,
                                                radius: 20,
                                                child: Center(
                                                  child: Icon(Icons
                                                      .arrow_circle_right_outlined),
                                                ),
                                              ),
                                              SizedBox(
                                                width: minWidth * 0.02,
                                              ),
                                              Container(
                                                width: minWidth * 0.75,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        Colors.grey.shade100),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        " id_demande :${e.idDemande};",
                                                        style:
                                                            GoogleFonts.raleway(
                                                                fontSize: 15),
                                                      ),
                                                      Text(
                                                        "${e.statut}; ${e.country}; ${e.reference}; ${e.sector};",
                                                        style:
                                                            GoogleFonts.raleway(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "${e.createdAt};",
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ],
                                                      ),
                                                      e.valide
                                                          ? Center()
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "en attente de reponse",
                                                                  style: GoogleFonts.raleway(
                                                                      fontSize:
                                                                          10,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                                ),
                                                              ],
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.02,
                          ),
                          e.valide
                              ? Column(
                                  children: e.reponse
                                      .map((e) => GestureDetector(
                                          onTap: () {
                                            showmodalBottom(e.id);
                                          },
                                          child: viewResponse(e, screenWidth)))
                                      .toList(),
                                )
                              : Center()
                        ],
                      ))
                  .toList()),
        ));
  }
}

Widget viewResponse(Reponse reponse, double screenWidth) {
  return Column(children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: screenWidth * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double minWidth = constraints.minWidth;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 20,
                        child: Center(
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                      SizedBox(
                        width: minWidth * 0.02,
                      ),
                      Container(
                        width: minWidth * 0.75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blueAccent),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "nom client : ${reponse.nomClient};\n id_demande : ${reponse.idDemande};",
                                style: GoogleFonts.raleway(fontSize: 15),
                              ),
                              Text(
                                "${reponse.idDemande}; ${reponse.codeClient}; \nAccount statut: ${reponse.clientStatut}; \nTime to expired: ${reponse.consExpDays};",
                                style: GoogleFonts.raleway(
                                    fontSize: 15, color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${reponse.createdAt};",
                                    style: GoogleFonts.raleway(fontSize: 15),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  ]);
}
