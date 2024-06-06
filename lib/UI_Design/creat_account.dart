import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:socialbox/Auth_Services/auth_services.dart';
import 'package:socialbox/UI_Design/login.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  XFile? img;
  bool isImage = false;
  pickimage() async {
    ImagePicker imgpicker = ImagePicker();
    var pickedimg = await imgpicker.pickImage(source: ImageSource.gallery);
    if (pickedimg != null) {
      img = pickedimg;
      isImage = true;
      setState(() {});
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.14,
                ),
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.blue,
                  child: GestureDetector(
                    onTap: () {
                      pickimage();
                    },
                    child: isImage == false
                        ? const CircleAvatar(
                            radius: 78,
                            backgroundColor: Colors.blue,
                          )
                        : CircleAvatar(
                            radius: 78,
                            backgroundImage: FileImage(File(img!.path)),
                            backgroundColor: Colors.blue,
                          ),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Card(
                  elevation: 01,
                  color: Colors.white,
                  child: Container(
                    height: 48,
                    child: TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
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
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
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
                  height: height * 0.01,
                ),
                Card(
                  elevation: 01,
                  color: Colors.white,
                  child: Container(
                    height: 48,
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Phone",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                SizedBox(
                  width: width * 0.70,
                  child: ElevatedButton(
                    onPressed: () async {
                      final message = await AuthService().registration(
                        img: img!,
                        Name: _nameController.text.trim(),
                        Email: _emailController.text.trim(),
                        Password: _passwordController.text.trim(),
                        Phone: _phoneController.text.trim(),
                      );
                      if (message!.contains('Success')) {}
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                    },
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 0, 128, 105),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to((LoginScreen()));
                        },
                        child: Text(
                          "LogIn",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
