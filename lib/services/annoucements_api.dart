import 'dart:convert' as JSON;
import 'package:http/http.dart';


/*
GET request to api and fetch the information
json is parsed to dart object
API caches the request upto 30 mins
API is hosted on herokuapp.com
*/
Future<List<Post>> getAnnoucements() async {
  var client = Client();
  var apiUrl = "https://kerala-rescue-api.herokuapp.com/annoucements?page=1";
  var response = await client.get(apiUrl);
  var jsonData = JSON.jsonDecode(response.body);
  List<Post> posts = [];
  if (response.statusCode == 200) {
    for (var p in jsonData) {
      Post _post = Post(
          data: p['data'],
          title: p['title'],
          date: p['timestamp'],
          priority: p['priority']);
      posts.add(_post);
    }
  } else
    throw Exception('failed to load data');
  return posts;
}

class Post {
  final String title;
  final String date;
  final String data;
  final String priority;
  Post({this.title, this.date, this.data, this.priority});
}
