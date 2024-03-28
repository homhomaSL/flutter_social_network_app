import 'package:flutter/material.dart';
import 'package:flutter_social_network_app/pages/chat_page.dart';

class UserTile extends StatelessWidget {
  final String reciverUserEmail;
  final String reciverUserId;
  final String reciverUsername;
  const UserTile({
    super.key,
    required this.reciverUserEmail,
    required this.reciverUserId,
    required this.reciverUsername,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(reciverUsername),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              reciverUserEmail: reciverUserEmail,
              reciverUserId: reciverUserId,
              reciverUsername: reciverUsername,
            ),
          ),
        );
      },
    );
  }
}
