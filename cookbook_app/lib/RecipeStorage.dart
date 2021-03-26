import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RecipeStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<File> writeRecipe(Map recipeInfo) async {
    final file = await _localFile(recipeInfo['path']+'-'+recipeInfo['name']);
    return file.writeAsString('$recipeInfo');
  }

  static Future<File> writeFolder(Map info) async {
    final file = await _localFile('folder'+'-'+info['name']);
    return file.writeAsString('$info');
  }

  static Future<int> deleteFile(String fileName) async{
    try {
      var temp = fileName.toString();
      var temp2 = temp.split("/");
      var curr = temp2[temp2.length-1];
      final file = await _localFile('$curr');
      var tempy = await file.delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> renameFolder(String fileName, String newFileName) async{
    try {
      var delete = await deleteFile(fileName);
      var make = generateFolder(newFileName);
      //TODO : rename all files in folder
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<String> readRecipe(String filename) async {
    try {
      var temp = filename.toString();
      var temp2 = temp.split("/");
      var curr = temp2[temp2.length-1];
      final file = await _localFile('$curr');
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<List> getAllFiles() async {
    try {
      final path = await _localPath;
      List files = Directory('$path/').listSync();
      return files;
    } catch (e) {
      return null;
    }
  }

  static List getFolders(List allFiles) {
    try {
      List files = [];
      for(var i = 0; i < allFiles.length; i++) {
        var temp = allFiles[i].toString();
        var temp2 = temp.split("/");
        var curr = temp2[temp2.length-1];
        if(curr.startsWith('folder-')){
          files.add(curr.split("-")[1].replaceAll("'", ""));
        }
      }
      return files;
    } catch (e) {
      return null;
    }
  }

  static List getTopLevelRecipes(List allFiles) {
    try {
      List files = [];
      for(var i = 0; i < allFiles.length; i++) {
        var temp = allFiles[i].toString();
        var temp2 = temp.split("/");
        var curr = temp2[temp2.length-1];
        if(curr.startsWith('null-')){
          files.add(temp.replaceAll("'", "").replaceAll("File: ", ""));
        }
      }
      return files;
    } catch (e) {
      return null;
    }
  }

  static List getFilesInFolder(List allFiles, String folder) {
    try {
      List files = [];
      for(var i = 0; i < allFiles.length; i++) {
        var temp = allFiles[i].toString();
        var temp2 = temp.split("/");
        var curr = temp2[temp2.length-1];
        if(curr.startsWith('$folder'+'-')){
          files.add(curr);
        }
      }
      return files;
    } catch (e) {
      return null;
    }
  }

   static Map generateRecipe(
      String name,
      String ingredients,
      String instructions,
      bool calories,
      String tags,
      bool public,
      String image,
      String path) {
    try {
      var info = {
        "type": "file",
        "name": '$name',
        "ingredients": '$ingredients',
        "instructions": '$instructions',
        "calories": '$calories',
        "tags": '$tags',
        "public": '$public',
        "image": '$image',
        "path": '$path'
      };
      writeRecipe(info);
      return info;
    } catch (e) {
      return null;
    }
  }

   static Map generateFolder(String name) {
    var info = {"type": "folder",
                "name": '$name',
                "order": 1};
    writeFolder(info);
    return info;
  }

  static int deleteFolder(String name) {
    var j = deleteFile(name);
    print(j);
    return 1;
  }

}
