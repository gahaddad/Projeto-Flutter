import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firebase_services.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todos = List.empty();
  String title = "";
  String preco = "";
  String id = "";
  @override
  void initState() {
    super.initState();
    todos = ["Hello", "Hey There"];
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  createCafe() {
    id = generateRandomString(10);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("cafe").doc(id);

    Map<String, String> todoList = {
      "title": title,
      "preco": preco,
      "id": id,
    };

    documentReference
        .set(todoList)
        // ignore: avoid_print
        .whenComplete(() => print("Data stored successfully"));
  }

  deleteCafe(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("cafe").doc(item);

    documentReference
        .delete()
        // ignore: avoid_print
        .whenComplete(() => print("deleted successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('Café Store'),
        actions: [
          IconButton(
            onPressed: () {
              FireBaseServices().signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginScreen();
              }));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("cafe").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
          } else if (snapshot.hasData || snapshot.data != null) {
            return snapshot.data?.docs.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      QueryDocumentSnapshot<Object?>? documentSnapshot =
                          snapshot.data?.docs[index];
                      return Dismissible(
                          key: Key(index.toString()),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text((documentSnapshot != null)
                                  ? (documentSnapshot["title"])
                                  : ""),
                              subtitle: Text((documentSnapshot != null)
                                  ? (documentSnapshot["preco"])
                                  : ""),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    // todos.removeAt(index);
                                    deleteCafe((documentSnapshot != null)
                                        ? (documentSnapshot["id"])
                                        : "");
                                  });
                                },
                              ),
                            ),
                          ));
                    })
                : Center(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.warning), Text("Não temos nada!")],
                  ));
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: const Text("Add Todo"),
                content: Container(
                  width: 400,
                  height: 100,
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (String value) {
                          title = value;
                        },
                      ),
                      TextField(
                        onChanged: (String value) {
                          preco = value;
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        setState(() {
                          createCafe();
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text("Add"))
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
