import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/widgets/btn-main.dart';
import 'package:maintenance/widgets/notifications.dart';
import 'package:maintenance/widgets/slider-home.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("Home")),
        centerTitle: true,
        actions: [
          NotificationsWidget(),
        ],
      ),
      body: Column(
        children: [
          SliderHome(),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(AppLocalization.of(context).translate("A professional team of specialists to fulfill your request"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, height: 1.8, fontWeight: FontWeight.w500,),),
                SizedBox(height: 35),
                BtnMain(title: AppLocalization.of(context).translate("Appointment Booking"), onTap: () => Navigator.of(context).pushNamed("/AppointmentBooking")),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
