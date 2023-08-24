import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/utils/utils.dart';
import 'package:flutter_firebase_1/widgets/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final postController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
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
                decoration: InputDecoration(
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
                    databaseRef
                        .child(DateTime.now().millisecondsSinceEpoch.toString())
                        .set({
                      'title': postController.text.toString(),
                      'id': DateTime.now().millisecondsSinceEpoch.toString()
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toast('Posted successfully!');
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toast(error.toString());
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
