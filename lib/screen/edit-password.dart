import 'package:flutter/material.dart';
import 'package:maintenance/styles/input_style.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/widgets/custom_button.dart';
import 'package:maintenance/utils/extensions.dart';

class EditPassword extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? newPassword;
  String? confirmPassword;

  EditPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalization.of(context)!.translate("Edit Password")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Icon(
                Icons.lock_outline,
                size: 150,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (100 / 812)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (value) => newPassword = value!.trim(),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      decoration: customInputForm.copyWith(prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      ).copyWith(hintText: AppLocalization.of(context)!.translate("New password")),
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      onSaved: (value) => confirmPassword = value!.trim(),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      decoration: customInputForm.copyWith(prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      ).copyWith(hintText: AppLocalization.of(context)!.translate("Confirm password")),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (100 / 812)),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * ( 55 / 812 ),
                      child: customButton(context, title: AppLocalization.of(context)!.translate("Change password"), onPressed: () => _btnChange(context)),
                    ),
                    const SizedBox(height: 20,),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validation() {
    return !(newPassword == "" || confirmPassword == "");
  }

  _btnChange(context) {

    _formKey.currentState!.save();

    if (_validation()) {
      if (newPassword == confirmPassword) {
        FirebaseManager.shared.changePassword(scaffoldKey: _scaffoldKey, newPassword: newPassword!, confirmPassword: confirmPassword!);
      } else {
        _scaffoldKey.showTosta(message: AppLocalization.of(context)!.translate("Passwords do not match"), isError: true);
      }
    } else {
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.translate("Please fill in all fields"), isError: true);
    }

  }

}
