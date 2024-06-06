import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialbox/Models/friend_model.dart';
import 'package:socialbox/Models/static_model.dart';
import 'package:socialbox/UI_Design/all_users.dart';
import 'package:socialbox/UI_Design/chatroom.dart';
import 'package:socialbox/UI_Design/login.dart';
import 'package:socialbox/UI_Design/notification.dart';

class Chat_Screen extends StatefulWidget {
  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {

  ////this code for message id
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  bool isOnline = true;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 128, 105),
        onPressed: () {
          Get.to((All_Users()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
              GestureDetector(
                  onTap: () {
                    Get.to((Notification_screen()));
                  },
                  child: Icon(Icons.notifications_active_rounded)),
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
                            FirebaseAuth.instance.signOut();
                            Get.offAll((LoginScreen()));
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
            floating: true,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Friends")
                  .doc(StaticUser.my_model!.UserId)
                  .collection("List")
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: snapshot.data!.docs.length,
                          (context, index) {
                            FriendsModel fmodel = FriendsModel.fromMap(
                                snapshot.data!.docs[index].data());
                            return GestureDetector(
                              onTap: () {
                                String chatid = chatRoomId(
                                    StaticUser.my_model!.UserId.toString(),
                                    fmodel.id.toString());

                                Get.to(
                                  () => ChatsRoom(
                                    //// aik new id send krni hy chate room id k sath chat min
                                    model: fmodel,
                                    chatRoomId: chatid,
                                  ),
                                );
                              },
                              child: Card(
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
                                          fmodel.profile.toString()),
                                    ),
                                  ),
                                  title: Text(
                                    fmodel.Name.toString(),
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    fmodel.Gmail.toString(),
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  subtitleTextStyle: TextStyle(
                                      color: Color.fromARGB(255, 24, 25, 24),
                                      fontSize: 12),
                                  trailing: Column(
                                    children: [
                                      Text(
                                        "03:36 pm",
                                        style: TextStyle(
                                          fontSize: 08,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 0, 128, 105),
                                        ),
                                      ),
                                      Badge(
                                        backgroundColor:
                                            Color.fromARGB(255, 0, 128, 105),
                                        label: Text("35"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                      );
              }),
        ],
      ),
    );
  }
}
