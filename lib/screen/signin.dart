import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maintenance/styles/input_style.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/assets.dart';
import 'package:maintenance/utils/firebase-manager.dart';

import 'package:maintenance/utils/extensions.dart';

import '../widgets/alert.dart';
import '../widgets/custom_button.dart';

class SignIn extends StatefulWidget {
  final  message;

  const SignIn({Key? key, this.message}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  late String email;
  late String password;
  bool isShowPassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.message != null) {
      Future.delayed(Duration(seconds: 1), () {
        showAlertDialog(context, title: AppLocalization.of(context)!.translate("Done Successfully"), message: AppLocalization.of(context)!.translate(widget.message), showBtnOne: false, actionBtnTwo: () {
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
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Column(children: [
                  Center(
                      child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Column(children: [
                      Image.asset(
                        Assets.shared.icLogo,
                        fit: BoxFit.cover,
                        height:
                            MediaQuery.of(context).size.height * (250 / 812),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                TextFormField(
                                  onSaved: (value) => email = value!.trim(),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  decoration: customInputForm
                                      .copyWith(
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                      .copyWith(
                                          hintText: AppLocalization.of(context)!
                                              .translate("Email")),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  onSaved: (value) => password = value!.trim(),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  obscureText: !isShowPassword,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  decoration: customInputForm
                                      .copyWith(
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                      .copyWith(
                                          hintText: AppLocalization.of(context)!
                                              .translate("Password"))
                                      .copyWith(
                                          suffixIcon: GestureDetector(
                                        onTap: () => setState(() {
                                          isShowPassword = !isShowPassword;
                                        }),
                                        child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: SvgPicture.asset(
                                              isShowPassword
                                                  ? Assets.shared.icInvisible
                                                  : Assets.shared.icVisibility,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              height: 5,
                                              width: 5,
                                            )),
                                      )),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FlatButton(
                                      child: Text(
                                        AppLocalization.of(context)!
                                            .translate("Forgot Password?"),
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/ForgotPassword'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height *
                                      (55 / 812),
                                  child: customButton(context,
                                      title: AppLocalization.of(context)!
                                          .translate("Sign In"),
                                      onPressed: _btnSignin),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 0),
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.pushNamed(context, '/SignUp'),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate("Create new account"),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
                  ))
                ]))));
  }

  bool _validation() {
    return !(email == "" || password == "");
  }

  _btnSignin() {
    _formKey.currentState!.save();

    if (!_validation()) {
      _scaffoldKey.showTosta(
          message: AppLocalization.of(context)!
              .translate("Please fill in all fields"),
          isError: true);
      return;
    }

    FirebaseManager.shared
        .login(scaffoldKey: _scaffoldKey, email: email, password: password);
  }

  _btnSigninWithGoogle() {
    // FirebaseManager.shared.signInWithGoogle(scaffoldKey: _scaffoldKey, userType: widget.userType);
  }

  _btnSigninWithTwitter() {
    // FirebaseManager.shared.signInWithTwitter(scaffoldKey: _scaffoldKey, userType: widget.userType);
  }

  _btnSigninWithApple() {
    // FirebaseManager.shared.signInWithApple(scaffoldKey: _scaffoldKey, userType: widget.userType);
  }

// _payment() async {
//   var request = BraintreeDropInRequest(
//     tokenizationKey: "sandbox_7b5szbqs_ghjp5bfby3bs7p5v",
//     collectDeviceData: true,
//     paypalRequest: BraintreePayPalRequest(
//       amount: "10.00",
//       displayName: "name",
//     ),
//     cardEnabled: true,
//   );
//
//   BraintreeDropInResult result = await BraintreeDropIn.start(request);
//
//   if (result != null) {
//     print("===================");
//     print(result.paymentMethodNonce.description);
//     print(result.paymentMethodNonce.nonce);
//     print("===================");
//   }
//
// }

}
