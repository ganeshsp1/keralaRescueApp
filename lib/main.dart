import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keralarescue/services/annoucements.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
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
  void _incrementCounter() {
    setState(() {
      _controller.loadUrl('https://keralarescue.in/announcements');
    });
  }

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
                //         showDialog(
                //   context: context,
                //   builder: (context) => AlertDialog(
                //     content: showGalleryAboutDialog(context),

                //     // ListTile(
                //     //   title: Text('About'),
                //     //   subtitle: Text('This app is created by Ganesh S P. \n you can also contribute to it at \n https://github.com/ganeshsp1/keralaRescue'),
                //     // ),
                //     actions: <Widget>[
                //       FlatButton(
                //         child: Text('Ok'),
                //         onPressed: () => Navigator.of(context).pop(),
                //       ),
                //     ],
                //   ),
                // );
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
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => AnnoucementsPage())),
        tooltip: 'Increment',
        child: Icon(Icons.notification_important),
      ),
    );
  }

  Color getTileColor(String item) {
    switch (item) {
      case 'H':
        return Colors.redAccent;
        break;
      case 'M':
        return Colors.orange;
        break;
      case 'L':
        return Colors.blue;
        break;
      default:
        return Colors.white30;
    }
  }

  Widget getList(item) {
    print(item['description']);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          color: getTileColor(item['priority']),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // GestureDetector(
              //   onTap: () {
              // if(widget.article.hyperlink!=null)
              // _launchURL(widget.article.hyperlink);
              // },
              // child: Container(
              //   height: 120,
              //   child: widget.article.imageLink != null
              //       ? Image.asset(widget.article.imageLink,
              //           fit: BoxFit.fitWidth)
              //       : Image.network(
              //           widget.article.imageUrl,
              //         ),
              // ),
              // ),
              // Container(
              //   height: 20,
              //   child: widget.article.hyperlink == null
              //       ? Container()
              //       : RaisedButton(
              //           color: Colors.black38,
              //           onPressed: () {
              //             _launchURL(widget.article.hyperlink);
              //           },
              //           child: Text(
              //             widget.article.hyperlink,
              //             textAlign: TextAlign.center,
              //             style: TextStyle(color: Colors.white),
              //           ),
              //         ),
              //   // decoration: BoxDecoration(
              //   //   color: Colors.black38,
              //   // ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      // height: 23,
                      child: Text(
                        item['description'],
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      item['hashtags'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: SizedBox(
              //     width: 300,
              //     height: 35,
              //     child: Text(
              //       widget.article.intro,
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnnoucementsPage extends StatefulWidget {
  @override
  _AnnoucementsPageState createState() => _AnnoucementsPageState();
}

class _AnnoucementsPageState extends State<AnnoucementsPage> {
  @override
  void initState() {
    super.initState();
    // getAnnoucements();
  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text("Annoucements"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder(
              future: getAnnoucements(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text("Error : ${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  default:
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Color _cd = Colors.white;
                          if (snapshot.data[index]["priority"] ==
                              "Very Important") {
                            _cd = Colors.red[500];
                          } else {
                            _cd = Colors.amberAccent;
                          }
                          return Container(
                              child: Card(
                            child: GroovinExpansionTile(
                              leading: Chip(
                                backgroundColor: _cd,
                                label: Text(snapshot.data[index]["priority"]),
                              ),
                              title: Text(snapshot.data[index]["timestamp"]),
                              backgroundColor: _cd,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(snapshot.data[index]["data"]),
                                )
                              ],
                            ),
                          ));
                        });
                }
              }),
        ),
      ),
    );
  }
}
