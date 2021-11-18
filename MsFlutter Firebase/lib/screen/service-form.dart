import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/widgets/alert.dart';
import 'package:maintenance/widgets/btn-main.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/widgets/loader.dart';

class ServiceForm extends StatefulWidget {

  final String uidService;

  const ServiceForm({Key key, this.uidService}) : super(key: key);

  @override
  _ServiceFormState createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();

  List<String> _images = [];
  String titleEN = "";
  String detailsEN = "";
  String titleAR = "";
  String detailsAR = "";
  bool isGetData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: (widget.uidService == null || widget.uidService == "") ? _formAdd() : _formEdit()
    );
  }

  _renderSlider(context, { @required List<String> images }) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * (380 / 812),
        enableInfiniteScroll: false,
        autoPlay: true,
        viewportFraction: 1,
      ),
      items: [...images, "empty"].map((item) {
        return Builder(
          builder: (BuildContext context) {
            return item == "empty" ? _addImage(context) : InkWell(
              onTap: () {
                showAlertDialog(context, title: AppLocalization.of(context).translate("Delete Image"), message: AppLocalization.of(context).translate("Are you sure to delete the image?"), titleBtnOne: "Delete", titleBtnTwo: "Close", actionBtnOne: () {
                  _deleteImage(item);
                  Navigator.of(context).pop();
                }, actionBtnTwo: () {
                  Navigator.of(context).pop();
                });
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                      image: item.isURL() ? NetworkImage(item) : FileImage(File(item)),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _addImage(context) {
    return InkWell(
      onTap: () => _getImage(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: Center(
          child: Icon(Icons.add, size: 56, color: Theme.of(context).primaryColor,),
        ),
      ),
    );
  }

  _getImage(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor,),
                  title: Text(AppLocalization.of(context).translate('Camera'), style: TextStyle(color: Theme.of(context).primaryColor),),
                  onTap: () => _selectImage(imageSource: ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(Icons.image, color: Theme.of(context).primaryColor,),
                  title: Text(AppLocalization.of(context).translate('Gallery'), style: TextStyle(color: Theme.of(context).primaryColor),),
                  onTap: () => _selectImage(imageSource: ImageSource.gallery),
                ),
              ],
            ),
          );
        }
    );

  }

  _selectImage({@required ImageSource imageSource}) async {
    PickedFile image = await ImagePicker.platform.pickImage(
        source: imageSource);
    setState(() {
      _images.add(image.path);
    });

    Navigator.of(context).pop();
  }

  _deleteImage(String image) {
    setState(() {
      _images.remove(image);
    });
  }

  bool _validate() {
    return !(titleEN == "" || detailsEN == "" || titleAR == "" || detailsAR == "");
  }

  _btnSubmit({String uid = ""}) {

    if (_images.length == 0) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context).translate("Please enter photos of the service"), isError: true);
      return;
    }

    _formKey.currentState.save();

    if (!_validate()) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context).translate("Please fill all fields"), isError: true);
      return;
    }

    FirebaseManager.shared.addOrEditService(context, uid: uid, images: _images, titleEN: titleEN, detailsEN: detailsEN, titleAR: titleAR, detailsAR: detailsAR);
  }

  Widget _formAdd() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor,),
            tooltip: AppLocalization.of(context).translate("Back"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          expandedHeight: MediaQuery.of(context).size.height * (350 / 812),
          floating: true,
          pinned: true,
          snap: true,
          backgroundColor: Colors.transparent,
          elevation: 5,
          flexibleSpace: FlexibleSpaceBar(
            background: _renderSlider(context, images: _images),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      onSaved: (value) => titleEN = value.trim(),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: AppLocalization.of(context).translate("Title EN")
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      onSaved: (value) => titleAR = value.trim(),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: AppLocalization.of(context).translate("Title AR")
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      onSaved: (value) => detailsEN = value.trim(),
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: AppLocalization.of(context).translate("Info EN")
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (10 / 812)),
                    TextFormField(
                      onSaved: (value) => detailsAR = value.trim(),
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          labelText: AppLocalization.of(context).translate("Info AR")
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (90 / 812)),
                    BtnMain(title: widget.uidService == null ? AppLocalization.of(context).translate("Add Service") : AppLocalization.of(context).translate("Edit Service"), onTap: () => _btnSubmit(uid: widget.uidService)),
                  ],
                ),
              ),
            )
          ]),
        ),
      ],
    );
  }

  Widget _formEdit() {
    return StreamBuilder<ServiceModel>(
        stream: FirebaseManager.shared.getServiceById(id: widget.uidService),
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            ServiceModel service;

            if (!isGetData) {
              service = snapshot.data;
              _images = service.images;
              titleEN = service.titleEN;
              detailsEN = service.detailsEN;
              titleAR = service.titleAR;
              detailsAR = service.detailsAR;
              isGetData = true;
            }

            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor,),
                    tooltip: AppLocalization.of(context).translate("Back"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height * (350 / 812),
                  floating: true,
                  pinned: true,
                  snap: true,
                  backgroundColor: Colors.transparent,
                  elevation: 5,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _renderSlider(context, images: _images),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              onSaved: (value) => titleEN = value.trim(),
                              textInputAction: TextInputAction.next,
                              initialValue: titleEN,
                              decoration: InputDecoration(
                                  labelText: AppLocalization.of(context).translate("Title EN")
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              onSaved: (value) => titleAR = value.trim(),
                              textInputAction: TextInputAction.next,
                              initialValue: titleAR,
                              decoration: InputDecoration(
                                  labelText: AppLocalization.of(context).translate("Title AR")
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              onSaved: (value) => detailsEN = value.trim(),
                              maxLines: null,
                              initialValue: detailsEN,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  labelText: AppLocalization.of(context).translate("Info EN")
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              onSaved: (value) => detailsAR = value.trim(),
                              maxLines: null,
                              initialValue: detailsAR,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  labelText: AppLocalization.of(context).translate("Info AR")
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * (90 / 812)),
                            BtnMain(title: widget.uidService == null ? AppLocalization.of(context).translate("Add Service") : AppLocalization.of(context).translate("Edit Service"), onTap: () => _btnSubmit(uid: widget.uidService)),
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            );
          } else {
            return Center(child: loader(context));
          }
        }
    );
  }

}
