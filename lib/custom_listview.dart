
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {

  final QuerySnapshot snapshot;
  final int index;

  CustomListView({Key key, this.snapshot, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var snapshotData = snapshot.docs[index];

    TextEditingController nameInputController = TextEditingController(text: snapshotData["name"]);
    TextEditingController titleInputController = TextEditingController(text: snapshotData["title"]);
    TextEditingController descriptionInputController = TextEditingController(text: snapshotData["description"]);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(snapshotData['title']),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async{
                    await showDialog(
                      context: context,
                      child: AlertDialog(
                        contentPadding: EdgeInsets.all(16.0),
                        content: Column(
                          children: [
                            Text("Update Your Details"),
                            Expanded(
                              child: TextField(
                                autofocus: true,
                                autocorrect: true,
                                decoration: InputDecoration(
                                    labelText: "Your Name"
                                ),
                                controller: nameInputController,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                autofocus: true,
                                autocorrect: true,
                                decoration: InputDecoration(
                                    labelText: "Title"
                                ),
                                controller: titleInputController,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                autofocus: true,
                                autocorrect: true,
                                decoration: InputDecoration(
                                    labelText: "Description"
                                ),
                                controller: descriptionInputController,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          FlatButton(onPressed: () {
                            nameInputController.clear();
                            titleInputController.clear();
                            descriptionInputController.clear();

                            Navigator.pop(context);
                          },
                            child: Text("Cancel"),
                          ),
                          FlatButton(onPressed: () async{

                            var docId = snapshotData.id;
                            if(titleInputController.text.isNotEmpty &&
                                nameInputController.text.isNotEmpty &&
                                descriptionInputController.text.isNotEmpty) {

                              FirebaseFirestore.instance.collection("board")
                                  .doc(docId).update({
                                "name" : nameInputController.text,
                                "title" : titleInputController.text,
                                "description": descriptionInputController.text,
                                "timestamp" : DateTime.now(),
                              }).then((response){
                                Navigator.pop(context);
                                nameInputController.clear();
                                titleInputController.clear();
                                descriptionInputController.clear();
                              }).catchError((e){
                                print(e);
                              });
                            }
                          },
                            child: Text("Update"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async{
                      var docId = snapshotData.id;
                      await FirebaseFirestore.instance.collection("board")
                          .doc(docId).delete();
                    }
                ),
              ]
          )
        ],
      ),
    );
  }
}
