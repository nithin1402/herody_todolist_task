import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth_provider.dart';
import 'add_list_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore ff = FirebaseFirestore.instance;
  String uid = "";

  @override
  void initState() {
    super.initState();
    getUID();
  }

  void getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("UID") ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AUTHProvider>(context, listen: false).logout();

              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove("LOGIN");

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ff
            .collection("todoList")
            .where("uid", isEqualTo: uid)
            .snapshots(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text("No tasks found."));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snap.data!.docs.length,
              itemBuilder: (_, index) {
                var doc = snap.data!.docs[index];
                return Card(
                  child: ListTile(
                    title: Text(doc["data"]),
                    leading: Checkbox(
                      value: doc["completed"],
                      onChanged: (val) async {
                        await ff.collection("todoList").doc(doc.id).update({
                          "completed": val,
                        });
                      },
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpDatePage(
                                    mDataId: doc.id,
                                    existingText: doc["data"],
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ff.collection("todoList").doc(doc.id).delete();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddListPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
