import 'package:flutter/material.dart';
import './main.dart' as homeScreen;
import './RecipeStorage.dart' as RSClass;
import './ApiHelper.dart' as spoonApi;

class FinishEditRecipeRoute extends StatefulWidget {
  final String filePath, image;
  final bool calorie, public;

  FinishEditRecipeRoute({Key key, this.title, this.ingredients, this.instructions,
    this.filePath, this.calorie, this.public, this.image})
      : super(key: key);

  final String title, ingredients, instructions;

  @override
  _FinishEditRecipeState createState() => _FinishEditRecipeState();
}

class _FinishEditRecipeState extends State<FinishEditRecipeRoute> {
  bool checkboxCalories = false;
  bool checkboxPublic = false;
  String dropdownTags = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit a Recipe"),
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
              icon: Icon(Icons.check), label: "Finish"),
        ],
        onTap: (int index) async {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {

            //Delete the old recipe
            var check =
            await RSClass.RecipeStorage.deleteFile(widget.filePath);
            setState(() {
            });

            RSClass.RecipeStorage.generateRecipe(
                widget.title,
                widget.ingredients,
                widget.instructions,
                checkboxCalories,
                "stuff and things",
                checkboxPublic,
                widget.image.toString(),
                "null");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      homeScreen.MyHomePage(title: 'Yum Binder',
                          storage: RSClass.RecipeStorage(),
                      deleteFilePath: widget.filePath)),
            );
          }
        },
      ),
    );
  }
}
