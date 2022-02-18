import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/widgets/btn-main.dart';


class EXPMODEL extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return Container(
    child: Column(
      children: [
        _renderSlider(context, images: ["https://firebasestorage.googleapis.com:443/v0/b/maintenance-7cfcc.appspot.com/o/ads%2F7bd53e4e-f5bb-43d4-8a77-6760618532af?alt=media&token=df3a2073-58b4-4103-84ec-54111a4c7ed2", "https://img.freepik.com/free-vector/promotion-sale-labels-best-offers_206725-127.jpg?size=626&ext=jpg", "https://image.freepik.com/free-vector/stickers-sales-discounts_1126-86.jpg"]),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 35),
              //AppointmentBooking
              BtnMain(title: "Login", onTap: () => Navigator.pushNamed(context, '/SignIn'),
              )],
          ),
        ),
      ],
    ),
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
