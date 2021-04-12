import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './main.dart' as homeScreen;

import './advancedSearchRecipeScreen.dart' as advancedSearchRecipeScreen;
import './RecipeStorage.dart' as RSClass;
import './viewExistingRecipe.dart' as viewExistingRecipeScreen;

class SearchRecipeRoute extends StatefulWidget {
  SearchRecipeRoute({Key key, this.allFolders, this.recipes, this.curr}) : super(key: key);

  final List allFolders;
  List recipes;
  String curr;
  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipeRoute> {
  final _formKey = GlobalKey<FormState>();
  var keyWordController;

  @override
  void initState() {
    keyWordController = TextEditingController(text:widget.curr);
  }

  @override
  void dispose() {
    keyWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
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
                            controller: keyWordController,
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: null,
                            decoration: InputDecoration(hintText: "Search"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter search criteria';
                              } else {
                                return null;
                              }
                            },
                          )),
                    ]),
                    Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      advancedSearchRecipeScreen
                                          .SearchRecipeRoute()),
                            );
                          },
                          child: Text('Advanced Search'),
                        )),
                    Padding(padding: EdgeInsets.only(bottom: 10)),
                    Padding(padding: EdgeInsets.only(bottom: 10)),
                    Container(
                      height: 250,
                      child: ListView(
                        children: getListItems(),
                      )
                    )
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => homeScreen.MyHomePage(
                      title: 'Yum Binder', storage: RSClass.RecipeStorage())),
            );
          }
          else if (index == 1) {
            if (_formKey.currentState.validate()) {
              var newRecipes = await RSClass.RecipeStorage.searchByName(
                  keyWordController.text);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchRecipeRoute(allFolders: widget.allFolders, recipes: newRecipes, curr: keyWordController.text,)),
              );
            }
          }
        },
      ),
    );
  }

  List<ListTile> getListItems() {
    if (widget.recipes.isNotEmpty) {
      return widget.recipes
          .asMap()
          .map((i, item) => MapEntry(i, buildListTile(item, i)))
          .values
          .toList();
    }
    else {
      return [ListTile(
        key: ValueKey('noRecipes'),
        title: Text("No Recipes to Display"),
      )];
    }
  }

  ListTile buildListTile(DocumentSnapshot item, int index) {
    return ListTile(
      key: ValueKey(item['name']),
      title: Text(item['name']),
      leading: Icon(Icons.text_snippet),
      onTap: () {
        bool cal = false;
        bool pub = false;
        if(item['calories'] == "true"){
          cal = true;
        }
        if(item['public'] == "true"){
          pub = true;
        }
        RSClass.RecipeStorage.generateRecipe(
            item['name'],
            item['ingredients'],
            item['instructions'],
            cal,
            item['tags'],
            pub,
            item['image'],
            item['path']);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => viewExistingRecipeScreen.ViewExistingRecipe(
                name: item['path']+"-"+item['name'], storage: RSClass.RecipeStorage(), allFolders: widget.allFolders,)),
        );
      },
    );
  }
}
