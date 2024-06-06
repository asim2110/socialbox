import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialbox/UI_Design/contect_info.dart';
import 'package:socialbox/UI_Design/home.dart';

class Calls_Contects extends StatefulWidget {
  const Calls_Contects({super.key});

  @override
  State<Calls_Contects> createState() => _Calls_ContectsState();
}

class _Calls_ContectsState extends State<Calls_Contects> {
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
                  onTap: () => Get.to((HomeScreen())),
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
                    "Muhammad Asimhjdhkj",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                    // width: width * 0.375,
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 20,
              (context, index) {
                return GestureDetector(
                  onTap: () => Get.to((Info_Screen())),
                  child: Card(
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
                      title: Text(
                        "any Name of personcxkvxxjclvjsjhdfkjsdhfkjsdhfkklkv",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        "asim.llms@gmail.com",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400),
                      ),
                      subtitleTextStyle: TextStyle(
                          color: Color.fromARGB(255, 24, 25, 24), fontSize: 12),
                      trailing: Text(""),
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
