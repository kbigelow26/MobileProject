import 'package:flutter/material.dart';
import './main.dart' as homeScreen;
import './RecipeStorage.dart' as RSClass;
import './viewExistingRecipe.dart' as viewExistingRecipeScreen;

class ViewFolderRoute extends StatefulWidget {
  ViewFolderRoute({Key key, this.folder, this.allFiles, this.allFolders}) : super(key: key);

  final String folder;
  final List allFiles;
  final List allFolders;

  @override
  _ViewFolderState createState() => _ViewFolderState();
}

class _ViewFolderState extends State<ViewFolderRoute> {
  List recipes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder),
      ),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 500,
                    child: ListView(
                      children: getListItems(),
                    ),
                  )
                ],
              ))),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: "Finish"),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  List<ListTile> getListItems() {
    recipes =
        RSClass.RecipeStorage.getFilesInFolder(widget.allFiles, widget.folder);
    if (recipes.isNotEmpty) {
      return recipes
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

  ListTile buildListTile(String item, int index) {
    return ListTile(
      key: ValueKey(item),
      title: Text(item.split("-")[1]),
      leading: Icon(Icons.text_snippet),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => viewExistingRecipeScreen.ViewExistingRecipe(
                name: item, storage: RSClass.RecipeStorage(), allFolders: widget.allFolders,)),
        );
      },
    );
  }
}
