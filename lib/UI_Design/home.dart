import 'package:flutter/material.dart';
import 'package:socialbox/UI_Design/all_request.dart';
import 'package:socialbox/UI_Design/call_screen.dart';
import 'package:socialbox/UI_Design/chat_screen.dart';
import 'package:socialbox/UI_Design/status_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Chat_Screen(),
          Status_Screen(),
          All_Request(),
          Call_Screen(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Badge(
              backgroundColor: Color.fromARGB(255, 33, 116, 176),
              label: Text("7"),
              child: Icon(Icons.chat),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              backgroundColor: Color.fromARGB(255, 33, 116, 176),
              // label: Text("7"),
              child: Icon(Icons.swap_vertical_circle_outlined),
            ),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              backgroundColor: Color.fromARGB(255, 33, 116, 176),
              label: Text("7"),
              child: Icon(Icons.group_outlined),
            ),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              backgroundColor: Color.fromARGB(255, 33, 116, 176),
              label: Text("22"),
              child: Icon(
                Icons.call_outlined,
              ),
            ),
            label: 'Calls',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 0, 128, 105),
        unselectedItemColor: Color.fromARGB(255, 55, 59, 78),
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
