import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddListPage extends StatelessWidget {
  const AddListPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController todoController = TextEditingController();
    FirebaseFirestore ff = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: todoController,
              decoration: InputDecoration(
                hintText: "Enter todo here...",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                SizedBox(width: 11),
                ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      String uid = prefs.getString("UID") ?? "";

                      await ff.collection("todoList").add({
                        "completed": false,
                        "data": todoController.text,
                        "uid": uid,
                      });

                      Navigator.pop(context);
                    },
                    child: Text("Add")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UpDatePage extends StatelessWidget {
  final String mDataId;
  final String existingText;

  UpDatePage({super.key, required this.mDataId, required this.existingText});

  @override
  Widget build(BuildContext context) {
    TextEditingController upDateController =
    TextEditingController(text: existingText);
    FirebaseFirestore ff = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Todo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: upDateController,
              decoration: InputDecoration(
                hintText: "Update data here...",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                SizedBox(width: 11),
                ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      String uid = prefs.getString("UID") ?? "";

                      ff.collection("todoList").doc(mDataId).update({
                        "completed": false,
                        "data": upDateController.text,
                        "uid": uid,
                      });

                      Navigator.pop(context);
                    },
                    child: Text("Update")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
