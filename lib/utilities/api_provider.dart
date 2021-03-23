import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/PoDO/ImageModel.dart';
import 'package:wallpaper_app/strings/strings.dart';

class ApiProvider {
  Future<ImageModel> getImages(int count, int page) async {
    final response = await http.get(
        '${apiUrl}editors_choice=true&per_page=$count&orientation=vertical&page=$page');
    if (response.statusCode == 200) {
      return ImageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get images');
    }
  }

  Future<ImageModel> getSearchedImages(String query, int page) async {
    final response = await http.get('${apiUrl}q=$query&page=$page');
    if (response.statusCode == 200) {
      return ImageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get images');
    }
  }
}
