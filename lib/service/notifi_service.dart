// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:english_learn/bottom_bar_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:grock/grock.dart';

import '../firebase_options.dart';

var token;

class FirebaseNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  void settingNotification() async {
    await messaging.requestPermission(alert: true, sound: true, badge: true);
  }

  void connectNotification() async {
    settingNotification();
    await Firebase.initializeApp(
        name: 'vocopus', options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Grock.to(const BottomBarPage());
    });

    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message != null) {
          AndroidNotification? androidNotification =
              message.notification?.android;
          if (androidNotification != null) {
            print(message);

            Grock.snackBar(

                // leading: Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(8),
                //     child: Image.asset(
                //       "assets/image/sefkatkoprusuicon.png",
                //       width: 30,
                //       height: 30,
                //       fit: BoxFit.fill,
                //     ),
                //   ),
                // ),
                title: "${message.notification?.title}",
                description: "${message.notification?.body}");
          }
          // NotificationHelper.showNotification(
          //   message.notification!.title!,
          //   message.notification!.body!,
          // );
          // Uygulama arkaplandayken gelen bildirim
          // Burada gelen bildirimi işleyebilirsiniz
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AndroidNotification? androidNotification = message.notification?.android;
      if (androidNotification != null) {}
      // NotificationHelper.showNotification(
      //   message.notification!.title!,
      //   message.notification!.body!,
      // );
      print(message.notification?.title.toString());
      Grock.snackBar(
          title: "${message.notification?.title}",
          description: "${message.notification?.body}");

      // Uygulama ön plandayken gelen bildirim
      // Burada gelen bildirimi işleyebilirsiniz
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Uygulama arkaplanda çalışırken bildirime tıklanması durumunda
      // Burada gelen bildirimi işleyebilirsiniz
      AndroidNotification? androidNotification = message.notification?.android;
      if (androidNotification != null) {}
      // NotificationHelper.showNotification(
      //   message.notification!.title!,
      //   message.notification!.body!,
      // );
      print(message);

      Grock.snackBar(
          title: "${message.notification?.title}",
          description: "${message.notification?.body}");
    });

    // messaging = FirebaseMessaging.instance;
    // messaging.setForegroundNotificationPresentationOptions(
    //     alert: true, sound: true, badge: true);
    // settingNotification();
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print(event.notification?.title);
    //   Grock.snackBar(
    //       leading: const Padding(
    //         padding: EdgeInsets.all(8.0),
    //         child: Icon(
    //           Icons.message_outlined,
    //           color: Colors.grey,
    //         ),
    //       ),
    //       title: "${event.notification?.title}",
    //       description: "${event.notification?.body}");
    // });
    FirebaseMessaging.instance.getToken().then((value) async {
      token = value;
      // String? savedToken = await TokenService().getToken();
      // if (savedToken == null && savedToken != value) {
      //   await TokenService().saveToken(token);

      //   tokenService(value);
      //   print(value);
      // }

      print("Token bu $value");
    });
  }

  // static Future<void> backgroundMessage(RemoteMessage event) async {
  //   await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform);
  //   Grock.snackBar(
  //       leading: const Padding(
  //         padding: EdgeInsets.all(8.0),
  //         child: Icon(
  //           Icons.message_outlined,
  //           color: Colors.grey,
  //         ),
  //       ),
  //       title: "${event.notification?.title}",
  //       description: "${event.notification?.body}");
  //   print("bg Message${event.messageId}");
  // }
}

// class NotificationHelper {
//   static Future<void> showNotification(String title, String body) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 1,
//         channelKey: 'basic_channel',
//         title: title,
//         body: body,
//       ),
//     );
//   }
// }


