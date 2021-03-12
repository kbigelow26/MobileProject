import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './main.dart' as homeScreen;
//import './finishRecipeScreen.dart' as finishRecipeScreen;
import './advancedSearchRecipeScreen.dart' as advancedSearchRecipeScreen;

class SearchRecipeRoute extends StatefulWidget {
  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipeRoute> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                        flex: 5,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: null,
                          decoration:
                          InputDecoration(hintText: "Search"),
                        )),
                  ]),

                  Align(
                      alignment: Alignment.topLeft,

                      child:TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => advancedSearchRecipeScreen.SearchRecipeRoute()),
                          );
                        },
                        child: Text('Advanced Search'),
                      )),

                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  Row(children: <Widget>[
                    Expanded(
                        child: TextField(
                          enabled: false,
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(), hintText: "..."),
                        )),
                  ])
                ]),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward), label: "Search"),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      homeScreen.MyHomePage(title: 'Yum Binder')),
            );
          }
          // Put code for search result change here.
          /*
          else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => finishRecipeScreen.FinishRecipeRoute()),
            );
          }
          */
        },
      ),
    );
  }
}
