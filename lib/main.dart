import 'dart:convert';
import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService api = ApiService(); //object of ApiService class
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  // _fetchPosts() async {
  //   var result = await api.getPosts();
  //   setState(() {
  //     _posts = result;
  //   });
  // }

  _fetchPosts() async {
  var response = await api.getPosts();
  if (response.statusCode == 200) {
    setState(() {
      _posts = json.decode(response.body);
    });
  } else {
    // Handle error case
    print("Error fetching posts: ${response.statusCode}");
    // You can also show a snackbar or alert dialog to inform the user
  }
}

  _addPost(Map post) async {
    var result = await api.addPost(post);
    if (result.statusCode == 201) {
      _fetchPosts(); // Fetch updated posts if update was successful
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Post added')));
      
    } else {
      print('Failed to add post: ${result.statusCode}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add post')));
    }
  }

  _updatePost(int id, Map post) async {
    var result =
        await api.updatePost(id, post); // Send update request to test API
    if (result.statusCode == 200) {
      _fetchPosts(); // Fetch updated posts if update was successful
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Post updated')));
    } else {
      print('Failed to update post: ${result.statusCode}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update post')));
    }
  }

  _deletePost(int id) async {
    var result = await api.deletePost(id); // Send delete request to test API
    if (result.statusCode == 200) {
      _fetchPosts(); // Fetch updated posts if delete was successful
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Post deleted')));
    } else {
      print('Failed to delete post: ${result.statusCode}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete post')));
    }
  }

  _showPostForm({Map? post}) //to define an optional named parameter 
    { 
    final  titleController =
        TextEditingController(text: post?['title'] ?? ''); //The ? operator is the null-aware operator. It checks if post is null.
// If post is not null, it accesses ['title'].
// If post is null, the whole expression post?['title'] evaluates to null. without accesing its property preventing runtime error.
    final  bodyController =
        TextEditingController(text: post?['body'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(post == null ? 'Add Post' : 'Edit Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: 'Body'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (post == null) {
                  _addPost({
                    'title': titleController.text,
                    'body': bodyController.text,
                  });
                } else {
                  _updatePost(post['id'], {
                    'title': titleController.text,
                    'body': bodyController.text,
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text(post == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter CRUD App'),
      ),
      body: _posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return ListTile(
                  title: Text(post['title']),
                  subtitle: Text(post['body']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showPostForm(post: post),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletePost(post['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showPostForm(),
      ),
    );
  }
}





// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// // Define the Album model
// class Album {
//   final int? id;
//   final String? title;

//   const Album({this.id, this.title});

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       id: json['id'],
//       title: json['title'],
//     );
//   }
// }

// // Fetch an album from the API
// Future<Album> fetchAlbum() async {
//   final response = await http.get(
//     Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
//   );

//   if (response.statusCode == 200) {
//     return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
//   } else {
//     throw Exception('Failed to load album');
//   }
// }

// // Create a new album
// Future<Album> createAlbum(String title) async {
//   final response = await http.post(
//     Uri.parse('https://jsonplaceholder.typicode.com/albums'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'title': title,
//     }),
//   );

//   if (response.statusCode == 201) {
//     return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
//   } else {
//     throw Exception('Failed to create album.');
//   }
// }

// // Update an existing album
// Future<Album> updateAlbum(String title) async {
//   final response = await http.put(
//     Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'title': title,
//     }),
//   );

//   if (response.statusCode == 200) {
//     return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
//   } else {
//     throw Exception('Failed to update album.');
//   }
// }

// // Delete an album
// Future<Album> deleteAlbum(String id) async {
//   final response = await http.delete(
//     Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );

//   if (response.statusCode == 200) {
//     return Album(id: null, title: null); // Return an empty album object
//   } else {
//     throw Exception('Failed to delete album.');
//   }
// }

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() {
//     return _MyAppState();
//   }
// }

// class _MyAppState extends State<MyApp> {
//   final TextEditingController _controller = TextEditingController();
//   Future<Album>? _futureAlbum;

//   @override
//   void initState() {
//     super.initState();
//     _futureAlbum = fetchAlbum();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter API Operations',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter API Operations'),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(8),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 FutureBuilder<Album>(
//                   future: _futureAlbum,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.done) {
//                       if (snapshot.hasData) {
//                         return Column(
//                           children: [
//                             Text('Fetched Album: ${snapshot.data?.title ?? 'Deleted'}'),
//                             TextField(
//                               controller: _controller,
//                               decoration: const InputDecoration(hintText: 'Enter Title'),
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _futureAlbum = updateAlbum(_controller.text);
//                                 });
//                               },
//                               child: const Text('Update Data'),
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _futureAlbum = deleteAlbum(snapshot.data?.id.toString() ?? '1');
//                                 });
//                               },
//                               child: const Text('Delete Data'),
//                             ),
//                           ],
//                         );
//                       } else if (snapshot.hasError) {
//                         return Text('${snapshot.error}');
//                       }
//                     }
//                     return const CircularProgressIndicator();
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     TextField(
//                       controller: _controller,
//                       decoration: const InputDecoration(hintText: 'Enter Title'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _futureAlbum = createAlbum(_controller.text);
//                         });
//                       },
//                       child: const Text('Create Data'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _futureAlbum = fetchAlbum();
//                     });
//                   },
//                   child: const Text('Fetch Data'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
