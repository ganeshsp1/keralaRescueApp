import 'dart:convert' as JSON;
import 'package:http/http.dart';

Future<List> getAnnoucements() async {
  var client = Client();
  var apiUrl = "https://kerala-rescue-api.herokuapp.com/annoucements?page=1";
  var response = await client.get(apiUrl);
  List ancJson = JSON.jsonDecode(response.body);
  return ancJson;
}
