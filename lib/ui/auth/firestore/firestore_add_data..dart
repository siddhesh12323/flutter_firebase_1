import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/utils/utils.dart';
import 'package:flutter_firebase_1/widgets/round_button.dart';

class AddFirestorePostScreen extends StatefulWidget {
  const AddFirestorePostScreen({super.key});

  @override
  State<AddFirestorePostScreen> createState() => _AddFirestorePostScreenState();
}

class _AddFirestorePostScreenState extends State<AddFirestorePostScreen> {
  bool loading = false;
  final postController = TextEditingController();
  final fireStoreRef = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Firestore Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                maxLines: 3,
                controller: postController,
                decoration: const InputDecoration(
                  hintText: 'Enter your thoughts',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  title: 'Add',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    fireStoreRef.doc(id).set({
                      'title': postController.text.toString(),
                      'id': id
                    }).then((value) {
                      Utils().toast("Posted successfully!");
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      Utils().toast(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
