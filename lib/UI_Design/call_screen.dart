import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialbox/UI_Design/calls_contects.dart';

class Call_Screen extends StatefulWidget {
  const Call_Screen({super.key});

  @override
  State<Call_Screen> createState() => _Call_ScreenState();
}

class _Call_ScreenState extends State<Call_Screen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 128, 105),
        onPressed: () => Get.to((Calls_Contects())),
        child: const Icon(
          Icons.add_call,
          color: Colors.white,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 59, 190, 190),
                    Color.fromARGB(255, 0, 128, 105),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FlexibleSpaceBar(
                centerTitle: true,
              ),
            ),
            foregroundColor: Colors.white,
            actions: [
              Container(
                height: height * 0.06,
                width: width * 0.16,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 11, 218, 180),
                        Color.fromARGB(255, 127, 85, 6),
                        Color.fromARGB(255, 129, 230, 52),
                        Color.fromARGB(226, 0, 0, 0),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Center(
                  child: Text(
                    "BoX",
                    style: TextStyle(
                        color: Color.fromARGB(255, 235, 235, 235),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.45,
              ),
              Icon(Icons.camera_alt_outlined),
              SizedBox(
                width: width * 0.08,
              ),
              Icon(Icons.search_rounded),
              SizedBox(
                width: width * 0.04,
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: "1",
                        child: GestureDetector(
                          onTap: () {
                            // Get.offAll(Login_screen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.logout_outlined,
                                color: Colors.black,
                              ),
                              Text(
                                "Log out",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                    PopupMenuItem(
                        value: "2",
                        child: GestureDetector(
                          onTap: () {
                            // Get.to(ProfileScreen());
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              Text(
                                "Profile",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  ];
                },
              )
            ],
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 20,
              (context, index) {
                return Card(
                  elevation: 01,
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Color.fromARGB(255, 0, 128, 105),
                      child: CircleAvatar(
                        radius: 27,
                      ),
                    ),
                    title: Row(
                      children: [
                        SizedBox(
                          width: width * 0.48,
                          child: Text(
                            "Muhammad Asim kharal",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.11,
                        ),
                        Text(
                          "03:36",
                          style: TextStyle(
                            fontSize: 08,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 128, 105),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.arrow_outward,
                          size: 20,
                          color: Color.fromARGB(255, 0, 128, 105),
                        ),
                        Text(
                          "today",
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(
                          width: width * 0.26,
                        ),
                        Icon(
                          Icons.call,
                          color: Color.fromARGB(255, 0, 128, 105),
                          size: 24,
                        ),
                        SizedBox(
                          width: width * 0.10,
                        ),
                        Icon(
                          Icons.video_call,
                          color: Color.fromARGB(255, 0, 128, 105),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
