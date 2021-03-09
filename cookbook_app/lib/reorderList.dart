import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class reorderList extends StatefulWidget {
  @override
  _reorderListState createState() => _reorderListState();
}

class _reorderListState extends State<reorderList> {

  Widget optionsMenu() {
    return PopupMenuButton(
        onSelected: (value){
          if(value == 1){
            _openEditFolder;
          }else if (value == 2){
            _openDeleteFolder;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child:
            Text("Rename")
          ),
          PopupMenuItem(
              value: 1,
              child:
              Text("Delete")
          ),
        ]
    );
  }

  _openEditFolder(context) {
    Alert(
        context: context,
        title: "Edit Folder Name",
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
              "Update",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _openDeleteFolder(context) {
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  List<String> currentItems = [
    "Dessert",
    "Breakfast",
    "Quick"
  ];

  List<ListTile> getListItems() =>
      currentItems
          .asMap()
          .map((i, item) => MapEntry(i, buildListTile(item, i)))
          .values
          .toList();

  ListTile buildListTile(String item, int index) {
    return ListTile(
      key: ValueKey(item),
      title: Text(item),
      leading: Icon(Icons.folder_outlined),
      trailing:
        PopupMenuButton(
          onSelected: (value){
            if(value == 1){
              _openEditFolder(context);
            }else if (value == 2){
              _openDeleteFolder(context);
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                  value: 1,
                  child:
                  Text("Rename")
              ),
              PopupMenuItem(
                  value: 1,
                  child:
                  Text("Delete")
              ),
            ];
          }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ReorderableListView(
          onReorder: (int oldIndex, int newIndex) {
            if(newIndex > oldIndex){
              newIndex = newIndex - 1;
            }
            setState(() {
              String choice = currentItems[oldIndex];
              currentItems.removeAt(oldIndex);
              currentItems.insert(newIndex, choice);
            });
          },
          children: getListItems(),
        )
    );
  }

  void onReorder(int oldIndex, int newIndex){
    if(newIndex > oldIndex){
      newIndex = newIndex - 1;
    }
    setState(() {
      String choice = currentItems[oldIndex];
      currentItems.removeAt(oldIndex);
      currentItems.insert(newIndex, choice);
    });
  }
}