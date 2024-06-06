import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialbox/Models/notification_save.dart';
import 'package:socialbox/Models/static_model.dart';


class Notification_screen extends StatefulWidget {
  const Notification_screen({super.key});

  @override
  State<Notification_screen> createState() => _Notification_screenState();
}

class _Notification_screenState extends State<Notification_screen> {
  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: height,
          width: width,
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("Notification")
                  .doc(StaticUser.my_model!.UserId)
                  .collection("List")
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          NotificationModel model = NotificationModel.fromMap(
                              snapshot.data!.docs[index].data());

                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 10,
                              color: Color.fromARGB(255, 0, 128, 105),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                // margin: EdgeInsets.all(10),
                                height: height * 0.1,
                                width: width * 0.06,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 128, 105),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    CircleAvatar(
                                        radius: height * 0.04,
                                        backgroundImage: NetworkImage(
                                          model.profile.toString(),
                                        )),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Text(
                                            model.title.toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: height * 0.006,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: height * 0.04,
                                                width: width * 0.44,
                                                color: Color.fromARGB(
                                                    255, 0, 128, 105),
                                                child: Text(
                                                  model.body.toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text("no data found"),
                      );
              })),
    );
  }
}