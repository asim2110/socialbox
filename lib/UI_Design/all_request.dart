import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialbox/Auth_Services/auth_services.dart';
import 'package:socialbox/Models/request_model.dart';
import 'package:socialbox/Models/static_model.dart';
import 'package:socialbox/UI_Design/login.dart';

class All_Request extends StatefulWidget {
  const All_Request({super.key});

  @override
  State<All_Request> createState() => _All_RequestState();
}

class _All_RequestState extends State<All_Request> {
  bool isRecommendedSelected = false;
  bool isFavoriteSelected = false;
  Color cancelColor = Colors.red; // Initial color for Cancel button
  Color confirmColor = Colors.green; // Initial color for Confirm button
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                height: height * 0.05,
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
                          onTap: () {},
                          child: GestureDetector(
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              Get.to((LoginScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.logout_outlined,
                                  color: Color.fromARGB(255, 0, 128, 105),
                                ),
                                Text(
                                  "Log out",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
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
                                color: Color.fromARGB(255, 0, 128, 105),
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
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("Requests")
                  .where("receiverId", isEqualTo: StaticUser.my_model!.UserId)
                  .where("status", isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: snapshot.data!.docs.length,
                          (context, index) {
                            RequestModel requestModel = RequestModel.fromMap(
                                snapshot.data!.docs[index].data());
                            return Card(
                              elevation: 01,
                              color: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Color.fromARGB(255, 0, 128, 105),
                                  child: CircleAvatar(
                                    radius: 27,
                                    backgroundImage: NetworkImage(
                                        requestModel.Senderprofile.toString()),
                                  ),
                                ),
                                title: Text(
                                  requestModel.senderName.toString(),
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        AuthService().DeleteRequest(
                                            requestModel: requestModel);
                                        setState(() {
                                          cancelColor = Colors
                                              .blue; // Change color when pressed
                                        });
                                      },
                                      child: Container(
                                        height: height * 0.04,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            AuthService().DeleteRequest(
                                                requestModel: requestModel);
                                            setState(() {
                                              confirmColor = Color.fromARGB(
                                                  255,
                                                  237,
                                                  35,
                                                  4); // Change color when pressed
                                            });
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: 14,
                                            color: const Color.fromARGB(
                                                255, 186, 62, 53),
                                          ),
                                          label: Text(
                                            "Cancle",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: const Color.fromARGB(
                                                  255, 186, 62, 53),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.08),
                                    GestureDetector(
                                      onTap: () {
                                        AuthService().AcceptRequest(
                                            requestModel: requestModel);
                                        setState(() {
                                          confirmColor = Colors
                                              .blue; // Change color when pressed
                                        });
                                      },
                                      child: Container(
                                        height: height * 0.04,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            AuthService().AcceptRequest(
                                                requestModel: requestModel);
                                            setState(() {
                                              confirmColor = Colors
                                                  .blue; // Change color when pressed
                                            });
                                          },
                                          icon: Icon(
                                            Icons.done,
                                            size: 14,
                                            color: Color.fromARGB(
                                                255, 0, 128, 105),
                                          ),
                                          label: Text(
                                            "Confirm",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Color.fromARGB(
                                                  255, 0, 128, 105),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //  Row(
                                //   children: [
                                //     Container(
                                //       height: height * 0.04,
                                //       child: ElevatedButton.icon(
                                //         onPressed: () {
                                //           AuthService().DeleteRequest(
                                //               requestModel: requestModel);
                                //         },
                                //         icon: Icon(
                                //           Icons.close,
                                //           size: 14,
                                //           color: const Color.fromARGB(
                                //               255, 186, 62, 53),
                                //         ),
                                //         label: Text(
                                //           "Cancle",
                                //           style: TextStyle(
                                //             fontSize: 10,
                                //             color: const Color.fromARGB(
                                //                 255, 186, 62, 53),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: width * 0.08,
                                //     ),
                                //     Container(
                                //       height: height * 0.04,
                                //       child: ElevatedButton.icon(
                                //         onPressed: () {
                                //           AuthService().AcceptRequest(
                                //               requestModel: requestModel);
                                //         },
                                //         icon: Icon(
                                //           Icons.done,
                                //           size: 14,
                                //           color:
                                //               Color.fromARGB(255, 0, 128, 105),
                                //         ),
                                //         label: Text(
                                //           "Confirm",
                                //           style: TextStyle(
                                //             fontSize: 10,
                                //             color: Color.fromARGB(
                                //                 255, 0, 128, 105),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ),
                            );
                          },
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        )),
                      );
              }),
        ],
      ),
    );
  }
}
