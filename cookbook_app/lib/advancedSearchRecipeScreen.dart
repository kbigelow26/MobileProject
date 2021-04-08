import 'package:flutter/material.dart';
import './searchRecipeScreen.dart' as searchRecipeScreen;
import 'package:textfield_tags/textfield_tags.dart';

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
                            validator: (value){
                              if (value.isEmpty) {
                                return 'Please enter search criteria';
                              } else {
                                return null;
                              }
                            },
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
                        tagsStyler: TagsStyler(
                            tagTextStyle: TextStyle(fontWeight: FontWeight.bold),
                            tagDecoration: BoxDecoration(color: Colors.blue[300], borderRadius: BorderRadius.circular(8.0), ),
                            tagCancelIcon: Icon(Icons.cancel, size: 18.0, color: Colors.blue[900]),
                            tagPadding: const EdgeInsets.all(6.0)
                        ),
                        textFieldStyler: TextFieldStyler(hintText: " ", helperText: " "),
                        onTag: (tag) {},
                        onDelete: (tag) {}
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
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => searchRecipeScreen.SearchRecipeRoute()),
            );
          }
          // Put code for search result change here.

          else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => searchRecipeScreen.SearchRecipeRoute()),
            );
          }

        },
      ),
    );
  }
}
