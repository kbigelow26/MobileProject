import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Yum Binder'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class CreateRecipeRoute extends StatefulWidget {
  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class FinishRecipeRoute extends StatefulWidget {
  @override
  _FinishRecipeState createState() => _FinishRecipeState();
}

class _FinishRecipeState extends State<FinishRecipeRoute> {
  bool checkboxCalories = false;
  bool checkboxPublic = false;
  String dropdownTags = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Recipe"),
      ),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(width: 0.0, height: 0.0),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Add Tags",
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: DropdownButton<String>(
                            value: dropdownTags,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 50,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownTags = newValue;
                              });
                            },
                            items: <String>['None', 'Breakfast', 'Dinner']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ))
                    ]),
                    Padding(padding: EdgeInsets.only(bottom: 30)),
                    Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(width: 0.0, height: 0.0),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Add Calories",
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Transform.scale(
                              scale: 1.4,
                              child: Checkbox(
                                value: checkboxCalories,
                                onChanged: (value) {
                                  setState(() {
                                    checkboxCalories = !checkboxCalories;
                                  });
                                },
                              )))
                    ]),
                    Padding(padding: EdgeInsets.only(bottom: 30)),
                    Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(width: 0.0, height: 0.0),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Make Public",
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Transform.scale(
                              scale: 1.4,
                              child: Checkbox(
                                value: checkboxPublic,
                                onChanged: (value) {
                                  setState(() {
                                    checkboxPublic = !checkboxPublic;
                                  });
                                },
                              )))
                    ]),
                  ]))),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward), label: "Finish"),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(title: 'Flutter Demo Home Page')),
            );
          }
        },
      ),
    );
  }
}

class _CreateRecipeState extends State<CreateRecipeRoute> {
  File _image;

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    File image = (await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50)) as File;

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = (await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50)) as File;

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Recipe"),
      ),
      body: Center(
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
                        maxLines: null,
                        decoration:
                            InputDecoration(hintText: "Enter Recipe Name"),
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(width: 0.0, height: 0.0),
                  ),
                  Expanded(
                      flex: 4,
                      child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: CircleAvatar(
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      _image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          )))
                ]),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    )),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(), hintText: "..."),
                    ),
                  )
                ]),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Instructions",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    )),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(children: <Widget>[
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(), hintText: "..."),
                  )),
                ])
              ]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward), label: "Next"),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(title: 'Flutter Demo Home Page')),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FinishRecipeRoute()),
            );
          }
        },
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  void printTest(){
    log(' Go to create recipe?');
  }

  Widget getListView() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.folder),
          title: Text('Dessert'),
        ),
        ListTile(
          leading: Icon(Icons.folder),
          title: Text('Breakfast'),
        ),
        ListTile(
          leading: Icon(Icons.circle),
          title: Text('Steak'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: getListView(),
      ),
      drawer: Drawer(  // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DrawerHeader(
              child: Text('Yum Binder'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Public Recipes'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Share a Recipe'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Update Folders'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateRecipeRoute()),
                  );
                },
                child: Text('open page 2'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: printTest,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );




  }
}
