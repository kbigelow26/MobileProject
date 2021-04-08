import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import './main.dart' as homeScreen;
import './finishRecipeScreen.dart' as finishRecipeScreen;
import './RecipeStorage.dart' as RSClass;
import './editRecipeScreen.dart' as editRecipeScreen;
import './ApiHelper.dart' as spoonApi;

class ViewExistingRecipe extends StatefulWidget {
  @override
  final String name;
  final RSClass.RecipeStorage storage;
  List allFolders;
  File image;

  ViewExistingRecipe(
      {Key key, this.name, @required this.storage, this.allFolders, this.image})
      : super(key: key);

  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<ViewExistingRecipe> {
  File _image;
  String _apiCalorie = "N/A";
  String _apiFact = "";
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String _folderPick = 'No folder';
  String _folderResult = 'No folder';
  final titleController = TextEditingController();
  final ingredController = TextEditingController();
  final instructController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    ingredController.dispose();
    instructController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List folders) {
    List<DropdownMenuItem<String>> items = List();
    int i = 0;
    for (String folder in folders) {
      items.add(DropdownMenuItem(child: Text(folder), value: folder));
    }
    return items;
  }

  _openMoveRecipe(
      context,
      List folders,
      String rName,
      String folder,
      String ingredients,
      String instructions,
      bool cal,
      String tags,
      bool public,
      String image) {
    Alert(
        context: context,
        title: "Move Recipe '" + rName + "'",
        content: Column(
          children: <Widget>[
            Form(
                key: _formKey2,
                child: DropdownButtonFormField(
                  hint: Text('Choose a folder'),
                  value: _folderPick,
                  onSaved: (value) {
                    setState(() {
                      _folderPick = value;

                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _folderPick = value;
                    });
                  },
                  items: buildDropDownMenuItems(folders),
                ))
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              if (_formKey2.currentState.validate()) {
                if (_folderPick != folder) {

                  var check = await RSClass.RecipeStorage.deleteFile(
                      folder + "-" + rName);
                  if(_folderPick == "No folder") {
                    var newRecipe = RSClass.RecipeStorage.generateRecipe(
                        rName,
                        ingredients,
                        instructions,
                        cal,
                        tags,
                        public,
                        image,
                        "null");
                  } else {
                    var newRecipe = RSClass.RecipeStorage.generateRecipe(
                        rName,
                        ingredients,
                        instructions,
                        cal,
                        tags,
                        public,
                        image,
                        _folderPick);
                  }

                }
                setState(() {
                  _folderResult = _folderPick;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => homeScreen.MyHomePage(
                          title: 'Yum Binder', storage: RSClass.RecipeStorage())),
                );
              }
            },
            child: Text(
              "Update",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _openDeleteRecipe(context, String recipeName, String folder) {
    Alert(
        context: context,
        title: "Are you sure you want to delete?",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            onPressed: () async {
              var check = await RSClass.RecipeStorage.deleteFile(
                  folder + "-" + recipeName);
              setState(() {});
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => homeScreen.MyHomePage(
                        title: 'Yum Binder', storage: RSClass.RecipeStorage())),
              );
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _setImgState(String imgStr) async {
      _image =  File(imgStr);
  }

 _getApiInfo(String title) async {
    log(title);
    Future<String> resp = spoonApi.searchApiForInfo(title);
    String returnStr = await resp;
    var temp = returnStr.split('parseMe');
    log("EAT THIS: "+returnStr);
    setState(()  {
      _apiCalorie = temp[0];
      _apiFact = temp[1];
    });

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.storage.readRecipe(widget.name),
        builder: (context, AsyncSnapshot<String> value) {
          if (value.hasData) {
            print("View Recipe contents: "+value.data);
            var tempStr = value.data.split(', ingredients:');
            var recipeName = tempStr[0].replaceAll('{type: file, name: ', '');
            var helperToken = tempStr[1];
            var ingredients = helperToken.substring(
                0, helperToken.indexOf(', instructions: '));
            var instructions =
                helperToken.substring(0, helperToken.indexOf(', calories: '));
            var tokenHelper = instructions.split(' instructions: ');
            bool calorie, public;
            if (value.data.contains(', calories: true, tags:', 0)) {
              calorie = true;
            } else {
              calorie = false;
            }
            if (value.data.contains(', public: true, image:', 0)) {
              public = true;
            } else {
              public = false;
            }
            instructions = tokenHelper[1];
            var tempValue = value.data.split("tags: ")[1];
            var tags = tempValue.substring(0, tempValue.indexOf(", public: "));
            tempValue = value.data.split("image: ")[1];
            var image = tempValue.substring(0, tempValue.indexOf(", path:"));
            //print("The image:" +image.toString());
            if (image.startsWith("File: '")){
              image = image.substring(7, image.length);
            }
            while (image.endsWith("'")) {
              image = image.substring(0, image.length - 1);
            }
            _setImgState(image);
            print("Image: "+image);

            //print('START OF FILES:');
            var dir = new Directory('data/user/0/com.testapp.cookbook_app/app_flutter/');
            List contents = dir.listSync();
            /*
            for (var fileOrDir in contents) {
              if (fileOrDir is File) {
                print(fileOrDir);
              } else if (fileOrDir is Directory) {
                print(fileOrDir.path);
              }
            }
            */
            //print('END OF FILES:');
            print(calorie.toString());


            //_apiCalorie = "N/A";
            //_getApiInfo(recipeName);

            tempValue = value.data.split("path: ")[1];
            var recipeFolder =
                tempValue.substring(0, tempValue.length - 1);
            if (!widget.allFolders.contains("No folder")) {
              widget.allFolders.add("No folder");
            }
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
                                  editRecipeScreen.EditRecipeRoute(
                                      name: recipeName,
                                      ingredients: ingredients,
                                      instructions: instructions,
                                      filePath: widget.name,
                                      calorie: calorie,
                                      public: public,
                                      image: image)),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Delete'),
                      onTap: () {
                        _openDeleteRecipe(context, recipeName, recipeFolder);
                      },
                    ),
                    ListTile(
                      title: Text('Move'),
                      onTap: () {
                        _openMoveRecipe(context, widget.allFolders, recipeName,
                            recipeFolder, ingredients, instructions, calorie, tags, public, image);
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
                                    controller:
                                        TextEditingController(text: recipeName),
                                  )),
                              Expanded(
                                flex: 1,
                                child: Container(width: 0.0, height: 0.0),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: GestureDetector(
                                      onTap: () {
                                      },
                                      child: ClipRRect(
                                        child: _image != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
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
                                  controller:
                                      TextEditingController(text: ingredients),
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
                                controller:
                                    TextEditingController(text: instructions),
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
                            ]),

                            if (calorie == true)
                            Row(children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      _getApiInfo(recipeName);
                                    },
                                    child: Text('See Nutrtional Info:\n'),
                                  ),
                              ),
                            ]),
                            Row(children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Estimated Total:"+_apiCalorie,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  )),
                            ]),
                            Row(children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  enabled: false,
                                  controller:
                                  TextEditingController(text: "Nutritional Fact:" + _apiFact),
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
                          ]),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_back), label: "Back"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_forward), label: "Finish"),
                ],
                onTap: (int index) {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => homeScreen.MyHomePage(
                              title: 'Yum Binder',
                              storage: RSClass.RecipeStorage())),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => homeScreen.MyHomePage(
                              title: 'Yum Binder',
                              storage: RSClass.RecipeStorage())),
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
