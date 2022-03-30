import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maintenance/screen/about-us.dart';
import 'package:maintenance/screen/appointment-booking.dart';
import 'package:maintenance/screen/contact-us.dart';
import 'package:maintenance/screen/edit-password.dart';
import 'package:maintenance/screen/edit-profile.dart';
import 'package:maintenance/screen/forgot_password.dart';
import 'package:maintenance/screen/notification.dart';
import 'package:maintenance/screen/order-details.dart';
import 'package:maintenance/screen/orders.dart';
import 'package:maintenance/screen/privacy-terms.dart';
import 'package:maintenance/screen/select-location.dart';
import 'package:maintenance/screen/service-details.dart';
import 'package:maintenance/screen/service-form.dart';
import 'package:maintenance/screen/signin.dart';
import 'package:maintenance/screen/signup.dart';
import 'package:maintenance/screen/splash.dart';
import 'package:maintenance/screen/tabbar/tabbar.dart';
import 'package:maintenance/screen/wallet.dart';
import 'package:maintenance/screen/wrapper.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/assets.dart';
import 'package:maintenance/utils/extensions.dart';

import 'manger/init.dart';
import 'manger/io_init.dart';



const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('A bg message just showed up :  ${message.messageId}');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsOnMobile || kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform).then((_) {
      FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);
    });}
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //  FirebaseMessaging.instance.subscribeToTopic("all");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              playSound: true,
              icon: Assets.shared.icAccentLogo,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title!),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body!)],
                ),
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "maintenance",
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale("en", "US"),
        Locale("ar"),
      ],
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeListResolutionCallback: (deviceLocale, supportedLocales) {
        for (var local in supportedLocales) {
          if (local.languageCode == deviceLocale![0].languageCode) {
            return local;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        primaryColor: "#0093c9".toHexa(),
        backgroundColor: "#ffffff".toHexa(),
        fontFamily: 'NeoSansArabic',
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: "#6c757d".toHexa()),
      ),
      initialRoute: "/Splash",
      onGenerateRoute: (settings) {
        final arguments = settings.arguments;
        switch (settings.name) {
          case '/Splash'://splash
            return MaterialPageRoute(builder: (_) => const Splash());
          case '/Wrapper':
            return MaterialPageRoute(builder: (_) => const Wrapper());
          case '/SignIn':
            return MaterialPageRoute(
                builder: (_) => SignIn(
                      message: arguments,
                    ));
          case '/SignUp':
            return MaterialPageRoute(builder: (_) => const Signup());
          case '/ForgotPassword':
            return MaterialPageRoute(builder: (_) => ForgotPassword());
          case '/Tabbar':
            return MaterialPageRoute(
                builder: (_) => TabBarPage(
                      userType: arguments,
                    ));
          case '/ServiceDetails':
            return MaterialPageRoute(
                builder: (_) => ServiceDetails(
                      udidService: arguments,
                    ));
          case '/AppointmentBooking':
            return MaterialPageRoute(
                builder: (_) =>  AppointmentBooking(
                      uidActiveService: arguments,
                    ));
//          case '/SelectLocation':
//             return MaterialPageRoute(builder: (_) => const SelectLocation());
          case '/ServiceForm':
            return MaterialPageRoute(
                builder: (_) => ServiceForm(
                      uidService: arguments,
                    ));
          case '/AboutUs':
            return MaterialPageRoute(builder: (_) => const AboutUs());
          case '/EditProfile':
            return MaterialPageRoute(builder: (_) => const EditProfile());
          case '/EditPassword':
            return MaterialPageRoute(builder: (_) => EditPassword());
          case '/PrivacyTerms':
            return MaterialPageRoute(builder: (_) => const PrivacyTerms());
          case '/ContactUs':
            return MaterialPageRoute(builder: (_) => const ContactUs());
          case '/OrderDetails':
            return MaterialPageRoute(
                builder: (_) => OrderDetails(
                      order: arguments,
                    ));
          case '/Notification':
            return MaterialPageRoute(builder: (_) => const Notifications());
          case '/Wallet':
            return MaterialPageRoute(builder: (_) => const Wallet());
          case '/Orders':
            return MaterialPageRoute(builder: (_) => const Orders());
          default:
            return null;
        }
      },
    );
  }
}
