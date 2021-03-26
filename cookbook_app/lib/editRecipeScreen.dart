import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './main.dart' as homeScreen;
import './finishEditRecipeScreen.dart' as finishEditRecipeScreen;
import './RecipeStorage.dart' as RSClass;

class EditRecipeRoute extends StatefulWidget {

  final String name;
  final String ingredients;
  final String instructions;
  final String filePath;
  final RSClass.RecipeStorage storage;
  final bool calorie;
  final bool public;

  EditRecipeRoute({Key key, this.name, this.ingredients, this.instructions, this.filePath,
    this.calorie, this.public,  @required this.storage}) : super(key: key);

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipeRoute> {
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
    titleController.text = widget.name;
    ingredController.text = widget.ingredients;
    instructController.text = widget.instructions;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit a Recipe"),
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
                            controller: titleController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration:
                                InputDecoration(hintText: "Enter Recipe Name"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a title';
                              } else {
                                return null;
                              }
                            },
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
                          controller: ingredController,
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
                            controller: instructController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        decoration: InputDecoration(
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
              icon: Icon(Icons.arrow_forward), label: "Next"),
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
            if (_formKey.currentState.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => finishEditRecipeScreen.FinishEditRecipeRoute(
                        title: titleController.text,
                        ingredients: ingredController.text,
                        instructions: instructController.text,
                        filePath: widget.filePath,
                        calorie: widget.calorie,
                        public: widget.public)),
              );
            }
          }
        },
      ),
    );
  }
}
