import 'package:bbox/controller/conversation_controller.dart';
import 'package:bbox/model/conversation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationUi extends StatefulWidget {
  const ConversationUi({
    super.key,
    required this.server,
    required this.id,
  });
  final String server;
  final String id;

  @override
  State<ConversationUi> createState() => _ConversationUiState();
}

class _ConversationUiState extends State<ConversationUi> {
  List<Conversation> conversation = [];
  late String? user;
  TextEditingController message = TextEditingController();

  Future chechConversation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = pref.getString('username');
    if (user != null) {
      final response =
          await ApiServiceConversation.allData(widget.server, widget.id);
      setState(() {
        conversation = response;
      });
    } else {
      print('error 404');
    }
  }

  @override
  void initState() {
    super.initState();
    chechConversation();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Conversation',
          style: GoogleFonts.raleway(fontSize: 15, color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // SizedBox(
                //   height: screenHeight * 0.05,
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: conversation
                      .map(
                        (e) => e.sender == "agent"
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    e.demandeId.isNotEmpty
                                        ? Column(
                                            children: e.demandeId
                                                // ignore: unnecessary_null_comparison
                                                .map(
                                                    (e) => haut(e, screenWidth))
                                                .toList(),
                                          )
                                        : Column(
                                            children: e.reponseId
                                                .map((e) => bas(e, screenWidth))
                                                .toList(),
                                          ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: screenWidth * 0.65,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color: Color.fromARGB(
                                              255, 52, 130, 194)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${e.message}",
                                              style: GoogleFonts.raleway(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${e.createdAt}",
                                              style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    e.demandeId.isNotEmpty
                                        ? Column(
                                            children: e.demandeId
                                                // ignore: unnecessary_null_comparison
                                                .map(
                                                    (e) => haut(e, screenWidth))
                                                .toList(),
                                          )
                                        : Column(
                                            children: e.reponseId
                                                .map((e) => bas(e, screenWidth))
                                                .toList(),
                                          ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: screenWidth * 0.65,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color:
                                              Color.fromARGB(255, 13, 59, 96)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${e.message}",
                                              style: GoogleFonts.raleway(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${e.createdAt}",
                                              style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      )
                      .toList(),
                ),
              ],
            )),
      ),
    );
  }
}

Widget haut(DemandeId demande, double width) {
  return Container(
    alignment: Alignment.centerLeft,
    width: width * 0.65,
    decoration: BoxDecoration(color: Colors.grey.shade100),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${demande.idDemande}, ${demande.province} ${demande.country} ${demande.sector}; ${demande.statut}",
            style: GoogleFonts.raleway(),
          ),
          Text(
            "${demande.createdAt}",
            style: GoogleFonts.raleway(fontSize: 9),
          ),
        ],
      ),
    ),
  );
}

Widget bas(ReponseId demande, double width) {
  return Container(
    alignment: Alignment.centerLeft,
    width: width * 0.65,
    decoration: BoxDecoration(color: Colors.grey.shade100),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        "${demande.idDemande}, ${demande.payementStatut} \n${demande.createdAt}",
        style: GoogleFonts.raleway(),
      ),
    ),
  );
}
