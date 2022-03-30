import 'package:flutter/material.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/styles/input_style.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/assets.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/widgets/custom_button.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/widgets/alert_sheet.dart';



class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _userTypeController = TextEditingController();

  late String username;
  late String email;
  late String password;
  late String city;
  late String phoneNumber;
  late UserType userType;
  bool agreeToPrivacy = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _userTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * (60 / 812)),
                      Image.asset(Assets.shared.icLogo, fit: BoxFit.cover, height: MediaQuery.of(context).size.height * (250 / 812),),
                      const SizedBox(height: 50,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onSaved: (value) => username = value!.trim(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.translate("User name")),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onSaved: (value) => email = value!.trim(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.translate("Email")),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onSaved: (value) => password = value!.trim(),
                              textInputAction: TextInputAction.next,
                              obscureText: true,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.translate("Password")),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onSaved: (value) => city = value!.trim(),
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.location_city_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.translate("City")),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onSaved: (value) => phoneNumber = value!.trim(),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.phone_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.translate("Phone Number")),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              controller: _userTypeController,
                              onTap: () {
                                alertSheet(context, title: "User type", items: ["TECHNICIAN", "USER"], onTap: (value) {
                                  _userTypeController.text = value;
                                  if (value == "TECHNICIAN") {
                                    userType = UserType.TECHNICIAN;
                                  } else {
                                    userType = UserType.USER;
                                  }
                                  return;
                                });
                              },
                              readOnly: true,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: "User type"),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              children: [
                                Checkbox(value: agreeToPrivacy, activeColor: Theme.of(context).primaryColor, onChanged: (value) => {
                                  setState(() {
                                    agreeToPrivacy = value!;
                                  })
                                }),
                                const Text("agree to the ", style: TextStyle(fontSize: 16),),
                                InkWell(onTap: () {
                                  Navigator.of(context).pushNamed("/PrivacyTerms");
                                }, child: Text("terms of privacy", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, decoration: TextDecoration.underline,),)),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * ( 55 / 812 ),
                              child: customButton(context, title: AppLocalization.of(context)!.translate("Sign Up"), onPressed: _btnSignup),
                            ),
                            const SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  bool validation() {
    return !(username.isEmpty || email.isEmpty || password.isEmpty || city.isEmpty || phoneNumber.isEmpty);
  }

  _btnSignup() {

    _formKey.currentState!.save();

    if (!validation()) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.translate("Please fill in all fields"), isError: true);
      return;
    }

    if (!agreeToPrivacy) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.translate("Please agree to the privacy terms"), isError: true);
      return;
    }

    FirebaseManager.shared.createAccountUser(scaffoldKey: _scaffoldKey, imagePath: "", name: username, phone: phoneNumber, email: email, city: city, password: password, userType: userType);

  }

}