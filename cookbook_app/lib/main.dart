import 'package:flutter/material.dart';
import './createRecipeScreen.dart' as createRecipeScreen;
import './updateFoldersScreen.dart' as updateFoldersScreen;
import './RecipeStorage.dart' as RSClass;
import './searchRecipeScreen.dart' as searchRecipeScreen;
import './viewFolderScreen.dart' as viewFolderScreen;

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
      home: MyHomePage(title: 'Yum Binder', storage: RSClass.RecipeStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final RSClass.RecipeStorage storage;

  MyHomePage({Key key, this.title, @required this.storage}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List allFiles;
  List allFolders;
  List topFiles;
  String view;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.storage.getAllFiles(),
        builder: (context, AsyncSnapshot<List> values) {
          if (values.hasData) {
            var folders = RSClass.RecipeStorage.getFolders(values.data);
            var topFilesLocal =
                RSClass.RecipeStorage.getTopLevelRecipes(values.data);
            allFiles = values.data;
            allFolders = folders;
            topFiles = topFilesLocal;
            view = 'top';
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Column( mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(height:250,child: ListView(children: getListItemsFolders())),
                    Expanded(child:ListView(children: getListItems())),
                  ]),

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
                      title: Text('Public Recipes'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  searchRecipeScreen.SearchRecipeRoute()),
                        );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  updateFoldersScreen.UpdateFoldersRoute(folders: allFolders, allFiles: allFiles)),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Create a Recipe'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  createRecipeScreen.CreateRecipeRoute()),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Logout'),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            createRecipeScreen.CreateRecipeRoute()),
                  );
                },
                tooltip: 'Go to Create Recipe',
                child: Icon(Icons.add),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  List<ListTile> getListItems() {
    if (view == "top") {
      return (topFiles
          .asMap()
          .map((i, item) => MapEntry(i, buildListTile(item, i)))
          .values
          .toList());
    } else {
      print(allFiles);
      print("ok");
      List curr = RSClass.RecipeStorage.getFilesInFolder(allFiles, view);
      curr
          .asMap()
          .map((i, item) => MapEntry(i, buildListTile(item, i)))
          .values
          .toList();
    }
  }

  List<ListTile> getListItemsFolders() {
    if (view == "top") {
      return (allFolders
          .asMap()
          .map((i, item) => MapEntry(i, buildFolderTile(item, i)))
          .values
          .toList());
    } else {
      return null;
    }
  }

  ListTile buildFolderTile(String item, int index) {
    return ListTile(
      key: ValueKey(item),
      title: Text(item),
      leading: Icon(Icons.folder_outlined),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => viewFolderScreen.ViewFolderRoute(
                  folder: item, allFiles: allFiles)),
        );
      },
    );
  }

  ListTile buildListTile(String item, int index) {
    return ListTile(
      key: ValueKey(item),
      title: Text(item.split("-")[1]),
      leading: Icon(Icons.text_snippet),
    );
  }
}
