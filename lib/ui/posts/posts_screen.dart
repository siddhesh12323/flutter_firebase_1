import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_1/ui/posts/add_post.dart';
import 'package:flutter_firebase_1/utils/utils.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchController = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Posts'),
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
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'Search',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: ref,
                  defaultChild: const Text('Loading...'),
                  itemBuilder: (context, snapshot, animation, index) {
                    final title = snapshot.child('title').value.toString();
                    if (searchController.text.isEmpty) {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showAlertDialogForUpdate(
                                  title,
                                  snapshot.child('id').value.toString(),
                                );
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
                                showAlertDialogForDelete(snapshot);
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
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddPostScreen()));
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
                    ref
                        .child(id)
                        .update({'title': editController.text}).then((value) {
                      Utils().toast("Post Updated");
                    }).onError((error, stackTrace) {
                      Utils().toast(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }

  Future<void> showAlertDialogForDelete(DataSnapshot snapshot) async {
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
                    ref.child(snapshot.child('id').value.toString()).remove();
                    Navigator.pop(context);
                  },
                  child: const Text("Delete"))
            ],
          );
        });
  }
}
