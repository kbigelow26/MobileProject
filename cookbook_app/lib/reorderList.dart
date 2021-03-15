import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import './RecipeStorage.dart' as RSClass;

class reorderList extends StatefulWidget {
  reorderList({Key key, this.folders, this.allFiles, this.storage}) : super(key: key);

  final RSClass.RecipeStorage storage;
  List folders;
  List allFiles;

  @override
  _reorderListState createState() => _reorderListState();
}

class _reorderListState extends State<reorderList> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  Widget optionsMenu(String name) {
    return PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            _openEditFolder(context, name);
          } else if (value == 2) {
            _openDeleteFolder(context, name);
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text("Rename")),
              PopupMenuItem(value: 1, child: Text("Delete")),
            ]);
  }

  _openEditFolder(context, String name) {
    Alert(
        context: context,
        title: "Edit Folder '" + name + "'",
        content: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  } else {
                    return null;
                  }
                },
              ),
            )
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                var contents = RSClass.RecipeStorage.renameFolder("folder-"+name, nameController.text);
                Navigator.pop(context);
              }
            },
            child: Text(
              "Update",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _openDeleteFolder(context, String name) {
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
              var check =
                  await RSClass.RecipeStorage.deleteFile("folder-" + name);
              setState(() {

              });
              Navigator.pop(context);
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  List<ListTile> getListItems() => widget.folders
      .asMap()
      .map((i, item) => MapEntry(i, buildListTile(item, i)))
      .values
      .toList();

  ListTile buildListTile(String item, int index) {
    return ListTile(
        key: ValueKey(item),
        title: Text(item),
        leading: Icon(Icons.folder_outlined),
        trailing: PopupMenuButton(onSelected: (value) {
          if (value == 1) {
            _openEditFolder(context, item);
          } else if (value == 2) {
            _openDeleteFolder(context, item);
          }
        }, itemBuilder: (context) {
          return [
            PopupMenuItem(value: 1, child: Text("Rename")),
            PopupMenuItem(value: 2, child: Text("Delete")),
          ];
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        if (newIndex > oldIndex) {
          newIndex = newIndex - 1;
        }
        // setState(() {
        //   String choice = currentItems[oldIndex];
        //   currentItems.removeAt(oldIndex);
        //   currentItems.insert(newIndex, choice);
        // });
      },
      children: getListItems(),
    ));
  }

// void onReorder(int oldIndex, int newIndex){
//   if(newIndex > oldIndex){
//     newIndex = newIndex - 1;
//   }
//   setState(() {
//     String choice = currentItems[oldIndex];
//     currentItems.removeAt(oldIndex);
//     currentItems.insert(newIndex, choice);
//   });
// }
}
