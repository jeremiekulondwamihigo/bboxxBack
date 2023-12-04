import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/demande_controller.dart';
import '../model/demande.dart';
import 'reponse.dart';

class MesLotDemande extends StatefulWidget {
  const MesLotDemande({super.key, required this.server, required this.user});
  final String server;
  final String user;

  @override
  State<MesLotDemande> createState() => _MesLotDemandeState();
}

class _MesLotDemandeState extends State<MesLotDemande> {
  DateTime now = DateTime.now();
  List<Periode> periodes = [];
  Future allPeriodes() async {
    final response = await ApiService.allPeriode(widget.server, widget.user);
    setState(() {
      periodes = response;
    });
  }

  @override
  void initState() {
    super.initState();
    allPeriodes();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_circle_left_outlined,
              color: Colors.blue,
            )),
        title: Text(
          'Les paquets',
          style: GoogleFonts.raleway(fontSize: 15, color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Wrap(
                spacing: screenWidth * 0.02,
                children: periodes
                    .map((e) => GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReponseDemande(
                                    server: widget.server, img: '', lot: e.id),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${e.id}\n",
                                      style: GoogleFonts.raleway(
                                          fontSize: 16,
                                          color: Colors.redAccent),
                                    ),
                                    Text(
                                      "Demandes envoyes : ${e.demande}",
                                      style: GoogleFonts.raleway(
                                          fontSize: 14, color: Colors.green),
                                    ),
                                    Text(
                                      "Reponse recu : ${e.reponse}",
                                      style: GoogleFonts.raleway(
                                          fontSize: 14, color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
