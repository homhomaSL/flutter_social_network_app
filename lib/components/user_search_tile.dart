import 'package:flutter/material.dart';
import 'package:flutter_social_network_app/pages/another_user_profile.dart';

class UserSearchTile extends StatelessWidget {
  final String userEmail;
  final String username;
  final String uid;
  const UserSearchTile({
    super.key,
    required this.userEmail,
    required this.username,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(username),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnotherUserProfile(
              userEmail: userEmail,
              username: username,
              uid: uid,
            ),
          ),
        );
      },
    );
  }
}
