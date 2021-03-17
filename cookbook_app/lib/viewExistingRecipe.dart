import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './main.dart' as homeScreen;
import './finishRecipeScreen.dart' as finishRecipeScreen;
import './RecipeStorage.dart' as RSClass;
import './editRecipeScreen.dart' as editRecipeScreen;

class ViewExistingRecipe extends StatefulWidget {
  @override

  final String name;
  final RSClass.RecipeStorage storage;

  ViewExistingRecipe({Key key, this.name, @required this.storage}) : super(key: key);

  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<ViewExistingRecipe> {
  File _image;
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final ingredController = TextEditingController();
  final instructController = TextEditingController();



  @override
  void dispose() {
    titleController.dispose();
    ingredController.dispose();
    instructController.dispose();
    super.dispose();
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  // Show some popup of the picture?
                 // /*
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
                      //log('print it: '+ widget.name);
                    },
                  ),
              //  */
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    File image = (await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = (await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50));

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: widget.storage.readRecipe(widget.name),
        builder: (context, AsyncSnapshot<String> value) {
          if (value.hasData) {
            print(value);
            var tempStr = value.data.split(', ingredients:');
            var recipeName = tempStr[0].replaceAll('{type: file, name: ', '');
            var helperToken = tempStr[1];
            var ingredients = helperToken.substring(0, helperToken.indexOf(', instructions: '));
            var instructions = helperToken.substring(0, helperToken.indexOf(', calories: '));
            var tokenHelper = instructions.split(' instructions: ');
            bool calorie, public;
            if (value.data.contains(', calories: true tags: ', 0)){
              calorie = true;
            } else {
              calorie = false;
            }
            if (value.data.contains(', public: true image:', 0)){
              public = true;
            } else {
              public = false;
            }
            log("PRINT THESE: "+instructions);
            instructions = tokenHelper[1];
            return Scaffold(
              appBar: AppBar(
                title: Text(recipeName),
              ),

              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  //child: Column(
                  children: <Widget>[
                    DrawerHeader(
                      child: Text('Yum Binder'),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                    ListTile(
                      title: Text('Edit'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  editRecipeScreen.EditRecipeRoute(name: recipeName,
                                  ingredients: ingredients, instructions: instructions, filePath: widget.name,
                                  calorie: calorie, public: public)),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Delete'),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                    ListTile(
                      title: Text('Move'),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                    ListTile(
                      title: Text('Share'),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                  ],
                ),
              ),

              body: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    enabled: false,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration:
                                    InputDecoration(hintText: '...'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter a title';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: TextEditingController(text: recipeName),
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
                                      child: ClipRRect(
                                        child: _image != null
                                            ? ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.file(
                                            _image,
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          width: 200,
                                          height: 200,
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
                                child: TextFormField(
                                  enabled: false,
                                  controller: TextEditingController(text: ingredients),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 8,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: "..."),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Ingredients';
                                    } else {
                                      return null;
                                    }
                                  },
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
                                  child: TextFormField(
                                    controller: TextEditingController(text: instructions),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                        enabled: false,
                                        border: const OutlineInputBorder(),
                                        hintText: "..."),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter Instructions';
                                      } else {
                                        return null;
                                      }
                                    },
                                  )),
                            ])
                          ]),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_forward), label: "Finish"),
                ],
                onTap: (int index) {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => homeScreen.MyHomePage(
                              title: 'Yum Binder', storage: RSClass.RecipeStorage())),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => homeScreen.MyHomePage(
                              title: 'Yum Binder', storage: RSClass.RecipeStorage())),
                    );
                  }
                },
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });

  }
}
