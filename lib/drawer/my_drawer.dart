import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_network_app/drawer/drawer_tile.dart';
import 'package:flutter_social_network_app/pages/home_page.dart';
import 'package:flutter_social_network_app/pages/messenger_page.dart';
import 'package:flutter_social_network_app/pages/profile_page.dart';
import 'package:flutter_social_network_app/pages/search_page.dart';
import 'package:flutter_social_network_app/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final currentUser = FirebaseAuth.instance.currentUser;

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                    child: Column(
                  children: [
                    const Row(),
                    const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Logged as: ${currentUser?.email} ',
                    ),
                  ],
                )),
                DrawerTile(
                  icon: Icons.person,
                  text: 'Profile',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  ),
                ),
                DrawerTile(
                  icon: Icons.people,
                  text: 'Search',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  ),
                ),
                DrawerTile(
                  icon: Icons.messenger_outline_rounded,
                  text: 'Messenger',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessengerPage(),
                    ),
                  ),
                ),
                DrawerTile(
                  icon: Icons.newspaper_rounded,
                  text: 'News',
                  onTap: () => Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  ),
                ),
                DrawerTile(
                  icon: Icons.settings_rounded,
                  text: 'Settings',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  ),
                ),
                DrawerTile(
                  icon: Icons.logout_rounded,
                  text: 'Logout',
                  onTap: signOut,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
