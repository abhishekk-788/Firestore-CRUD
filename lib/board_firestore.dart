import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'custom_listview.dart';

class BoardApp extends StatefulWidget {
  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var firestoreDb = FirebaseFirestore.instance.collection("board").snapshots();

  TextEditingController nameInputController;
  TextEditingController titleInputController;
  TextEditingController descriptionInputController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameInputController = TextEditingController();
    titleInputController = TextEditingController();
    descriptionInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text("Community Board"),
          elevation: 0,
        ),

        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            showDialogBox(context);
          },
          child: Icon(Icons.add, color: Colors.white),
        ),

      body: StreamBuilder(
        stream: firestoreDb,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, int index) {
              return CustomListView(
                  snapshot: snapshot.data, index: index);
            },
          );
        },
      )
    );
  }

  showDialogBox(BuildContext context) async {
    await showDialog(
        context: context,
        child: AlertDialog(
            contentPadding: EdgeInsets.all(16.0),
            content: Column(
              children: [
                Text("Please Fill out the Form"),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: "Your Name"),
                    controller: nameInputController,
                  ),
                ),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: "Title"),
                    controller: titleInputController,
                  ),
                ),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: "Description"),
                    controller: descriptionInputController,
                  ),
                ),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  nameInputController.clear();
                  titleInputController.clear();
                  descriptionInputController.clear();

                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: () {
                  if (titleInputController.text.isNotEmpty &&
                      nameInputController.text.isNotEmpty &&
                      descriptionInputController.text.isNotEmpty) {
                    FirebaseFirestore.instance.collection("board").add({
                      "name": nameInputController.text,
                      "title": titleInputController.text,
                      "description": descriptionInputController.text,
                      "timestamp": DateTime.now(),
                    }).then((response) {
                      print(response.id);
                      Navigator.pop(context);
                      nameInputController.clear();
                      titleInputController.clear();
                      descriptionInputController.clear();
                    }).catchError((e) {
                      print(e);
                    });
                  }
                },
                child: Text("Save"),
              )
            ]
        )
    );
  }
}
