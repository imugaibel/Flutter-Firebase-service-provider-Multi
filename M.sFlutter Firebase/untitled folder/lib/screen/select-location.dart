import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omni/utils/app_localization.dart';
import 'package:omni/widgets/btn-main.dart';
import 'package:omni/utils/extensions.dart';

class SelectLocation extends StatefulWidget {

  final LatLng position;

  const SelectLocation({Key key, this.position}) : super(key: key);

  @override
  State<SelectLocation> createState() => SelectLocationState();
}

class SelectLocationState extends State<SelectLocation> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex;

  List<Marker> _markers = [];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kGooglePlex = CameraPosition(
      target: widget.position != null ? LatLng(widget.position.latitude, widget.position.longitude) : LatLng(24.774265, 46.738586),
      zoom: 10,
    );

    if (widget.position != null) {
      _markers = [Marker(markerId: MarkerId('mark'), position: widget.position)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("Select your location")),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onTap: (LatLng latLng) {
              _markers = [Marker(markerId: MarkerId('mark'), position: latLng)];
              setState(() {});
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: Set<Marker>.of(_markers),
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Align(
          alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              width: MediaQuery.of(context).size.width * (0.7),
              child: BtnMain(title: AppLocalization.of(context).translate("Select location"), onTap: () {

                if (_markers.length == 0) {
                  _scaffoldKey.showTosta(message: AppLocalization.of(context).translate("Please, select the location"), isError: true);
                  return;
                }

                Navigator.of(context).pop(_markers.first.position);
              },),
            ),
          ),
        ],
      ),
    );
  }

}
