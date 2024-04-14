// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
import 'package:flutter_application/view/login.view.dart';
import 'package:flutter_application/view/register.view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeListView(),
    Text('Friend Page'),
    Text('Notification Page'),
    Text('Setting Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            'assets/images/logo2.png',
            width: 60,
            height: 60,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                const Text(
                  'Guest',
                  style: TextStyle(
                    color: Colors.grey, 
                    fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5,),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.grey),
                  onPressed: () {
                    // Logic for user action
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friend',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: GlobalColors.mainColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: Container(
        height: 80,
        width: MediaQuery.of(context).size.width * 0.4,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(60),
          boxShadow: [
            BoxShadow(
              color: GlobalColors.mainColor,
              spreadRadius: 1,
              blurRadius: 1,
              // offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
            // const SizedBox(height: 1), // Spasi antara baris pertama dan kedua
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterView(key: ValueKey('register_page')),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: GlobalColors.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Text(
                  'or',
                  style: TextStyle(fontSize: 11),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(key: ValueKey('login_page')),
                      ),
                    );
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: GlobalColors.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            'Other User Profiles',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 20, right: 20), 
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return Container(
                padding: const EdgeInsets.only(top: 4, left: 20, right: 20, bottom: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user.profileImage),
                  ),
                  title: GestureDetector(
                    onTap: () {
                      // Navigate to user profile page
                    },
                    child: Text(
                      user.username,
                      style: TextStyle(
                        color: GlobalColors.mainColor,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.person_add, color: GlobalColors.mainColor),
                        onPressed: () {
                          // Logic for "Follow" button
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.report, color: GlobalColors.mainColor),
                        onPressed: () {
                          // Logic for "Report" button
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
          ),
        ),
      ],
    );
  }
}

class User {
  final String profileImage;
  final String username;

  User({required this.profileImage, required this.username});
}

final List<User> userList = [
  User(profileImage: 'assets/images/profile1.jpg', username: '@bbyoyeo'),
  User(profileImage: 'assets/images/profile2.jpg', username: '@anggaraputra'),
  User(profileImage: 'assets/images/profile3.jpg', username: '@kusuma12'),
  User(profileImage: 'assets/images/profile4.jpg', username: '@ayrin_20'),
  User(profileImage: 'assets/images/profile5.jpg', username: '@mega.wati'),
  User(profileImage: 'assets/images/profile6.jpg', username: '@daisy.nta'),
  User(profileImage: 'assets/images/profile7.jpg', username: '@fadilla_.'),
  User(profileImage: 'assets/images/profile8.jpg', username: '@reka3112'),
  User(profileImage: 'assets/images/profile9.jpg', username: '@siintaprnm'),
  User(profileImage: 'assets/images/profile10.jpg', username: '@aridlest'),
  User(profileImage: 'assets/images/profile11.jpg', username: '@dianskii'),
  User(profileImage: 'assets/images/profile12.jpg', username: '@cracko.ofdawn'),
  User(profileImage: 'assets/images/profile13.jpg', username: '@godzilla'),
  User(profileImage: 'assets/images/profile14.jpg', username: '@yuhvsin'),
  User(profileImage: 'assets/images/profile15.jpg', username: '@reva_32'),
];
