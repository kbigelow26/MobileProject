import 'package:flutter/material.dart';
import './searchRecipeScreen.dart' as searchRecipeScreen;
import 'package:textfield_tags/textfield_tags.dart';
import './RecipeStorage.dart' as RSClass;

class SearchRecipeRoute extends StatefulWidget {
  SearchRecipeRoute({Key key, this.allFolders}) : super(key: key);
  final List allFolders;

  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipeRoute> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ingredController = TextEditingController();
  var ingredients = [];

  @override
  void dispose() {
    nameController.dispose();
    ingredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advanced Search"),
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
                            controller: nameController,
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: null,
                            decoration:
                            InputDecoration(hintText: "Name"),
                          )),
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
                    TextFieldTags(
                        initialTags: [],
                        tagsStyler: TagsStyler(
                            tagTextStyle: TextStyle(fontWeight: FontWeight.bold),
                            tagDecoration: BoxDecoration(color: Colors.blue[300], borderRadius: BorderRadius.circular(8.0), ),
                            tagCancelIcon: Icon(Icons.cancel, size: 18.0, color: Colors.blue[900]),
                            tagPadding: const EdgeInsets.all(6.0)
                        ),
                        textFieldStyler: TextFieldStyler(hintText: " ", helperText: " "),
                        onTag: (tag) {
                          ingredients.add(tag);
                        },
                        onDelete: (tag) {
                          ingredients.remove(tag);
                        }
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                  ]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward), label: "Search"),
        ],
        onTap: (int index) async {
          if (index == 0) {
            Navigator.pop(context);
          }
          else if (index == 1) {
            var foundRecipes;
            if(nameController.text != "" && ingredients.isNotEmpty){
              String all = "";
              ingredients.forEach((element) {
                all = all + " " + element;
              });
              foundRecipes = await RSClass.RecipeStorage.searchByNameAndIngred(
                  nameController.text, all.substring(1));
            }else if(nameController.text != ""){
              foundRecipes = await RSClass.RecipeStorage.searchByName(
                  nameController.text);
            } else if(ingredients.isNotEmpty) {
              String all = "";
              ingredients.forEach((element) {
                all = all + " " + element;
              });
              foundRecipes = await RSClass.RecipeStorage.searchByIngredients(
                  all.substring(1));
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => searchRecipeScreen.SearchRecipeRoute(allFolders: widget.allFolders,recipes: foundRecipes, curr: null)),
            );
          }
        },
      ),
    );
  }
}
