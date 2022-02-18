import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:omni/screen/about-us.dart';
import 'package:omni/screen/appointment-booking.dart';
import 'package:omni/screen/contact-us.dart';
import 'package:omni/screen/edit-password.dart';
import 'package:omni/screen/edit-profile.dart';
import 'package:omni/screen/forgot_password.dart';
import 'package:omni/screen/notification.dart';
import 'package:omni/screen/order-details.dart';
import 'package:omni/screen/orders.dart';
import 'package:omni/screen/privacy-terms.dart';
import 'package:omni/screen/request-service-details.dart';
import 'package:omni/screen/select-location.dart';
import 'package:omni/screen/select_language.dart';
import 'package:omni/screen/service-details.dart';
import 'package:omni/screen/service-form.dart';
import 'package:omni/screen/signin.dart';
import 'package:omni/screen/signup.dart';
import 'package:omni/screen/splash.dart';
import 'package:omni/screen/tabbar/tabbar.dart';
import 'package:omni/screen/wallet.dart';
import 'package:omni/screen/wrapper.dart';
import 'package:omni/utils/app_localization.dart';
import 'package:omni/utils/assets.dart';
import 'package:omni/utils/extensions.dart';
import 'package:omni/widgets/choose-user-type.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((_) {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: false);
  });

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

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.subscribeToTopic("all");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              color: Colors.blue,
              playSound: true,
              icon: Assets.shared.icAccentLogo,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body)],
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
      title: "omni",
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: [
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
          if (local.languageCode == deviceLocale[0].languageCode) {
            return local;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        primaryColor: "#0093c9".toHexa(),
        accentColor: "#6c757d".toHexa(),
        backgroundColor: "#ffffff".toHexa(),
        fontFamily: 'NeoSansArabic',
      ),
      initialRoute: "/SignIn",
      onGenerateRoute: (settings) {
        final arguments = settings.arguments;
        switch (settings.name) {
          case '/Splash':
            return MaterialPageRoute(builder: (_) => Splash());
          case '/Wrapper':
            return MaterialPageRoute(builder: (_) => Wrapper());
          case '/SelectLanguage':
            return MaterialPageRoute(builder: (_) => SelectLanguage());
          case '/SignIn':
            return MaterialPageRoute(
                builder: (_) => SignIn(
                      message: arguments,
                    ));
          case '/SignUp':
            return MaterialPageRoute(builder: (_) => Signup());
          case '/ForgotPassword':
            return MaterialPageRoute(builder: (_) => ForgotPassword());
          case '/Tabbar':
            return MaterialPageRoute(
                builder: (_) => TabBarPage(
                      userType: arguments,
                    ));
          case '/ChooseUserType':
            return MaterialPageRoute(builder: (_) => ChooseUserType());
          case '/ServiceDetails':
            return MaterialPageRoute(
                builder: (_) => ServiceDetails(
                      udidService: arguments,
                    ));
          case '/AppointmentBooking':
            return MaterialPageRoute(
                builder: (_) => AppointmentBooking(
                      uidActiveService: arguments,
                    ));
          case '/SelectLocation':
            return MaterialPageRoute(builder: (_) => SelectLocation());
          case '/ServiceForm':
            return MaterialPageRoute(
                builder: (_) => ServiceForm(
                      uidService: arguments,
                    ));
          case '/RequestServiceDetails':
            return MaterialPageRoute(builder: (_) => RequestServiceDetails());
          case '/AboutUs':
            return MaterialPageRoute(builder: (_) => AboutUs());
          case '/EditProfile':
            return MaterialPageRoute(builder: (_) => EditProfile());
          case '/EditPassword':
            return MaterialPageRoute(builder: (_) => EditPassword());
          case '/PrivacyTerms':
            return MaterialPageRoute(builder: (_) => PrivacyTerms());
          case '/ContactUs':
            return MaterialPageRoute(builder: (_) => ContactUs());
          case '/OrderDetails':
            return MaterialPageRoute(
                builder: (_) => OrderDetails(
                      order: arguments,
                    ));
          case '/Notification':
            return MaterialPageRoute(builder: (_) => Notifications());
          case '/Wallet':
            return MaterialPageRoute(builder: (_) => Wallet());
          case '/Orders':
            return MaterialPageRoute(builder: (_) => Orders());
          default:
            return null;
        }
      },
    );
  }
}
