import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/assets.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/btn-main.dart';
import 'package:maintenance/widgets/loader.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  TextEditingController _balanceController = TextEditingController();

  UserType userType = UserType.TECHNICIAN;

  @override
  void dispose() {
    // TODO: implement dispose
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("Wallet")),
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel>(
          future: UserProfile.shared.getUser(),
          builder: (context, snapshot) {

            if (snapshot.hasData) {

              if (snapshot.data.userType == UserType.ADMIN) {
                return _adminWallet(context);
              } else {
                return _userWallet(context);
              }

            } else {
              return Center(child: loader(context),);
            }

          }
      ),
    );
  }

  Widget _userWallet(context) {
    return FutureBuilder<UserModel>(
        future: FirebaseManager.shared.getCurrentUser(),
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * (100 / 812),),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (200 / 812),
                    child: SvgPicture.asset(Assets.shared.icWallet,),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (100 / 812),),
                  Text(AppLocalization.of(context).translate("Your balance is:"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 32),),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${snapshot.data.balance}", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 32),),
                      SizedBox(width: 5),
                      Text(AppLocalization.of(context).translate("RAS"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 32),),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (100 / 812),),
                ],
              ),
            );
          } else {
            return Center(child: loader(context),);
          }

        }
    );
  }

  Widget _adminWallet(context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: _header(),
        ),
        Expanded(
          child: StreamBuilder<List<UserModel>>(
              stream: FirebaseManager.shared.getAllUsers(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {

                  List<UserModel> users = [];

                  for (var user in snapshot.data) {
                    if (user.userType == userType) {
                      users.add(user);
                    }
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return _cellItem(context, user: users[index]);
                    },
                  );
                } else {
                  return Center(child: loader(context),);
                }

              }
          ),
        ),
      ],
    );
  }

  Widget _cellItem(context, { @required UserModel user }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Text(AppLocalization.of(context).translate("User ID: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
              SizedBox(width: 10),
              Flexible(child: Text(user.id, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor))),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(AppLocalization.of(context).translate("User name: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
              SizedBox(width: 10),
              Flexible(child: Text(user.name, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor))),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(AppLocalization.of(context).translate("Email: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
              SizedBox(width: 10),
              Flexible(child: Text(user.email, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor))),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(AppLocalization.of(context).translate("Phone: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
              SizedBox(width: 10),
              Flexible(child: Text(user.phone, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor))),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(AppLocalization.of(context).translate("User balance: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
              SizedBox(width: 10),
              Flexible(child: Text("${user.balance} ${AppLocalization.of(context).translate("RAS")}", style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor))),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _editBalance(context, uidUser: user.uid);
                  _balanceController.text = "${user.balance}";
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * (50 / 812),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                      child: Text(
                        AppLocalization.of(context).translate("Edit Balance"),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalization.of(context).translate("User Type:-"), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
        SizedBox(height: 10),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: UserType.TECHNICIAN,
                  groupValue: userType,
                  onChanged: (UserType value) {
                    setState(() {
                      userType = value;
                    });
                  },
                ),
                Text(AppLocalization.of(context).translate("technicians")),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: UserType.USER,
                  groupValue: userType,
                  onChanged: (UserType value) {
                    setState(() {
                      userType = value;
                    });
                  },
                ),
                Text(AppLocalization.of(context).translate("users")),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(height: 1, color: Theme.of(context).primaryColor,),
        SizedBox(height: 20),
      ],
    );
  }

  _editBalance(context, { @required String uidUser }) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * (140 / 812),
        child: Column(
          children: [
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: AppLocalization.of(context).translate("Balance")
              ),
            ),
            Expanded(child: SizedBox()),
            Container(
              height: MediaQuery.of(context).size.height * (40 / 812),
              child: BtnMain(title: AppLocalization.of(context).translate("Edit Balance"), onTap: () {
                FirebaseManager.shared.updateWalletToUser(context, uid: uidUser, balance: double.parse(_balanceController.text.trim() == "" ? "0.0" : _balanceController.text.trim()));
                Navigator.of(context).pop();
              },),
            ),
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
}
