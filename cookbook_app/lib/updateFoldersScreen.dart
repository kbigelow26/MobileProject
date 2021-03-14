import 'package:cookbook_app/reorderList.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import './main.dart' as homeScreen;
import './RecipeStorage.dart' as RSClass;

class UpdateFoldersRoute extends StatefulWidget {
  @override
  _UpdateFoldersState createState() => _UpdateFoldersState();
}

class _UpdateFoldersState extends State<UpdateFoldersRoute> {

  _openAddFolder(context) {
    Alert(
        context: context,
        title: "Add Folder",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Create",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Folders'),
      ),
      body: reorderList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddFolder(context);
        },
        tooltip: 'Add Folder',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check), label: "Done"),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      homeScreen.MyHomePage(title: 'Yum Binder', storage: RSClass.RecipeStorage())),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  homeScreen.MyHomePage(title: 'Yum Binder', storage: RSClass.RecipeStorage())),
            );
          }
        },
      ),
    );
  }
}