import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_network_app/components/comment.dart';
import 'package:flutter_social_network_app/components/comment_button.dart';
import 'package:flutter_social_network_app/components/like_button.dart';
import 'package:flutter_social_network_app/components/my_textfield.dart';
import 'package:flutter_social_network_app/helper/methods_helper.dart';
import 'package:get/get.dart';

class Post extends StatefulWidget {
  final String user;
  final String message;
  final String postId;
  final List<String> likes;
  final String time;
  const Post({
    super.key,
    required this.user,
    required this.message,
    required this.likes,
    required this.postId,
    required this.time,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final commentTextController = TextEditingController();
  bool isVisible = false;
  String? commentCount = '0';

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleComment() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      'CommentText': commentText,
      'CommentedBy': currentUser.email,
      'CommentTime': Timestamp.now()
    });
  }

  void deletePost() {
    showDialog(
        context: context,
        builder: (build) => AlertDialog(
              title: const Text('Delete post'),
              content:
                  const Text('Are you shure you want to delete this post?'),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cencel',
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        )),
                    TextButton(
                        onPressed: () async {
                          final commentDocs = await FirebaseFirestore.instance
                              .collection('Posts')
                              .doc(widget.postId)
                              .collection('Comments')
                              .get();
                          for (var doc in commentDocs.docs) {
                            await FirebaseFirestore.instance
                                .collection('Posts')
                                .doc(widget.postId)
                                .collection('Comments')
                                .doc(doc.id)
                                .delete();
                          }

                          FirebaseFirestore.instance
                              .collection('Posts')
                              .doc(widget.postId)
                              .delete()
                              .then((value) => print('post deleted'))
                              .catchError((onError) => printError());
                          Get.back();
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        )),
                  ],
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.user),
                      Text(
                        widget.time,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      )
                    ],
                  ),
                ],
              ),
              if (widget.user == currentUser.email)
                IconButton(
                  onPressed: deletePost,
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(widget.message)),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(commentCount as String,
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.inversePrimary)),
                  const SizedBox(width: 5),
                  CommentButton(onTap: toggleComment),
                  const SizedBox(width: 10),
                ],
              ),
              Row(
                children: [
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  const SizedBox(width: 5),
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                ],
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Posts')
                .doc(widget.postId)
                .collection('Comments')
                .orderBy('CommentTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              commentCount = snapshot.data?.docs.length.toString();
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Visibility(
                visible: isVisible,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return MyComment(
                      text: commentData['CommentText'],
                      time: formatDate(commentData['CommentTime']),
                      user: commentData['CommentedBy'],
                    );
                  }).toList(),
                ),
              );
            },
          ),
          Visibility(
            visible: isVisible,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                      child: MyTextField(
                    controller: commentTextController,
                    hintText: "Write your comment here",
                  )),
                  IconButton(
                      onPressed: () {
                        addComment(commentTextController.text);
                        commentTextController.clear();
                      },
                      icon: const Icon(Icons.arrow_upward))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
