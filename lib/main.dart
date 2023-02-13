import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  List<UserModel> allUser = [];

  Future getAllUser() async {
    try {
      var myResponse = await http.get(
        Uri.parse("https://reqres.in/api/users?page=1"),
      );
      var data = (json.decode(myResponse.body) as Map<String, dynamic>)["data"];
      for (var element in data) {
        allUser.add(
          UserModel.fromJson(element),
        );
      }
    } catch (e) {
      print("error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Future Builder"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getAllUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading"),
            );
          } else {
            if (allUser.isEmpty) {
              return const Center(
                child: Text("Tidak ada data"),
              );
            } else {
              return ListView.builder(
                itemCount: allUser.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(allUser[index].avatar),
                  ),
                  title: Text(
                      "${allUser[index].firstName} ${allUser[index].lastName}"),
                  subtitle: Text(allUser[index].email),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
