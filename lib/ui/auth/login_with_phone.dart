import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/ui/auth/verify_otp_for_phone_login.dart';
import 'package:flutter_firebase_1/utils/utils.dart';
import 'package:flutter_firebase_1/widgets/round_button.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final phonecontroller = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: phonecontroller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: 'Phone Number'),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    auth.verifyPhoneNumber(
                      phoneNumber: phonecontroller.text,
                      verificationCompleted: (_) {
                        setState(() {
                          loading = false;
                        });
                      },
                      verificationFailed: (error) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toast(error.toString());
                      },
                      codeSent: (verificationID, forceResendingToken) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VerifyOTP(
                                  verificationID: verificationID,
                                )));
                        setState(() {
                          loading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (verificationId) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toast(verificationId.toString());
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
