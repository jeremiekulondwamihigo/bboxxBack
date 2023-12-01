import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget formText(
  TextEditingController controller,
  String text,
  int ligne,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      controller: controller,
      maxLines: ligne,
      validator: (value) {
        if (value!.isEmpty) {
          return null;
        } else {
          return 'Champs obligatoire';
        }
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
          labelText: text,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
    ),
  );
}

Widget formTextString(String string, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      readOnly: true,
      initialValue: string,
      validator: (value) {
        if (value!.isEmpty) {
          return null;
        } else {
          return 'Champs obligatoire';
        }
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
          hintText: text,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
    ),
  );
}


class Zidget extends StatelessWidget {
  const Zidget({
    super.key,
    required this.minHeigth,
    required this.minWidth,
    required this.lat,
  });

  final double minHeigth;
  final double minWidth;
  final String lat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        height: minHeigth,
        width: minWidth * 0.4,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(2)),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 10),
          child: Text(
            lat,
            style: GoogleFonts.raleway(fontSize: 16, color: Colors.black45),
          ),
        ),
      ),
    );
  }
}

class TextFieldForm extends StatelessWidget {
  const TextFieldForm({
    required this.text,
    required this.controller,
    super.key,
  });
  final String text;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
          controller: controller,
          cursorColor: Colors.black,
          style: GoogleFonts.raleway(color: Colors.black45, fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.note),
            hintText: text,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          )),
    );
  }
}


class TextInfo extends StatelessWidget {
  const TextInfo({
    required this.minWidth,
    required this.text,
    required this.val,
    super.key,
  });
  final double minWidth;
  final String text;
  final String val;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: minWidth * 0.4,
            child: Text(
              '$text :',
              style: GoogleFonts.raleway(fontSize: 15),
            ),
          ),
          Container(
            width: minWidth * 0.5,
            child: Text(
              val,
              style: GoogleFonts.raleway(fontSize: 15, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}


