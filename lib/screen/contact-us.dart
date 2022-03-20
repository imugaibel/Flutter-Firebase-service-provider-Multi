import 'package:flutter/material.dart';
import 'package:maintenance/utils/app_localization.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context)!.translate("Contact Us")),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message, size: 150, color: Theme.of(context).primaryColor,),
            const SizedBox(height: 30),
            Text(AppLocalization.of(context)!.translate("You can contact us via through the following email:-"), style: TextStyle(color: Theme.of(context).accentColor, fontSize: 22, height: 1.8), textAlign: TextAlign.center,),
            const SizedBox(height: 30),
            Text("@omnii", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 26, height: 1.8), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
