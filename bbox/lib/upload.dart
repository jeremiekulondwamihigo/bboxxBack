import 'dart:convert';
import 'dart:io';
import 'package:bbox/model/conversation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'controller/conversation_controller.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  FilePickerResult? _file;
  File? _image;
  String? filename;
  var names;

  List<dynamic> date = [];
  Future<void> conversation() async {
    final uri = Uri.parse(
        'http://192.168.145.230:5000/bboxx/support/reclamation/655b9253b394b7ac6cb666d0');
    final response = await http.get(uri);
    final json = response.body;
    final result = jsonDecode(json);
    setState(() {
      date = result['conversation'];
    });
    print(date);
  }

  List<Conversation> conversations = [];
  void data() async {
    final response = await ApiServiceConversation.allData(
        '192.168.145.230', '655b9253b394b7ac6cb666d0');
    setState(() {
      conversations = response;
    });
    print(conversations);
  }

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    final imageTemp = File(image.path);
    print(imageTemp);

    setState(() {
      final name = File(image.name);
      names = name;
      print(names);
      filename = imageTemp.path;
      this._image = imageTemp;
    });
  }

  Future getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      _file = result;
      if (result != null) {
        PlatformFile file = result.files.first;
        filename = file.name;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    conversation();
    data();
  }

  String? valeur;
  List list = ['one', 'two', 'Free'];
    void dropboxcommand(String? selectvalue) {
    if (selectvalue is String) {
      setState(() {
        valeur = selectvalue;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => conversation(),
          child: Icon(Icons.add),
        ),
        body: Center(
          child: Container(
            child: DropdownButton(
              isExpanded: true,
              value: valeur,
              items: list
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  valeur=value as String?;
                });
              },
            ),
          ),
        ));
  }
}
