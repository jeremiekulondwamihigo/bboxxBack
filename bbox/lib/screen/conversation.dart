import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bbox/controller/conversation_controller.dart';
import 'package:bbox/model/conversation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widget/formText.dart';

class ConversationUi extends StatefulWidget {
  const ConversationUi(
      {super.key,
      required this.server,
      required this.id,
      required this.idDemande});
  final String server;
  final String idDemande;
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

  Future<void> saveMessage() async {
    final url =
        Uri.parse('http://${widget.server}:5000/bboxx/support/reclamation');
    var response = await http.post(url,
        body: ({
          'idDemande': widget.idDemande,
          'message': message.text,
          'sender': 'agent',
          'codeAgent': user
        }));
    if (response.statusCode == 200) {
      final nom = response.body;
      final result = jsonDecode(nom);
      print(result);
      final responses =
          await ApiServiceConversation.allData(widget.server, widget.id);
      setState(() {
        conversation = responses;
      });
      message.clear();
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
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: conversation
                      .map(
                        (e) => e.sender == "agent"
                            ? Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: screenWidth * 0.65,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "${e.message}\n${e.createdAt}",
                                      style: GoogleFonts.raleway(),
                                    ),
                                  ),
                                ),
                            )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: screenWidth * 0.65,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        "${e.message}\n${e.createdAt}",
                                        style: GoogleFonts.raleway(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      )
                      .toList(),
                ),
              ],
            )),
      ),
      bottomSheet: Row(
        children: [
          Container(
              width: screenWidth * 0.85,
              child: TextFieldForm(
                  text: 'envoyez le message', controller: message)),
          IconButton(
              onPressed: () => saveMessage(), icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
