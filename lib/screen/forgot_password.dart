import 'package:flutter/material.dart';
import 'package:maintenance/styles/input_style.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/assets.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/widgets/custom_button.dart';
import 'package:maintenance/utils/extensions.dart';

class ForgotPassword extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();

  late String email;

  ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
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
                        SizedBox(height: MediaQuery.of(context).size.height * (40 / 812)),
                        Image.asset(Assets.shared.icLogo, fit: BoxFit.cover, height: MediaQuery.of(context).size.height * (250 / 812),),
                        const SizedBox(height: 20),
                        Text(AppLocalization.of(context)!.translate("Forgot Password"), style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 26,
                        ),),
                        const SizedBox(height: 50,),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                onSaved: (value) => email = value!.trim(),
                                keyboardType: TextInputType.emailAddress,
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
                              SizedBox(height: MediaQuery.of(context).size.height * (120 / 812)),
                              SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * ( 55 / 812 ),
                                child: customButton(context, title: AppLocalization.of(context)!.translate("Reset password"), onPressed: _btnForgotPassword),
                              ),
                              const SizedBox(height: 35,),
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

  _btnForgotPassword() async {

    _formKey.currentState!.save();

    if (email != "") {
      bool success = await FirebaseManager.shared.forgotPassword(scaffoldKey: _scaffoldKey, email: email);

      if (success) {
        _emailController.text = "";
        _scaffoldKey.showTosta(message: AppLocalization.of(_scaffoldKey.currentContext)!.translate("The appointment link has been sent to your email"));
      }

    } else {
      _scaffoldKey.showTosta(message: AppLocalization.of(_scaffoldKey.currentContext)!.translate("Please enter your email"), isError: true);
    }

  }

}
