import 'dart:convert';
import 'package:bbox/model/conversation.dart';
import 'package:http/http.dart' as http;

class ApiServiceConversation {
  static String url = 'http://192.168.244.230:5000/bboxx/support/';

  static Future<List<Conversation>> allData(String server, String id) async {
    final uri =
        Uri.parse('http://$server:5000/bboxx/support/reclamation/$id');
    final response = await http.get(uri);
    final json = response.body;
    final result = jsonDecode(json);
    final user = result['conversation'] as List<dynamic>;
    final data = user.map((e) {
      return Conversation.fromJson(e);
    }).toList();
    return data;
  }
}
