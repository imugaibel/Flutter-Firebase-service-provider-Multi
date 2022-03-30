import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/screen/select-location.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/assets.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/btn-main.dart';
import 'package:maintenance/utils/extensions.dart';

class AppointmentBooking extends StatefulWidget {

  final  uidActiveService;

  const AppointmentBooking({Key? key, required this.uidActiveService}) : super(key: key);

  @override
  _AppointmentBookingState createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
 // TextEditingController _imageController = TextEditingController();
//  TextEditingController _locationController = TextEditingController();

  List<DropdownMenuItem<String>>? _dropdownMenuItem = [];
  String? _activeDropDownItem;
  String? details;
//   double? lat;
//    double? lng;
//   File? _image;
  Language lang = Language.ENGLISH;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getServiceData();
    UserProfile.shared.getLanguage().then((value) {
      if (value != null) {
        setState(() {
          lang = value;
        });
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
 //   _imageController.dispose();
 //   _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalization.of(context)!.translate("Appointment Booking")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 30,),
              SvgPicture.asset(Assets.shared.icOrderService, width: MediaQuery.of(context).size.width * 0.6,),
              SizedBox(height: MediaQuery.of(context).size.height * (60 / 812),),
              Form(
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      items: _dropdownMenuItem,
                      onChanged: (String? newValue) {
                        setState(() => _activeDropDownItem = newValue);
                      },
                      value: _activeDropDownItem,
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(context)!.translate("Service"),
                      ),
                    ),
                    SizedBox(height: 20),
//                    TextFormField(
//                       controller: _imageController,
//                       onTap: () => _selectImgDialog(context),
//                       readOnly: true,
//                       decoration: InputDecoration(
//                         labelText: AppLocalization.of(context)!.translate("Attach a Picture"),
//                       ),
//                     ),
//                     SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) => details = value.trim(),
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(context)!.translate("Details"),
                      ),
                    ),
                    SizedBox(height: 20),
//                    TextFormField(
//                       controller: _locationController,
//                       onTap: () => _openMap(context),
//                       readOnly: true,
//                       decoration: InputDecoration(
//                         labelText: AppLocalization.of(context)!.translate("Location"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * (80 / 812),),
              BtnMain(title: AppLocalization.of(context)!.translate("Order Service"), onTap: _submitData),
            ],
          ),
        ),
      ]),
    )));
  }

  _selectImgDialog(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text(AppLocalization.of(context)!.translate('Image form camera')),
                    onTap: () => _selectImage(type: ImageSource.camera)
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text(AppLocalization.of(context)!.translate('Image from gallery')),
                  onTap: () => _selectImage(type: ImageSource.gallery),
                ),
              ],
            ),
          );
        }
    );
  }

  _selectImage({ required ImageSource type }) async {
    PickedFile? image = await ImagePicker.platform.pickImage(
        source: type);
    setState(() {
//      _image = File(image!.path);
//      _imageController.text = AppLocalization.of(context)!.translate("photo attached");
    });

    Navigator.of(context).pop();
  }

//  _openMap(context) async {
//     LatLng? selectedPosition;
//
//     var tempLatLng = _locationController.text.split(", ");
//
//     if (tempLatLng.length == 2) {
//       selectedPosition =
//           LatLng(double.parse(tempLatLng.first), double.parse(tempLatLng.last));
//     }
//
//     LatLng position = await Navigator.of(context).push(MaterialPageRoute(
//         builder: (BuildContext context) => SelectLocation(
//               position: selectedPosition,
//             )));
//     _locationController.text = "${position.latitude}, ${position.longitude}";
//     lat = position.latitude;
//     lng = position.longitude;
//   }

  _getServiceData() async {

    List<ServiceModel> services = await FirebaseManager.shared.getServices(status: Status.ACTIVE).first;

    setState(() {
      _dropdownMenuItem = services.map((item) => DropdownMenuItem(child: Text( lang == Language.ARABIC ? item.titleAR : item.titleEN ), value: item.uid.toString())).toList();

      if (widget.uidActiveService != null) {
        _activeDropDownItem = widget.uidActiveService;
      }

    });

  }

  bool _validation() {
    return !(_activeDropDownItem == null || details == null || details == "");
  }

  _submitData() async {

    if (!_validation()) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.translate("Please fill in all fields"), isError: true);
      return;
    }

    ServiceModel item = await FirebaseManager.shared.getServiceById(id: _activeDropDownItem!).first;
//    FirebaseManager.shared.addOrEditOrder(context, ownerId: item.uidOwner, serviceId: _activeDropDownItem!,  details: details!, lat: lat!, image: _image!, lng: lng!);
    FirebaseManager.shared.addOrEditOrder(context, ownerId: item.uidOwner, serviceId: _activeDropDownItem!,  details: details!);

  }

}