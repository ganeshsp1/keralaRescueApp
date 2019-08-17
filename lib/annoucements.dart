import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
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
        title: Text("Annoucements/അറിയിപ്പുകൾ"),
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
                    /*
                    On ConnectionState loading/waiting shows shimmer animation
                   */
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Shimmer.fromColors(
                              highlightColor: Colors.white,
                              baseColor: Colors.grey[300],
                              child: ShimmerLayout(),
                              period: Duration(milliseconds: 800),
                            ));
                      },
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
                          } else if (snapshot.data[index].priority.contains(
                              new RegExp(r'high', caseSensitive: false))) {
                            _chipColor = Colors.orange;
                            _textColor = Colors.white;
                          } else if (snapshot.data[index].priority.contains(
                              new RegExp(r'medium', caseSensitive: false))) {
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
                                  Chip(
                                    backgroundColor: _chipColor,
                                    label: Text(
                                      snapshot.data[index].priority,
                                      style: TextStyle(color: _textColor),
                                    ),
                                  ),
                                  Text(snapshot.data[index].date)
                                ],
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, top: 8),
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

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 280;
    double containerHeight = 15;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: containerHeight,
                width: 350,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth * 0.75,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
