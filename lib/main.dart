import 'dart:io';
import 'package:flutter/material.dart';
import 'package:keralarescue/annoucements.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'about.dart';
// import 'package:translator'

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kerala Rescue',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Kerala Rescue'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final databaseReference = FirebaseDatabase.instance.reference();
  WebViewController _controller;
  // DatabaseReference _childRef;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.subscribeToTopic('announcements');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        setState(() {
          _controller.loadUrl('https://keralarescue.in/announcements');
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        setState(() {
          _controller.loadUrl('https://keralarescue.in/announcements');
        });
      },
    );
    // _childRef = FirebaseDatabase.instance.reference().child('announcements');

    // _childRef.keepSynced(true);
    // _counterSubscription = _counterRef.onValue.listen((Event event) {
    //   setState(() {
    //     _error = null;
    //     // _counter = event.snapshot.value ?? 0;

    //     _list = event.snapshot.value;
    //   });
    // }, onError: (Object o) {
    //   final DatabaseError error = o;
    //   setState(() {
    //     _error = error;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Kerala Rescue'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _controller.loadUrl('https://keralarescue.in');
                });
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                showGalleryAboutDialog(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebView(
        initialUrl: 'https://keralarescue.in/',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
      ),
      floatingActionButton: FloatingActionButton(
        /* Push to annoucements page */
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => AnnoucementsPage())),
        tooltip: 'Increment',
        child: Icon(Icons.notification_important),
      ),
    );
  }
}
