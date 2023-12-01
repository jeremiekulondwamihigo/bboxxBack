import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/demande.dart';

class ApiService {
  static String url = 'http://192.168.244.230:5000/bboxx/support/';

  static Future<List<ModelDemande>> allData(
      String server, String id, String lot) async {
    final uri =
        Uri.parse('http://$server:5000/bboxx/support/demandeAll/$lot/$id');
    final response = await http.get(uri);
    final json = response.body;
    final result = jsonDecode(json);
    final user = result as List<dynamic>;
    final data = user.map((e) {
      return ModelDemande.fromJson(e);
    }).toList();
    return data;
  }

  static Future<List<Periode>> allPeriode(String server, String id) async {
    final uri = Uri.parse('http://$server:5000/bboxx/support/paquet/$id');
    final response = await http.get(uri);
    final json = response.body;
    final result = jsonDecode(json);
    final user = result as List<dynamic>;
    final data = user.map((e) {
      return Periode.fromJson(e);
    }).toList();
    return data;
  }
}
