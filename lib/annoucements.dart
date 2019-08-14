import 'package:flutter/material.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
import 'package:keralarescue/services/annoucements_api.dart';

class AnnoucementsPage extends StatefulWidget {
  @override
  _AnnoucementsPageState createState() => _AnnoucementsPageState();
}

class _AnnoucementsPageState extends State<AnnoucementsPage> {
  bool isExpanded = false;
  Color _chipColor;
  Color _textColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text("Annoucements"),
      ),
      body: SingleChildScrollView(
        child: Container(
          /*
          Future Builder Sends Network Call Which In Return Gives A 
          Asyncsnapshot Which Is Then Used To Display Information
          */
          child: FutureBuilder(
              future: getAnnoucements(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // checks for snapshot errors and throws if any found
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
                        padding: EdgeInsets.only(left: 6, right: 6, top: 10),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          /*
                         Priortize Chip Color According To There Announcement Priority
                         Red For Very Important & Amber For Medium And High
                         */
                          if (snapshot.data[index].priority ==
                              "Very Important") {
                            _chipColor = Colors.red[500];
                            _textColor = Colors.white;
                          } else {
                            _chipColor = Colors.amberAccent;
                            _textColor = Colors.black;
                          }
                          return Container(
                              child: Card(
                            margin: EdgeInsets.all(10),
                            /*
                            Material Grooving Expansion Tile That Shows The Annoucement Title
                            As Well As Whole Annoucement Data On Tile Expansion
                            */
                            child: GroovinExpansionTile(
                              backgroundColor: _chipColor,
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Chip(
                                        backgroundColor: _chipColor,
                                        label: Text(
                                          snapshot.data[index].priority,
                                          style: TextStyle(color: _textColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(snapshot.data[index].date),
                                    ],
                                  )
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data[index].title),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(snapshot.data[index].data),
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
