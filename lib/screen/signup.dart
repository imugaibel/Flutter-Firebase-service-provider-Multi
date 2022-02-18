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
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userTypeController = TextEditingController();

  String username;
  String email;
  String password;
  String city;
  String phoneNumber;
  bool agreeToPrivacy = false;

  UserType userType;

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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
          Center(
          child: Container(
          constraints: BoxConstraints(
            maxWidth: 400,
          ),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * (60 / 812)),
                    Image.asset(Assets.shared.icLogo, fit: BoxFit.cover, height: MediaQuery.of(context).size.height * (250 / 812),),
                    // SizedBox(height: 20),
                    // Text("Sign Up", style: TextStyle(
                    //   color: Theme.of(context).primaryColor,
                    //   fontSize: 26,
                    //   fontWeight: FontWeight.bold,
                    // ),),
                    SizedBox(height: 50,),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            onSaved: (value) => username = value.trim(),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor,
                            ),
                            decoration: customInputForm.copyWith(prefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).accentColor,
                            ),
                            ).copyWith(hintText: AppLocalization.of(context).translate("User name")),
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            onSaved: (value) => email = value.trim(),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor,
                            ),
                            decoration: customInputForm.copyWith(prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Theme.of(context).accentColor,
                            ),
                            ).copyWith(hintText: AppLocalization.of(context).translate("Email")),
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            onSaved: (value) => password = value.trim(),
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor,
                            ),
                            decoration: customInputForm.copyWith(prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Theme.of(context).accentColor,
                            ),
                            ).copyWith(hintText: AppLocalization.of(context).translate("Password")),
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
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
                            onSaved: (value) => phoneNumber = value.trim(),
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
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _userTypeController,
                            onTap: () {
                              alertSheet(context, title: AppLocalization.of(context).translate("User type"), items: [AppLocalization.of(context).translate("User"), AppLocalization.of(context).translate("Technician"), AppLocalization.of(context).translate("Admin")], onTap: (value) {
                                _userTypeController.text = value;
                                if (value == AppLocalization.of(context).translate("admin")) {
                                  userType = UserType.ADMIN;
                                } else if (value == AppLocalization.of(context).translate("Technician")){
                                  userType = UserType.TECHNICIAN;
                                }else{
                                  userType = UserType.USER;
                                }
                                return;
                              });
                            },
                            readOnly: true,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor,
                            ),
                            decoration: customInputForm.copyWith(prefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).accentColor,
                            ),
                            ).copyWith(hintText: AppLocalization.of(context).translate("User type")),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Checkbox(value: agreeToPrivacy, activeColor: Theme.of(context).primaryColor, onChanged: (value) => {
                                setState(() {
                                  agreeToPrivacy = value;
                                })
                              }),
                              Text(AppLocalization.of(context).translate("agree to the "), style: TextStyle(fontSize: 16),),
                              InkWell(onTap: () {
                                Navigator.of(context).pushNamed("/PrivacyTerms");
                              }, child: Text(AppLocalization.of(context).translate("terms of privacy"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, decoration: TextDecoration.underline,),)),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * ( 55 / 812 ),
                            child: customButton(context, title: AppLocalization.of(context).translate("Sign Up"), onPressed: _btnSignup),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 20),
              // FlatButton(
              //     onPressed: () => Navigator.pushReplacementNamed(context, '/SignIn'),
              //     child: Text(
              //       "Sign In",
              //       style: TextStyle(
              //         color: Theme.of(context).accentColor,
              //         fontSize: 14,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     )
              // ),
          )],
          ),
        ),
      ),
    );
  }

  bool validation() {
    return !(username.isEmpty || email.isEmpty || password.isEmpty || city.isEmpty || phoneNumber.isEmpty || userType == null);
  }

  _btnSignup() {

    _formKey.currentState.save();

    if (!validation()) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context).translate("Please fill in all fields"), isError: true);
      return;
    }

    if (!agreeToPrivacy) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context).translate("Please agree to the privacy terms"), isError: true);
      return;
    }

    FirebaseManager.shared.createAccountUser(scaffoldKey: _scaffoldKey, imagePath: "", name: username, phone: phoneNumber, email: email, city: city, password: password, userType: userType);

  }

}