import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text('Posts'),
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
                  icon: Icon(Icons.logout))
            ]),
        body: Container(),
      ),
    );
  }
}
