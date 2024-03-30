import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendRequest extends StatelessWidget {
  final String friendEmail;
  final String requestDataId;
  final String uid;
  final String username;
  const FriendRequest({
    super.key,
    required this.requestDataId,
    required this.uid,
    required this.username,
    required this.friendEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            children: [Text(username)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Requests')
                        .doc(requestDataId)
                        .delete();
                  },
                  child: Text('Reject')),
              TextButton(
                  onPressed: () async {
                    FirebaseFirestore.instance.collection('Friends').add({
                      'uid': uid,
                      'username': username,
                      'friendEmail': friendEmail,
                    });
                    FirebaseFirestore.instance
                        .collection('Requests')
                        .doc(requestDataId)
                        .delete();
                  },
                  child: Text('Accept'))
            ],
          )
        ],
      ),
    );
  }
}
