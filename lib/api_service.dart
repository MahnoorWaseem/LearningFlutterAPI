import 'package:http/http.dart' as http;
import 'dart:convert';

// Since your test API is not modifying data on a server, you can simulate the behavior of updates and deletes within your Flutter app locally. 

class ApiService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/posts";

  // Future<List> getPosts() async {
  //   var result = await http.get(Uri.parse(apiUrl));
  //   return json.decode(result.body); //When you receive JSON data (as a string) from a server or read it from a file, you convert this JSON string into Dart objects using json.decode. [foo, {bar: 499}]

  // }

  Future<http.Response> getPosts() async {
  var response = await http.get(Uri.parse(apiUrl));
  return response;
}

  Future<http.Response> addPost(Map post) async {
    var result = await http.post(Uri.parse(apiUrl),
        body: json.encode(post), //When you have Dart objects (like lists, maps, or custom classes) that you need to send to a server or store in a file, you convert these objects into a JSON-formatted string using json.encode.
        headers: {"Content-Type": "application/json"});
    return result;
  }

  Future<http.Response> updatePost(int id, Map post) async {
    var result = await http.put(Uri.parse("$apiUrl/$id"),
        body: json.encode(post),
        headers: {"Content-Type": "application/json"});
    return result;
  }

  Future<http.Response> deletePost(int id) async {
    var result = await http.delete(Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"});
    return result;
  }
}



