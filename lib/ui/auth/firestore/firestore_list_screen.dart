import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_1/ui/auth/firestore/firestore_add_data..dart';
import 'package:flutter_firebase_1/utils/utils.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final searchController = TextEditingController();
  final fireStoreRef =
      FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Firestore Posts'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              // MenuAnchor(
              //   menuChildren: [
              //     GestureDetector(
              //       child: Row(
              //         children: [
              //           Text('Logout'),
              //           const SizedBox(
              //             width: 4,
              //           ),
              //           Icon(Icons.logout)
              //         ],
              //       ),
              //       onTap: () {
              //         auth.signOut();
              //       },
              //     )
              //   ],
              //   child: Icon(Icons.menu),
              // )
              IconButton(
                  onPressed: () {
                    auth.signOut();
                  },
                  icon: const Icon(Icons.logout))
            ]),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text("Something went wrong :(");
                }
                return Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String title =
                        snapshot.data!.docs[index].get('title').toString();
                    if (searchController.text.isEmpty) {
                      return ListTile(
                        title: Text(title),
                        subtitle: Text(
                            snapshot.data!.docs[index].get('id').toString()),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showAlertDialogForUpdate(
                                    title,
                                    snapshot.data!.docs[index]
                                        .get('id')
                                        .toString());
                              },
                              leading: const Icon(Icons.edit),
                              title: const Text("Edit"),
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text("Delete"),
                              onTap: () {
                                Navigator.pop(context);
                                showAlertDialogForDelete(
                                    snapshot,
                                    snapshot.data!.docs[index]
                                        .get('id')
                                        .toString());
                              },
                            )),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      );
                    } else if (title
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                      return ListTile(
                        title: Text(title),
                        subtitle: Text(
                            snapshot.data!.docs[index].get('id').toString()),
                      );
                    } else {
                      return Container();
                    }
                  },
                ));
              },
              stream: fireStoreRef,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddFirestorePostScreen()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> showAlertDialogForUpdate(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit"),
            content: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: editController,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref
                        .doc(id)
                        .update({'title': editController.text}).then((value) {
                      Utils().toast("Post Updated");
                    }).onError((error, stackTrace) {
                      Utils().toast(error.toString());
                    });
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }

  Future<void> showAlertDialogForDelete(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Post?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    ref.doc(id).delete().then((value) {
                      Utils().toast("Post Deleted!");
                    }).onError((error, stackTrace) {
                      Utils().toast(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Delete"))
            ],
          );
        });
  }
}
