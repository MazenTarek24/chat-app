
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/utils/agora.dart';
import 'features/chat_screen/presentation/ui/ChatScreen.dart';
import 'features/home_screen/presentation/ui/HomeScreen.dart';
import 'features/login/presentaion/ui/LoginScreen.dart';
import 'features/notification/setup_notification.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
}

final flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupNotifications();
  await AgoraService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Function to generate the chat ID
  String _getChatId(String user1, String user2) {
    return user1.compareTo(user2) < 0 ? '${user1}_$user2' : '${user2}_$user1';
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(300, 600),
      child: MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/users': (context) => const UserListScreen(),
          '/chat': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map?;
            if (args == null ||
                args['chatId'] == null ||
                args['name'] == null) {
              return const Scaffold(
                body: Center(child: Text("Invalid chat arguments")),
              );
            }
            // final currentUserId = FirebaseAuth.instance.currentUser!.uid;
            // final receiverId = args['uid'];
            final receiverName = args['name'];
            // final chatId = _getChatId(currentUserId, receiverId);
            final chatId = args['chatId'];

            return ChatScreen(chatId: chatId, receiverName: receiverName);
          },
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

