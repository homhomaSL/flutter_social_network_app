import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_network_app/components/user_tile.dart';

class MessengerPage extends StatelessWidget {
  MessengerPage({super.key});

  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map<Widget>((doc) {
                      final userData = doc.data()! as Map<String, dynamic>;
                      if (currentUser.email != userData['email']) {
                        return UserTile(
                          reciverUserEmail: userData['email'],
                          reciverUserId: userData['uid'],
                          reciverUsername: userData['username'],
                        );
                      } else {
                        return const Row();
                      }
                    }).toList(),
                  ),
                );
              })
        ],
      ),
      appBar: AppBar(
        title: const Text('Messenger'),
      ),
    );
  }
}
