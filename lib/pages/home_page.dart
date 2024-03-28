import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_network_app/components/my_textfield.dart';
import 'package:flutter_social_network_app/components/post.dart';
import 'package:flutter_social_network_app/drawer/my_drawer.dart';
import 'package:flutter_social_network_app/helper/methods_helper.dart';
import 'package:flutter_social_network_app/pages/notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  void makePost() async {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('Posts').add({
        'UserEmail': currentUser.email,
        'Message': textController.text.trim(),
        'Timestamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsPage(),
                          ),
                        ),
                    icon: const Icon(Icons.notifications)),
                const Icon(Icons.person),
              ],
            ),
          ),
        ],
        title: const Text('News'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                    child: MyTextField(
                  controller: textController,
                  hintText: "Make a new post",
                )),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.tertiary)),
                  child: IconButton(
                      onPressed: makePost,
                      icon: Icon(
                        Icons.arrow_downward_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      )),
                )
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Posts')
                .orderBy('Timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final post = snapshot.data!.docs[index];
                    return Post(
                      user: post['UserEmail'],
                      message: post['Message'],
                      postId: post.id,
                      likes: List<String>.from(post['Likes'] ?? []),
                      time: formatDate(post['Timestamp']),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ))
        ],
      ),
    );
  }
}
