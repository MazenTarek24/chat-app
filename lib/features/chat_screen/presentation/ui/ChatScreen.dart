import 'dart:convert';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String receiverName;
// Unique channel name for this chat

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final senderId = FirebaseAuth.instance.currentUser!.uid;

  late RtcEngine _engine;
  final String appId = '97e9b1a28f014124aff6043a017391ee'; // Replace with your Agora App ID
  final String token = '007eJxTYCiJOihj/EJyVV2itEJNZ/OyhcFvi1nUeH76Zja5arZH7lJgSDUxsjA3TTVISrG0MElLS0myMDIztEg2M0kyNEg2S7b8YzArvSGQkSEs4DAjIwMEgvg8DMkZiSUKQCIvLzWHgQEAqyEgiA=='; // Optional: Token for secure access
  final String channelName = 'testChannel';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeAgora();
  }

  @override
  void dispose() {
    _engine.release();
    super.dispose();
  }
  
  void _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isNotEmpty) {
      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

      // Add message to sub-collection
      chatRef.collection('messages').add({
        'text': message,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update chat document with last message
      chatRef.update({
        'lastMessage': message,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });

      try {
        // Fetch the receiver's user ID from the chat participants
        final chatData = await chatRef.get();
        final participants = chatData.data()?['participants'] as List<dynamic>?;
        final receiverId = participants?.firstWhere((id) => id != senderId,
            orElse: () => null);

        if (receiverId != null) {
          // Fetch the receiver's FCM token using their user ID
          final receiverSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(receiverId)
              .get();
          final fcmToken = receiverSnapshot.data()?['fcmToken'];
          print('Receiver FCM token: $fcmToken');

          if (fcmToken != null) {
            await sendNotifications(
              fcmToken,
              'New Message from ${FirebaseAuth.instance.currentUser!.displayName}',
              message,
            );
          } else {
            print('Receiver FCM token not found.');
          }
        } else {
          print('Receiver ID not found in participants.');
        }
      } catch (e) {
        print('Error fetching receiver token: $e');
      }
      _messageController.clear();
    }
  }

  Future<void> sendNotification(
      String fcmToken, String title, String body) async {
    // Obtain a service account JSON key from Firebase Console
    const projectId =
        "karta-chat-app"; // Replace with your Firebase project ID.
    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

    final header = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ya29.a0ARW5m76WBqSVk1KtbSjFNTzqonbpt22NoUqx6RCn_kU4oMhrTJzdblfzipybsayTeuSvE3nVQLryDGvihLnEYRjfXrbyxl5hs9Nf367BQqg71QXQfzgFhmZfTjDPber4JAjF7dlRZPqCJFFTZ4SAxhzJPiUbuBaIMpTgTzs4aCgYKASoSARESFQHGX2MiBDWuouuYpdw9rw3yfRZDyQ0175',
      // Replace this with a valid OAuth token.
    };

    final bodyData = {
      'message': {
        'token': fcmToken,
        'notification': {
          'title': title,
          'body': body,
        },
      },
    };

    try {
      final response = await http.post(
        url,
        headers: header,
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully.');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> sendNotifications(
      String fcmToken, String title, String body) async {
    const projectId =
        "karta-chat-app"; // Replace with your Firebase project ID.
    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');
    // Path to your Firebase service account JSON key file
    const serviceAccountPath =
        '../assets/images/karta-chat-app-ae2d6c8cbcce.json';
    // Load the service account key file
    final serviceAccountJson = jsonDecode(
      await rootBundle
          .loadString('assets/images/karta-chat-app-ae2d6c8cbcce.json'),
    );

    final clientEmail = serviceAccountJson['client_email'];
    final privateKey = serviceAccountJson['private_key'];
    // Obtain a Bearer token
    final credentials = ServiceAccountCredentials(
      clientEmail,
      ClientId('', ''), // Leave empty for service accounts
      privateKey,
    );

    final client = await clientViaServiceAccount(
        credentials, ['https://www.googleapis.com/auth/cloud-platform']);
    final token = await client.credentials.accessToken;

    // Create the Authorization header with the dynamic Bearer token
    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token.data}',
    };

    // Notification payload
    final bodyData = {
      'message': {
        'token': fcmToken,
        'notification': {
          'title': title,
          'body': body,
        },
      },
    };

    try {
      final response = await http.post(
        url,
        headers: header,
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully.');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.receiverName,
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _joinChannel,
                child: const Text('Start Call'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _leaveChannel,
                child: const Text('End Call'),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMine = message['senderId'] == senderId;
                    // Convert Firestore timestamp to a readable format.
                    final timeStamp = message['timestamp'] != null
                        ? (message['timestamp'] as Timestamp).toDate()
                        : DateTime.now();

                    final formattedTime =
                        DateFormat('hh:mm a').format(timeStamp);

                    return Column(
                      children: [
                        Align(
                          alignment: isMine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMine ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message['text'],
                              style: TextStyle(
                                color: isMine ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

void _initializeAgora() async {
  _engine = createAgoraRtcEngine();
  await _engine.initialize(
    const RtcEngineContext(
      appId: '97e9b1a28f014124aff6043a017391ee', // Replace with your actual Agora App ID
    ),
  );

  await _engine.enableVideo();

  _engine.registerEventHandler(
    RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print('Local user ${connection.localUid} joined');
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        print('Remote user $remoteUid joined');
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        print('Remote user $remoteUid left the call');
      },
    ),
  );
}

  

  Future<void> _joinChannel() async {
    await _engine.joinChannel(token: token,channelId: "testChannel",uid: 0,
    options:ChannelMediaOptions());

  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
  }
}
