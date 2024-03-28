import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_network_app/components/user_search_tile.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
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
                  children: snapshot.data!.docs.map<Widget>(
                    (doc) {
                      final userData = doc.data()! as Map<String, dynamic>;
                      if (currentUser.email != userData['email']) {
                        return UserSearchTile(
                            userEmail: userData['email'],
                            username: userData['username']);
                      } else {
                        return const Row();
                      }
                    },
                  ).toList(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
