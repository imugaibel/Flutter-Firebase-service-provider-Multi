import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/screen/select-location.dart';
import 'package:maintenance/styles/input_style.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/custom_button.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/widgets/loader.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _locationController = TextEditingController();

  File _imagePerson;
  String name;
  String city;
  String phone;
  double lat = -1;
  double lng = -1;
  bool isGetData = false;


  @override
  void dispose() {
    // TODO: implement dispose
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("Edit Profile")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FutureBuilder<UserModel>(
            future: UserProfile.shared.getUser(),
            builder: (context, snapshot) {

              if (snapshot.hasData) {

                UserModel user = snapshot.data;

                lat = user.lat;
                lng = user.lng;

                if (!isGetData && lng != -1) {
                  _locationController.text = "${user.lat}, ${user.lng}";
                  isGetData = true;
                }

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            child: _imagePerson != null
                                ? Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(_imagePerson),
                                      fit: BoxFit.cover)),
                            )
                                : user.image.isURL() ? Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(user.image),
                                      fit: BoxFit.cover)),
                            ) : Icon(
                              Icons.person,
                              size: 52,
                              color: Theme.of(context).accentColor,
                            ),
                            radius: 50,
                            backgroundColor: Color(0xFFF0F4F8),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => _selectImgDialog(context),
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                                radius: 15,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * (100 / 812)),
                      TextFormField(
                        initialValue: user.name,
                        onSaved: (value) => name = value.trim(),
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).accentColor,
                        ),
                        decoration: customInputForm.copyWith(prefixIcon: Icon(
                          Icons.person_outline,
                          color: Theme.of(context).accentColor,
                        ),
                        ).copyWith(hintText: AppLocalization.of(context).translate("Name")),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        initialValue: user.city,
                        onSaved: (value) => city = value.trim(),
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).accentColor,
                        ),
                        decoration: customInputForm.copyWith(prefixIcon: Icon(
                          Icons.location_city_outlined,
                          color: Theme.of(context).accentColor,
                        ),
                        ).copyWith(hintText: AppLocalization.of(context).translate("City")),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        initialValue: user.phone,
                        onSaved: (value) => phone = value.trim(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).accentColor,
                        ),
                        decoration: customInputForm.copyWith(prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: Theme.of(context).accentColor,
                        ),
                        ).copyWith(hintText: AppLocalization.of(context).translate("Phone Number")),
                      ),
                      FutureBuilder<UserModel>(
                        future: UserProfile.shared.getUser(),
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: snapshot.hasData ? snapshot.data.userType == UserType.TECHNICIAN : false ,
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _locationController,
                                  onTap: () => _openMap(context),
                                  readOnly: true,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  decoration: customInputForm.copyWith(prefixIcon: Icon(
                                    Icons.map_outlined,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  ).copyWith(hintText: AppLocalization.of(context).translate("Location")),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * (100 / 812)),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * ( 55 / 812 ),
                        child: customButton(context, title: AppLocalization.of(context).translate("Edit Profile"), onPressed: () => _btnEdit(imgURL: user.image)),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                );
              } else {
                return Center(child: loader(context));
              }

            }
          ),
        ),
      ),
    );
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
                    title: Text(AppLocalization.of(context).translate('Image form camera')),
                    onTap: () => _selectImage(type: ImageSource.camera)
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text(AppLocalization.of(context).translate('Image from gallery')),
                  onTap: () => _selectImage(type: ImageSource.gallery),
                ),
              ],
            ),
          );
        }
    );
  }

  _selectImage({ @required ImageSource type }) async {
    PickedFile image = await ImagePicker.platform.pickImage(
        source: type);
    setState(() {
      _imagePerson = File(image.path);
    });

    Navigator.of(context).pop();
  }

  bool _validation() {
    return !(name == "" || city == "" || phone == "");
  }

  _btnEdit({ @required String imgURL }) {
    _formKey.currentState.save();

    String image = "";

    if (_imagePerson != null) {
      image = _imagePerson.path;
    } else {
      image = imgURL;
    }

    if (_validation()) {
      FirebaseManager.shared.updateAccount(scaffoldKey: _scaffoldKey, image: image, name: name, city: city, phoneNumber: phone, location: _locationController.text);
    } else {
      _scaffoldKey.showTosta(message: AppLocalization.of(context).translate("Please fill in all fields"), isError: true);
    }

  }

  _openMap(context) async {
    LatLng selectedPosition;

    var tempLatLng = _locationController.text.split(", ");

    if (tempLatLng.length == 2) {
      selectedPosition =
          LatLng(double.parse(tempLatLng.first), double.parse(tempLatLng.last));
    }

    LatLng position = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => SelectLocation(
          position: selectedPosition,
        )));
    _locationController.text = "${position.latitude}, ${position.longitude}";
    lat = position.latitude;
    lng = position.longitude;
  }

}
