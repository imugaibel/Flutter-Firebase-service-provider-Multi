import 'dart:io';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omni/enums/user-type.dart';
import 'package:omni/model/ads-model.dart';
import 'package:omni/model/user-model.dart';
import 'package:omni/utils/app_localization.dart';
import 'package:omni/utils/firebase-manager.dart';
import 'package:omni/utils/user_profile.dart';
import 'package:omni/widgets/loader.dart';
import 'alert.dart';

class SliderHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AdsModel>>(
        stream: FirebaseManager.shared.getAds(),
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            List<AdsModel> data = snapshot.data;

            List<String> images = [];

            for (var item in data) {
              images.add(item.image);
            }

            return FutureBuilder<UserModel>(
              future: UserProfile.shared.getUser(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {

                  return CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * (380 / 812),
                      enableInfiniteScroll: false,
                      autoPlay: true,
                      viewportFraction: 1,
                    ),
                    items: sliderCells(snapshot.data.userType, data),
                  );

                }

                return SizedBox();
              }
            );
          } else {
            return Center(child: loader(context));
          }

        }
    );
  }

  List<Widget> sliderCells(UserType userType, List<AdsModel> ads) {

    List<Widget> items = [];

    var itemsCount = userType == UserType.ADMIN ? ads.length : ads.length - 1;

    for (var i = 0; i <= itemsCount; i++) {
      if (i == ads.length && userType == UserType.ADMIN) {
        items.add(Builder(
          builder: (BuildContext context) {
            return _addImage(context);
          },
        ));
      } else {
        items.add(Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () {

                if (userType != UserType.ADMIN) {
                  return;
                }

                showAlertDialog(context, title: AppLocalization.of(context).translate("Delete Image"), message: AppLocalization.of(context).translate("Are you sure to delete the image?"), titleBtnOne: AppLocalization.of(context).translate("Delete"), titleBtnTwo: AppLocalization.of(context).translate("Close"), actionBtnOne: () {
                  _deleteImage(context, ads[i].uid);
                  Navigator.of(context).pop();
                }, actionBtnTwo: () {
                  Navigator.of(context).pop();
                });
              },
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                ),
                child: Image.network(ads[i].image, fit: BoxFit.cover,),
              ),
            );
          },
        ));
      }
    }

    return items;
  }

  Widget _addImage(context) {
    return InkWell(
      onTap: () => _getImage(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
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
                  onTap: () => _selectImage(context, imageSource: ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(Icons.image, color: Theme.of(context).primaryColor,),
                  title: Text(AppLocalization.of(context).translate('Gallery'), style: TextStyle(color: Theme.of(context).primaryColor),),
                  onTap: () => _selectImage(context, imageSource: ImageSource.gallery),
                ),
              ],
            ),
          );
        }
    );

  }

  _selectImage(context, {@required ImageSource imageSource}) async {
    PickedFile image = await ImagePicker.platform.pickImage(
        source: imageSource);

    Navigator.of(context).pop();

    FirebaseManager.shared.addAds(context, image: image.path);
  }

  _deleteImage(context, String idAds) {
    FirebaseManager.shared.deleteAds(context, idAds: idAds);
  }

}
