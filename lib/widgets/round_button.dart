import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  bool loading;
  RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 50,
        child: Center(
            child: loading
                ? CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  )
                : Text(
                    title,
                    style: TextStyle(color: Colors.white),
                  )),
      ),
    );
  }
}
