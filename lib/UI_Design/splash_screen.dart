import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialbox/Models/static_model.dart';
import 'package:socialbox/UI_Design/home.dart';
import 'package:socialbox/UI_Design/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getDataFromSF();

    super.initState();
  }

  getDataFromSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("uid");
    if (id == null) {
      Future.delayed(Duration(seconds: 5), () {
        Get.to((LoginScreen()));
      });
    } else {
      StaticUser.my_model!.UserId = id;

      Future.delayed(Duration(seconds: 5), () {
        Get.to((HomeScreen()));
      });
    }
    print("my id is $id");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            image: DecorationImage(
              image: AssetImage("assets/background.json"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
