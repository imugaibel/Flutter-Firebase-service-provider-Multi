
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/screen/show-pdf-file.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';

class OrderDetails extends StatefulWidget {
  final  order;

  const OrderDetails({Key? key, this.order}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    Language lang = Language.ENGLISH;

    Completer<GoogleMapController> _mapController = Completer();

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      UserProfile.shared.getLanguage().then((value) {
        if (value != null) {
          setState(() {
            lang = value;
          });
        }
      });
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context)!.translate("Order Details")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalization.of(context)!.translate("Service: "),
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(width: 10),
                  StreamBuilder<ServiceModel>(
                      stream: FirebaseManager.shared
                          .getServiceById(id: widget.order.serviceId),
                      builder: (context, snapshot) {
                        return Text(
                            snapshot.hasData
                                ? lang == Language.ARABIC
                                    ? snapshot.data!.titleAR
                                    : snapshot.data!.titleEN
                                : "",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).accentColor));
                      }),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                     AppLocalization.of(context)!.translate("Date: "),
                     style: TextStyle(
                         fontSize: 18, color: Theme.of(context).primaryColor),
                   ),
                   const SizedBox(width: 10),
                  Text(
                     widget.order.createdDate,
                     style: TextStyle(
                         fontSize: 16, color: Theme.of(context).accentColor),
                   ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    AppLocalization.of(context)!.translate("Details: "),
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                      child: Text(
                    widget.order.details,
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).accentColor),
                  )),
                ],
              ),
              const SizedBox(height: 15),
//              Visibility(
//                 visible: widget.order.urlImage != "",
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           AppLocalization.of(context)!
//                               .translate("The attached photo:-"),
//                           style: TextStyle(
//                               color: Theme.of(context).primaryColor,
//                               fontSize: 18),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 15),
//                     Container(
//                       width: double.infinity,
//                       height: MediaQuery.of(context).size.height * (300 / 812),
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(15)),
//                       ),
//                       child: Image.network(
//                         widget.order.urlImage,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              const SizedBox(height: 15),
//              Visibility(
//                 visible: widget.order.lng != 0,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           AppLocalization.of(context)!.translate("Location:- "),
//                           style: TextStyle(
//                               color: Theme.of(context).primaryColor,
//                               fontSize: 18),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 15),
//                     Container(
//                       width: double.infinity,
//                       height: MediaQuery.of(context).size.height * (300 / 812),
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(15)),
//                       ),
//                       child: GoogleMap(
//                         markers: Set<Marker>.of([
//                           Marker(
//                               markerId: MarkerId('mark'),
//                               position:
//                                   LatLng(widget.order.lat, widget.order.lng))
//                         ]),
//                         initialCameraPosition: CameraPosition(
//                           target: LatLng(widget.order.lat, widget.order.lng),
//                           zoom: 14.4746,
//                         ),
//                         onMapCreated: (GoogleMapController controller) {
//                           _mapController.complete(controller);
//                         },
//                       ),
//                     ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShowPDFFile()));
                      },
                      child: const Text("Show Pdf"),
                    )
                  ],
                ),
              ),
 //           ],
          ),
        );
 //     ),
 //   );
  }
}
