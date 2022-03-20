import 'package:flutter/material.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/widgets/notifications.dart';
import 'package:maintenance/widgets/slider-home.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context)!.translate("Home")),
        centerTitle: true,
        actions: const [
          NotificationsWidget(),
        ],
      ),
      body:
          const SliderHome()
    );
  }
}
