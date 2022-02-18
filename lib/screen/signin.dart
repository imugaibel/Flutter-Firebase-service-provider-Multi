/*import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/styles/input_style.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/assets.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/widgets/alert.dart';
import 'package:maintenance/widgets/custom_button.dart';
import 'package:maintenance/utils/extensions.dart';

class SignIn extends StatefulWidget {
  final String message;
  final UserType userType;
  const SignIn({Key key, this.message, this.userType}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();
  String email;
  String password;
  bool isShowPassword = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.message != null) {
      Future.delayed(Duration(seconds: 1), () {
        showAlertDialog(context, title: AppLocalization.of(context).translate("Done Successfully"), message: AppLocalization.of(context).translate(widget.message), showBtnOne: false, actionBtnTwo: () {
          Navigator.of(context).pop();
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(
              Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pushNamed(context, '/Front'),
        ),
        backgroundColor: Theme.of(context).canvasColor,
      elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
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
                  SizedBox(height: 50,),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          children: [
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
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context).translate("Email")),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              onSaved: (value) => password = value.trim(),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              obscureText: !isShowPassword,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).accentColor,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context).translate("Password"))
                                  .copyWith(suffixIcon: GestureDetector(
                                onTap: () => setState(() {
                                  isShowPassword = !isShowPassword;
                                }),
                                child: Container(padding: EdgeInsets.all(10), child: SvgPicture.asset(isShowPassword ? Assets.shared.icInvisible : Assets.shared.icVisibility, color: Theme.of(context).primaryColor, height: 5, width: 5,)),
                              )),
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlatButton(
                                  child: Text(
                                    AppLocalization.of(context).translate("Forgot Password?"),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onPressed: () => Navigator.pushNamed(context, '/ForgotPassword'),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * ( 55 / 812 ),
                              child: customButton(context, title: AppLocalization.of(context).translate("Sign In"), onPressed: _btnSignin),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: widget.userType != UserType.USER,
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(icon: SvgPicture.asset(Assets.shared.icGoogle, width: 50, height: 50,), tooltip: AppLocalization.of(context).translate("Sign in with Google"), onPressed: _btnSigninWithGoogle),
                                  ),
                                  Visibility(
                                    visible:(kIsWeb || Platform.isMacOS != Platform.isIOS),
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(icon: SvgPicture.asset(Assets.shared.icApple, width: 50, height: 50,), tooltip: AppLocalization.of(context).translate("Sign in with Apple"), onPressed: _btnSigninWithApple)
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 20),
                            FlatButton(
                                onPressed: () => Navigator.pushNamed(context, '/SignUp'),
                                child: Text(
                                  AppLocalization.of(context).translate("Create new account"),
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        )
          )
            ],
          ),
        ),
      ),
    );
  }

  bool _validation() {
    return !(email == "" || password == "");
  }

  _btnSignin() {

    _formKey.currentState.save();

    if (!_validation()) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context).translate("Please fill in all fields"), isError: true);
      return;
    }

    FirebaseManager.shared.login(scaffoldKey: _scaffoldKey, email: email, password: password);
  }

  _btnSigninWithGoogle() {
    FirebaseManager.shared.signInWithGoogle(scaffoldKey: _scaffoldKey, userType: widget.userType);
  }

  _btnSigninWithApple() {
     FirebaseManager.shared.signInWithApple(scaffoldKey: _scaffoldKey, userType: widget.userType);
  }

}*/