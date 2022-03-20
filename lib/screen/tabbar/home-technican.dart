import 'package:flutter/material.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/widgets/notifications.dart';
import 'package:maintenance/widgets/slider-home.dart';


class HomeTechnican extends StatefulWidget {
  const HomeTechnican({Key? key}) : super(key: key);

  @override
  _HomeTechnicanState createState() => _HomeTechnicanState();
}

class _HomeTechnicanState extends State<HomeTechnican> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context)!.translate('Home')),
          centerTitle: true,
          actions: const [
            NotificationsWidget(),
          ],
        ),
        body: const SliderHome());
  }
}
