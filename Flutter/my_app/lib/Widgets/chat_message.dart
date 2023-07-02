import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Widgets/message_buddle.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    print('token ${token}');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    final authenticateUSer = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Tesst Messsage sssss'),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Has Error'),
          );
        }

        final messsageCount = snapshot.data!.docs;

        return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
            reverse: true,
            itemCount: messsageCount.length,
            itemBuilder: (context, index) {
              final chatMessage = messsageCount[index].data();
              final nextMessage = index + 1 < messsageCount.length
                  ? messsageCount[index + 1].data()
                  : null;
              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextMessage != null ? nextMessage['userId'] : null;
              final nextUserIsTheSame =
                  currentMessageUserId == nextMessageUserId;
              if (nextUserIsTheSame) {
                return MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: currentMessageUserId == authenticateUSer.uid);
              } else {
                return MessageBubble.first(
                    userImage: chatMessage['image_url'],
                    username: chatMessage['username'],
                    message: chatMessage['text'],
                    isMe: currentMessageUserId == authenticateUSer.uid);
              }
            });
      },
    );
  }
}
