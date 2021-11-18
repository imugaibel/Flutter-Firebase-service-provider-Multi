import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maintenance/screen/about-us.dart';
import 'package:maintenance/screen/orders.dart';
import 'package:maintenance/screen/appointment-booking.dart';
import 'package:maintenance/screen/contact-us.dart';
import 'package:maintenance/screen/edit-password.dart';
import 'package:maintenance/screen/edit-profile.dart';
import 'package:maintenance/screen/forgot_password.dart';
import 'package:maintenance/screen/notification.dart';
import 'package:maintenance/screen/order-details.dart';
import 'package:maintenance/screen/privacy-terms.dart';
import 'package:maintenance/screen/request-service-details.dart';
import 'package:maintenance/screen/select-location.dart';
import 'package:maintenance/screen/select_language.dart';
import 'package:maintenance/screen/service-details.dart';
import 'package:maintenance/screen/signin.dart';
import 'package:maintenance/screen/signup.dart';
import 'package:maintenance/screen/splash.dart';
import 'package:maintenance/screen/tabbar/tabbar.dart';
import 'package:maintenance/screen/wallet.dart';
import 'package:maintenance/screen/wrapper.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/widgets/choose-user-type.dart';
import 'package:maintenance/screen/service-form.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
      title: "Ms",
      debugShowCheckedModeBanner: false,
      locale:_locale,
      supportedLocales: [
        Locale("ar"),
        Locale("en", "US"),

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
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        primaryColor:  Colors.blue,
        accentColor: Colors.blue,
        backgroundColor: Colors.white,
        fontFamily: 'NeoSansArabic',
      ),
      initialRoute: "/Splash",
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
            return MaterialPageRoute(builder: (_) => SignIn(message: arguments,));
          case '/SignUp':
            return MaterialPageRoute(builder: (_) => Signup());
          case '/ForgotPassword':
            return MaterialPageRoute(builder: (_) => ForgotPassword());
          case '/Tabbar':
            return MaterialPageRoute(builder: (_) => TabBarPage(userType: arguments,));
          case '/ChooseUserType':
            return MaterialPageRoute(builder: (_) => ChooseUserType());
          case '/ServiceDetails':
            return MaterialPageRoute(builder: (_) => ServiceDetails(udidService: arguments,));
          case '/AppointmentBooking':
            return MaterialPageRoute(builder: (_) => AppointmentBooking(uidActiveService: arguments,));
          case '/SelectLocation':
            return MaterialPageRoute(builder: (_) => SelectLocation());
          case '/ServiceForm':
            return MaterialPageRoute(builder: (_) => ServiceForm(uidService: arguments,));
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
            return MaterialPageRoute(builder: (_) => OrderDetails(order: arguments,));
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