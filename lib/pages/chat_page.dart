import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_network_app/chat/chat_service.dart';
import 'package:flutter_social_network_app/components/chat_bubble.dart';
import 'package:flutter_social_network_app/components/my_textfield.dart';
import 'package:flutter_social_network_app/helper/methods_helper.dart';

class ChatPage extends StatefulWidget {
  final String reciverUserEmail;
  final String reciverUserId;
  final String reciverUsername;
  const ChatPage({
    super.key,
    required this.reciverUserEmail,
    required this.reciverUserId,
    required this.reciverUsername,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.trim().isNotEmpty) {
      await chatService.sendMessage(
          widget.reciverUserId, messageController.text);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reciverUsername),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatService.getMessages(
                  widget.reciverUserId, firebaseAuth.currentUser!.uid),
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
                    children: snapshot.data!.docs.map((doc) {
                      final messageData = doc.data()! as Map<String, dynamic>;
                      var aligment = (messageData['senderId'] ==
                              firebaseAuth.currentUser!.uid)
                          ? Alignment.centerRight
                          : Alignment.centerLeft;

                      var color = (messageData['senderId'] ==
                              firebaseAuth.currentUser!.uid)
                          ? const Color.fromARGB(255, 70, 211, 52)
                          : const Color.fromARGB(255, 132, 150, 252);

                      if (messageData['senderId'] ==
                          firebaseAuth.currentUser!.uid) {
                        return Align(
                          alignment: aligment,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(formatMessageDate(messageData['timestamp'])),
                              ChatBubble(
                                  text: messageData['message'], color: color),
                            ],
                          ),
                        );
                      } else {
                        return Align(
                          alignment: aligment,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ChatBubble(
                                  text: messageData['message'], color: color),
                              Text(formatMessageDate(messageData['timestamp'])),
                            ],
                          ),
                        );
                      }
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                    child: MyTextField(
                  controller: messageController,
                  hintText: "Message",
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
                      onPressed: sendMessage,
                      icon: Icon(
                        Icons.arrow_upward_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
