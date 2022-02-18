import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omni/enums/language.dart';
import 'package:omni/enums/user-type.dart';
import 'package:omni/model/service-model.dart';
import 'package:omni/model/user-model.dart';
import 'package:omni/utils/app_localization.dart';
import 'package:omni/utils/firebase-manager.dart';
import 'package:omni/utils/user_profile.dart';
import 'package:omni/widgets/btn-main.dart';
import 'package:omni/widgets/loader.dart';

class ServiceDetails extends StatefulWidget {

  final String udidService;

  const ServiceDetails({Key key, this.udidService}) : super(key: key);

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {

  Language lang = Language.ENGLISH;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: UserProfile.shared.getUser(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserModel user = snapshot.data;

          return Scaffold(
            body: StreamBuilder<ServiceModel>(
              stream: FirebaseManager.shared.getServiceById(id: widget.udidService),
              builder: (context, snapshot) {

                if (snapshot.hasData) {

                  ServiceModel service = snapshot.data;

                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          tooltip: AppLocalization.of(context).translate("Back"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        actions: [
                          Visibility(visible: user.userType == UserType.TECHNICIAN, child: IconButton(icon: Icon(Icons.edit, color: Colors.white,), tooltip: AppLocalization.of(context).translate("Edit Service"), onPressed: () => Navigator.of(context).pushNamed("/ServiceForm", arguments: widget.udidService))),
                        ],
                        expandedHeight: MediaQuery.of(context).size.height * (350 / 812),
                        floating: true,
                        pinned: true,
                        snap: true,
                        elevation: 5,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(lang == Language.ARABIC ? service.titleAR : service.titleEN,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
                          background: _renderSlider(context, images: service.images),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalization.of(context).translate("Info:-"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22, fontWeight: FontWeight.w500),),
                                SizedBox(height: 10),
                                Text(lang == Language.ARABIC ? service.detailsAR : service.detailsAR, style: TextStyle(color: Colors.blueGrey, fontSize: 18, height: 1.8,),),
                                SizedBox(height: 35),
                                Visibility(visible: user.userType == UserType.USER, child: BtnMain(title: AppLocalization.of(context).translate("Order Service"), onTap: () => Navigator.of(context).pushNamed("/AppointmentBooking", arguments: widget.udidService))),
                              ],
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
            ),
          );
        }

        return SizedBox();
      }
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
      items: images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
