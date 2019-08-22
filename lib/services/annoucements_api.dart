import 'package:firebase_database/firebase_database.dart';

/*
GET request to api and fetch the information
json is parsed to dart object
API caches the request upto 30 mins
API is hosted on herokuapp.com
*/

Future<List<Post>> getAnnoucements() async {
  var dBRef;
  dBRef = FirebaseDatabase.instance.reference().child("announcements");
  DataSnapshot dbData = await dBRef.once();
  List<Post> posts = [];
  RegExp regex = RegExp(r"^([^.]+)");
  for (var p in dbData.value) {
    var title = regex.allMatches(p['description']).elementAt(0).group(1);
    Post _post = Post(
        data: p['description'],
        title: title,
        date: p['dateadded'],
        priority: p['priority']);
    posts.add(_post);
  }
  return posts;
}

class Post {
  final String title;
  final String date;
  final String data;
  final String priority;
  Post({this.title, this.date, this.data, this.priority});
}
