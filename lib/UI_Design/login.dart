import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:socialbox/Auth_Services/auth_services.dart';
import 'package:socialbox/Models/static_model.dart';
import 'package:socialbox/UI_Design/creat_account.dart';
import 'package:socialbox/UI_Design/home.dart';
import 'package:socialbox/UI_Design/notification_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ///this code for notification start
  FirebaseMessaging? messaging;
  getToken() {
    messaging = FirebaseMessaging.instance;
    messaging!.getToken().then((value) {
      if (value != null) {
        setState(() {
          StaticUser.my_token = value;
        });
      }
      print(value);
    });
  }

  @override
  void initState() {
    getToken();
    ////////////////// ye code move krna he jaha per call krna ho wo page jo lazmi open hoga start me //////////////////
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          print(message);
          print(message);
          print("knock kock");
        }
      },
    );
    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print(message);
        print("Yaha a k call karlena method smjh i");
        if (message.notification != null) {
          LocalNotificationService.createAndDisplayChatNotification(message);
        }
      },
    );
    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print('app open on click');
        print(message.notification!.body);
        print(message.notification!.title);
        print(message.data);
        if (message.notification != null) {}
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        Container(
          height: height,
          width: width,
          color: const Color.fromARGB(255, 0, 128, 105),
          child: Lottie.asset("assets/background.json"),
        ),
        Container(
          height: height,
          width: width,
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.14,
                ),
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: height * 0.05,
                  width: width * 0.14,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      "BOX",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 128, 105),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.10,
                ),
                Card(
                  elevation: 01,
                  color: Colors.white,
                  child: Container(
                    height: 48,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Card(
                  elevation: 01,
                  color: Colors.white,
                  child: Container(
                    height: 48,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.visibility),
                        prefixIcon: Icon(Icons.password_outlined),
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final message = await AuthService().login(
                      Email: _emailController.text,
                      Password: _passwordController.text,
                    );
                    if (message!.contains('Success')) {
                      // Get.to((HomeScreen()));
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  },
                  child: const Text(
                    '           Login           ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 0, 128, 105),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => CreateAccount());
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
