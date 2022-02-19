import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maintenance/utils/app_localization.dart';

class RequestServiceDetails extends StatelessWidget {

  Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("Request Service Details")),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(AppLocalization.of(context).translate("User name: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                SizedBox(width: 10),
                Text("title", style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(AppLocalization.of(context).translate("Phone: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                SizedBox(width: 10),
                Text("+966", style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(AppLocalization.of(context).translate("Title: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                SizedBox(width: 10),
                Text("title", style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(AppLocalization.of(context).translate("Service: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                SizedBox(width: 10),
                Text("service", style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(AppLocalization.of(context).translate("Date: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                SizedBox(width: 10),
                Text("20/12/2020", style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(AppLocalization.of(context).translate("Details: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                SizedBox(width: 10),
                Flexible(child: Text("Details Details Details Details Details Details Details", style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(AppLocalization.of(context).translate("Location:- "), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),),
              ],
            ),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * (300 / 812),
              child: GoogleMap(
                markers: Set<Marker>.of([Marker(markerId: MarkerId('mark'), position: LatLng(31, 331))]),
                initialCameraPosition: CameraPosition(
                  target: LatLng(31, 31),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}