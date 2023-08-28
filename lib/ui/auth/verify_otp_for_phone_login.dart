import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/ui/posts/posts_screen.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class VerifyOTP extends StatefulWidget {
  final verificationID;
  const VerifyOTP({super.key, required this.verificationID});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final otpcontroller = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: otpcontroller,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'Enter the OTP'),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    final credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationID,
                        smsCode: otpcontroller.text.toString());
                    try {
                      await auth.signInWithCredential(credential);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PostsScreen()));
                    } catch (e) {
                      loading = false;
                      Utils().toast(e.toString());
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
