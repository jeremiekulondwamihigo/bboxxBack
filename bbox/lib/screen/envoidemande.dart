import 'dart:io';
import 'package:bbox/Data/datajson.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widget/formText.dart';

class EnvoiDemande extends StatefulWidget {
  const EnvoiDemande({super.key, required this.img, required this.server});
  final String server;
  final String img;

  @override
  State<EnvoiDemande> createState() => _EnvoiDemandeState();
}

class _EnvoiDemandeState extends State<EnvoiDemande> {
  TextEditingController codeclient = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController codezone = TextEditingController();
  TextEditingController raison = TextEditingController();
  TextEditingController reference = TextEditingController();
  TextEditingController sat = TextEditingController();
  TextEditingController quartier = TextEditingController();
  TextEditingController commune = TextEditingController();
  TextEditingController ville = TextEditingController();
  TextEditingController province = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();
  bool isVisible = false;
  // dropboxbutton
  String? valeurEtatBatterie;
  List listvalue = ['allumer', 'eteint'];

  //
  String url = '';
  String lat = 'Latitude';
  String long = 'Longetude';
  String atitude = '';
  FilePickerResult? _file;
  String? filename;
  late String? user;
  late String? zone;
  File? _image;
  var names;

  Future chechLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = pref.getString('username');
    zone = pref.getString('zone');
    if (user != null) {
    } else {
      print('error 404');
    }
  }

  @override
  void initState() {
    super.initState();
    chechLogin();
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

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final imageTemp = File(image.path);
    print(imageTemp);

    setState(() {
      names = image.name;
      this._image = imageTemp;
    });
  }

  void uploadImage(File file) async {
    if (file != null) {
      try {
        FormData formData = FormData.fromMap({
          "codeAgent": user,
          "codeZone": zone,
          "codeclient": codeclient.text,
          "typeImage": "photo",
          "latitude": lat,
          "longitude": long,
          "altitude": atitude,
          "statut": 'allumer',
          "raison": raison.text,
          "province": province.text,
          "country": ville.text,
          "sector": quartier.text,
          "cell": commune.text,
          "reference": reference.text,
          "sat": sat.text,
          "file": await MultipartFile.fromFile(file.path, filename: names),
          // "file": await MultipartFile.fromFile(file.path as String,
          //     filename: file.name),
        });
        Response response = await Dio().post(
            'http://${widget.server}:5000/bboxx/support/demande',
            data: formData);
        print("$response");
      } catch (e) {
        print("Erreur:$e");
      }
      raison.clear();
      adresse.clear();
      codeclient.clear();
      reference.clear();
      sat.clear();
      lat = '';
      long = '';
      quartier.clear();
      valeurEtatBatterie = '';
      ville.clear();
      province.clear();
      commune.clear();
      _image!.delete();
    } else {
      // User canceled the picker
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Le service est desactiver');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Non permis');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Forever');
    }

    return await Geolocator.getCurrentPosition();
  }

  DateTime data = DateTime.now();
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
          'Envoi de demande',
          style: GoogleFonts.raleway(fontSize: 15, color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Demande',
                    style: GoogleFonts.raleway(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Enregistrement de demande',
                    style: GoogleFonts.raleway(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '---Code du client',
                    style: GoogleFonts.raleway(
                        color: Colors.green, fontStyle: FontStyle.italic),
                  ),
                ),
                TextFieldForm(text: 'Code client', controller: codeclient),
                //
                // debut -------- adresse
                //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '---Adresse du client',
                    style: GoogleFonts.raleway(
                        color: Colors.green, fontStyle: FontStyle.italic),
                  ),
                ),
                TextFieldForm(text: 'Avenue et numero', controller: adresse),
                TextFieldForm(text: 'Quartier', controller: quartier),
                TextFieldForm(text: 'Commune', controller: commune),
                TextFieldForm(text: 'Ville', controller: ville),
                TextFieldForm(text: 'Province', controller: province),
                TextFieldForm(text: 'Reference', controller: reference),
                TextFieldForm(text: 'SAT', controller: sat),
                //
                // debut GPS
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '---Latitude et Longetitude',
                    style: GoogleFonts.raleway(
                        color: Colors.green, fontStyle: FontStyle.italic),
                  ),
                ),
                Container(
                  height: screenHeight * 0.08,
                  width: screenWidth,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double minHeigth = constraints.minHeight;
                      double minWidth = constraints.minWidth;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Zidget(
                                minHeigth: minHeigth,
                                minWidth: minWidth,
                                lat: lat),
                            Zidget(
                                minHeigth: minHeigth,
                                minWidth: minWidth,
                                lat: long),
                            GestureDetector(
                              onTap: () {
                                getCurrentLocation().then((value) {
                                  setState(() {
                                    lat = '${value.latitude}';
                                    long = '${value.longitude}';
                                    atitude = '${value.altitude}';
                                  });
                                });
                              },
                              child: Container(
                                height: minHeigth,
                                width: minWidth * 0.15,
                                decoration: BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(Icons.gps_fixed),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                //
                // etat batterie
                //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '---Etat de C.U',
                    style: GoogleFonts.raleway(
                        color: Colors.green, fontStyle: FontStyle.italic),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: screenHeight * 0.07,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromRGBO(255, 255, 255, 1)),
                    child: DropdownButton(
                      hint: Text(
                        'Etat C.U',
                        style: GoogleFonts.raleway(fontSize: 15),
                      ),
                      padding: const EdgeInsets.all(8),
                      style: GoogleFonts.raleway(color: Colors.black54),
                      underline: Container(),
                      focusColor: Colors.white,
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      value: valeurEtatBatterie,
                      items: listvalue
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          valeurEtatBatterie = value as String?;
                        });
                      },
                    ),
                  ),
                ),
                TextFieldForm(text: 'Raison', controller: raison),
                _image != null
                    ? Image.file(
                        _image!,
                        width: screenWidth,
                        height: screenHeight * 0.3,
                        fit: BoxFit.cover,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              height: screenHeight * 0.05,
                              width: screenWidth / 2.3,
                              child: ElevatedButton(
                                  onPressed: () {
                                    getImage(ImageSource.camera);
                                  },
                                  child: Text(
                                    'Prendre une photo',
                                    style: GoogleFonts.raleway(fontSize: 15),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              height: screenHeight * 0.05,
                              width: screenWidth / 2.3,
                              child: ElevatedButton(
                                  onPressed: () {
                                    getImage(ImageSource.gallery);
                                  },
                                  child: Text(
                                    'Ajouter une photo',
                                    style: GoogleFonts.raleway(fontSize: 15),
                                  )),
                            ),
                          ),
                        ],
                      ),
                Container(
                  height: screenHeight * 0.07,
                  width: screenWidth,
                  child: ElevatedButton(
                      onPressed: () {
                        if (codeclient.text.isNotEmpty &&
                            _image != null &&
                            adresse.text.isNotEmpty &&
                            raison.text.isNotEmpty &&
                            province.text.isNotEmpty &&
                            valeurEtatBatterie!.isNotEmpty &&
                            ville.text.isNotEmpty &&
                            quartier.text.isNotEmpty) {
                          uploadImage(_image!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'Veuillez tout completer',
                            style: GoogleFonts.raleway(color: Colors.red),
                          )));
                        }
                      },
                      child: Text(
                        'Enregistrer',
                        style: GoogleFonts.raleway(fontSize: 15),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget dropButtonWidget(List list, String values, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Container(
      // height: 0.75,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: DropdownButton(
        value: values,
        hint: Text(
          text,
          style: GoogleFonts.raleway(),
        ),
        items: list
            .map((e) => DropdownMenuItem(value: values, child: Text(e)))
            .toList(),
        onChanged: (value) {
          values == value;
        },
      ),
    ),
  );
}
