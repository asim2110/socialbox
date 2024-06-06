import 'package:flutter/material.dart';

class Info_Screen extends StatefulWidget {
  const Info_Screen({super.key});

  @override
  State<Info_Screen> createState() => _Info_ScreenState();
}

class _Info_ScreenState extends State<Info_Screen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 0, 128, 105),
        title: Text("Contect Info"),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: height * 0.07,
            ),
            CircleAvatar(
              radius: 70,
              backgroundColor: Color.fromARGB(255, 0, 128, 105),
              child: CircleAvatar(
                radius: 66,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Divider(),
            SizedBox(
                width: width * 0.60,
                child: Text(
                  "Muhammad Asim",
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                )),
            Divider(),
            SizedBox(
                width: width * 0.60,
                child: Text(
                  "asim.llms@gmail.com",
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                )),
            Divider(),
            SizedBox(
                width: width * 0.60,
                child: Text(
                  "+923013931947",
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                )),
            Divider(),
            Container(
                height: height * 0.07,
                width: width,
                margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.call,
                      color: Color.fromARGB(255, 0, 128, 105),
                      size: 28,
                    ),
                    Icon(
                      Icons.message,
                      color: Color.fromARGB(255, 0, 128, 105),
                      size: 28,
                    ),
                    Icon(
                      Icons.video_call,
                      color: Color.fromARGB(255, 0, 128, 105),
                      size: 28,
                    )
                  ],
                )),
            Divider(),
            SizedBox(
              height: height * 0.22,
            ),
            Icon(
              Icons.published_with_changes,
              color: Color.fromARGB(255, 0, 128, 105),
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
