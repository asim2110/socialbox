import 'package:flutter/material.dart';

class Status_Screen extends StatefulWidget {
  const Status_Screen({super.key});

  @override
  State<Status_Screen> createState() => _Status_ScreenState();
}

class _Status_ScreenState extends State<Status_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("Status")),
      ),
    );
  }
}
