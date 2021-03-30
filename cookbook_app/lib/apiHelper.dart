import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';

final String spoonApi = "e6cfdf5b5e7347faa658da79c7c3b35f";

Future<String> searchApiForImg(String recipeName) async {
  final response = await http.read("https://api.spoonacular.com/recipes/complexSearch?query=$recipeName&number=1&apiKey=$spoonApi");
  //print(await http.read("https://api.spoonacular.com/recipes/complexSearch?query=$recipeName&number=1&apiKey=$spoonApi"));
  return response;
}

Future<File> validateImgResponse(String resp, String fileName) async {
  Map<String, dynamic> obj = jsonDecode(resp);
  print(obj.toString());
  int results = obj['totalResults'];
  if (results == 0) {
    return null;
  }
  print(results.toString());

  /* Get the Image */
  return await _fileFromImageUrl(  obj['results'][0]['image'].toString(), fileName);
}

Future<File> _fileFromImageUrl(String imgUrl, String imgName) async {
  final response = await http.get(imgUrl);

  final documentDirectory = await getApplicationDocumentsDirectory();

  final file = File(join(documentDirectory.path, imgName+'.png'));

  file.writeAsBytesSync(response.bodyBytes);

  return file;
}
