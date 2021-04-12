import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:math';

/* Additional API Keys to use incase credits run out
final String spoonApi = "e6cfdf5b5e7347faa658da79c7c3b35f";
final String spoonApi = "7a2cfe142ee140c78b253925d3661ba3";
final String spoonApi = "5e69c70973bf431e87a897b255adf805";
*/

final String spoonApi = "73f12deeaff3417a969f0f5b8a321766";

Future<String> searchApiForImg(String recipeName) async {
  final response = await http.read("https://api.spoonacular.com/recipes/complexSearch?query=$recipeName&number=1&apiKey=$spoonApi");
  return response;
}

Future<String> searchApiForInfo(String recipeName) async {
  final response = await http.read("https://api.spoonacular.com/recipes/complexSearch?query=$recipeName&number=1&apiKey=$spoonApi&maxCalories=99999&maxFat=9999&maxCarbs=9999&maxFat=9999");
  Map<String, dynamic> obj = jsonDecode(response);
  String tempStr = "N/A";
  Random random = new Random();
  int randomNumber = random.nextInt(2) + 1;
  String macro;
  try {
    tempStr = obj['results'][0]['nutrition']['nutrients'][0]['amount'].toString() + " " + obj['results'][0]['nutrition']['nutrients'][0]['unit'].toString();
    macro = obj['results'][0]['nutrition']['nutrients'][randomNumber]['amount'].toString() + obj['results'][0]['nutrition']['nutrients'][randomNumber]['unit'].toString()
    + " of " + obj['results'][0]['nutrition']['nutrients'][randomNumber]['title'].toString();
    tempStr = tempStr + "parseMe" + " This food item has an estimated amount of "+macro;
  } catch (e) {
    tempStr = "N/A";
  }

  return tempStr;
}

Future<File> validateImgResponse(String resp, String fileName) async {
  Map<String, dynamic> obj = jsonDecode(resp);
  int results = obj['totalResults'];
  if (results == 0) {
    return null;
  }
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
