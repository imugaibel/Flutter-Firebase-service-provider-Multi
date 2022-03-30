import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';

import 'package:maintenance/invoice/api/save_file_mobile.dart'
if (dart.library.html) 'package:maintenance/invoice/api/save_file_web.dart';

import '../invoice/api/pdf_invoice_api.dart';
import '../invoice/model/customer.dart';
import '../invoice/model/invoice.dart';
import '../invoice/model/supplier.dart';
import '../invoice/widget/button_widget.dart';
import '../model/order-model.dart';


class OrderDetails extends StatefulWidget {

  final  order;

  const OrderDetails({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    Language lang = Language.ENGLISH;

//    Completer<GoogleMapController> _mapController = Completer();

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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalization.of(context)!.translate("Service: "),
                    style: TextStyle(
                        fontSize: 18, color: Theme
                        .of(context)
                        .primaryColor),
                  ),
                  SizedBox(width: 10),
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
                                color: Theme
                                    .of(context)
                                    .accentColor));
                      }),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    AppLocalization.of(context)!.translate("Date: "),
                    style: TextStyle(
                        fontSize: 18, color: Theme
                        .of(context)
                        .primaryColor),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.order.createdDate,
                    style: TextStyle(
                        fontSize: 16, color: Theme
                        .of(context)
                        .accentColor),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    AppLocalization.of(context)!.translate("Details: "),
                    style: TextStyle(
                        fontSize: 18, color: Theme
                        .of(context)
                        .primaryColor),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                      child: Text(
                        widget.order.details,
                        style: TextStyle(
                            fontSize: 16, color: Theme
                            .of(context)
                            .accentColor),
                      )),
                ],
              ),
              SizedBox(height: 15),
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
//                               color: Theme
//                                   .of(context)
//                                   .primaryColor,
//                               fontSize: 18),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 15),
//                     Container(
//                       width: double.infinity,
//                       height: MediaQuery
//                           .of(context)
//                           .size
//                           .height * (300 / 812),
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
              SizedBox(height: 15),
//              QrImage(
//                 data: widget.order.serviceId,
//                 foregroundColor: Theme
//                     .of(context)
//                     .colorScheme
//                     .secondary,
//                 padding: EdgeInsets.zero,
//               ),
//              Visibility(
//                 visible: widget.order.lng != 0,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           AppLocalization.of(context)!.translate("Location:- "),
//                           style: TextStyle(
//                               color: Theme
//                                   .of(context)
//                                   .primaryColor,
//                               fontSize: 18),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 15),
//                     Container(
//                       width: double.infinity,
//                       height: MediaQuery
//                           .of(context)
//                           .size
//                           .height * (300 / 812),
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(15)),
//                       ),
//                       child: GoogleMap(
//                         markers: Set<Marker>.of([
//                           Marker(
//                               markerId: MarkerId('mark'),
//                               position:
//                               LatLng(widget.order.lat, widget.order.lng))
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
//                     SizedBox(height: 30),
//                   ],
//                 ),
//               ),
              const SizedBox(height: 48),
              ButtonWidget(
                text: 'Invoice',
                onClicked: () async {
                  final date = DateTime.now();
                  final dueDate = date.add(Duration(days: 7));

                  final invoice = Invoice(
                    supplier: const Supplier(
                      name: 'Sarah Field',
                      address: 'Sarah Street 9, Beijing, China',
                      paymentInfo: 'https://paypal.me/sarahfieldzz',
                    ),
                    customer: const Customer(
                      name: 'Apple Inc.',
                      address: 'Apple Street, Cupertino, CA 95014',
                    ),
                    info: InvoiceInfo(
                      date: date,
                      dueDate: dueDate,
                      description: 'My description...',
                      number: '${DateTime.now().year}-9999',
                    ),
                    items: [
                      InvoiceItem(
                        description: 'Coffee',
                        date: DateTime.now(),
                        quantity: 1,
                        vat: 0.19,
                        unitPrice: 5.99,
                      ),
                    ],
                  );

                  final pdfFile = await PdfInvoiceApi.generate(invoice);

                  PdfApi.openFile(pdfFile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}