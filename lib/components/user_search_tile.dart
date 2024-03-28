import 'package:flutter/material.dart';
import 'package:flutter_social_network_app/pages/another_user_profile.dart';

class UserSearchTile extends StatelessWidget {
  final String userEmail;
  final String username;
  const UserSearchTile({
    super.key,
    required this.userEmail,
    required this.username,
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
            ),
          ),
        );
      },
    );
  }
}
