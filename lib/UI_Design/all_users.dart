import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialbox/Auth_Services/auth_services.dart';
import 'package:socialbox/Models/static_model.dart';
import 'package:socialbox/Models/users_model.dart';
import 'package:uuid/uuid.dart';

class All_Users extends StatefulWidget {
  const All_Users({super.key});

  @override
  State<All_Users> createState() => _All_UsersState();
}

class _All_UsersState extends State<All_Users> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 3,
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
            title: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 28,
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color.fromRGBO(5, 48, 122, 0.804),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        NetworkImage(StaticUser.my_model!.profile.toString()),
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Container(
                  width: width * 0.48,
                  height: height * 0.05,
                  alignment: Alignment.center,
                  child: Text(
                    StaticUser.my_model!.Name.toString(),
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                PopupMenuButton(
                  color: Colors.white,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          "New Group",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text(
                        "New broadcast",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Text(
                        "Linked devices",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Text(
                        "Starred messages",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            floating: true,
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .where("UserId", isNotEqualTo: StaticUser.my_model!.UserId)
                  .snapshots(),
              builder: (context, snapshote) {
                return snapshote.hasData
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: snapshote.data!.docs.length,
                          (context, index) {
                            UsersModel usersmodel = UsersModel.fromMap(
                                snapshote.data!.docs[index].data());
                            return Card(
                              elevation: 01,
                              color: Colors.white,
                              child: ListTile(
                                leading: usersmodel.profile! == "Null" ||
                                        usersmodel.profile == ""
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            Color.fromARGB(255, 0, 128, 105),
                                        child: CircleAvatar(
                                          radius: 27,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 33,
                                        backgroundColor:
                                            Color.fromARGB(255, 0, 128, 105),
                                        child: CircleAvatar(
                                          radius: 26,
                                          backgroundImage: NetworkImage(
                                              usersmodel.profile.toString()),
                                        ),
                                      ),
                                title: Text(
                                  usersmodel.Name.toString(),
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Row(
                                  children: [
                                    Container(
                                      height: height * 0.04,
                                      child: ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.person_remove_outlined,
                                          size: 14,
                                          color: const Color.fromARGB(
                                              255, 186, 62, 53),
                                        ),
                                        label: Text(
                                          "remove",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: const Color.fromARGB(
                                                255, 186, 62, 53),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.08,
                                    ),
                                    Container(
                                      height: height * 0.04,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          var id = Uuid().v4();
                                          final message = AuthService()
                                              .SetRequest(
                                                  receiverid: usersmodel.UserId
                                                      .toString(),
                                                  requestid: id);
                                          CircularProgressIndicator(
                                            color: Colors.black,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.person_add_outlined,
                                          size: 14,
                                          color:
                                              Color.fromARGB(255, 0, 128, 105),
                                        ),
                                        label: Text(
                                          "friends",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Color.fromARGB(
                                                255, 0, 128, 105),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                        )),
                      );
              }),
        ],
      ),
    );
  }
}
