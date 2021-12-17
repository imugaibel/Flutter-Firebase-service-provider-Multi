import 'package:flutter/material.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/alert.dart';
import 'package:maintenance/widgets/loader.dart';
import 'package:maintenance/widgets/notifications.dart';
import 'package:maintenance/utils/extensions.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {

  Status status = Status.PENDING;
  UserType userType = UserType.ADMIN;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("Users")),
        centerTitle: true,
        actions: [
          NotificationsWidget(),
        ],
      ),
      body: FutureBuilder<UserModel>(
        future: UserProfile.shared.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            UserModel currentUser = snapshot.data;

            return StreamBuilder<List<UserModel>>(
              stream: FirebaseManager.shared.getAllUsers(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {

                  List<UserModel> items = [];

                  for (var user in snapshot.data) {
                    if (user.uid != currentUser.uid && user.accountStatus == status && user.userType == userType) {
                      items.add(user);
                    }
                  }

                  items.sort((a,b) {
                    return DateTime.parse(b.dateCreated).compareTo(DateTime.parse(a.dateCreated));
                  });

                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: items.length == 0 ? items.length + 2 : items.length + 1,
                    itemBuilder: (context, index) {
                      return index == 0 ? _header() : (items.length == 0 ? Center(child: Text(AppLocalization.of(context).translate("There are no members"), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),) : _item(user: items[index - 1]));
                    },
                  );
                } else {
                  return Center(child: loader(context));
                }

              }
            );
          } else {
            return SizedBox();
          }
        }
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalization.of(context).translate("Status Account:-"), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
        SizedBox(height: 10),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: Status.ACTIVE,
                  groupValue: status,
                  onChanged: (Status value) {
                    setState(() {
                      status = value;
                    });
                  },
                ),
                Text(AppLocalization.of(context).translate("active")),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: Status.PENDING,
                  groupValue: status,
                  onChanged: (Status value) {
                    setState(() {
                      status = value;
                    });
                  },
                ),
                Text(AppLocalization.of(context).translate("pending")),
              ],
            ),

            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: Status.Disable,
                  groupValue: status,
                  onChanged: (Status value) {
                    setState(() {
                      status = value;
                    });
                  },
                ),
                Text(AppLocalization.of(context).translate("disable")),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(AppLocalization.of(context).translate("User Type:-"), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
        SizedBox(height: 10),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: UserType.ADMIN,
                  groupValue: userType,
                  onChanged: (UserType value) {
                    setState(() {
                      userType = value;
                    });
                  },
                ),
                Text(AppLocalization.of(context).translate("admins")),
              ],
            ),
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

  Widget _item({ @required UserModel user }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
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
              Text(AppLocalization.of(context).translate("Date created: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
              SizedBox(width: 10),
              Flexible(child: Text(user.dateCreated.changeDateFormat(), style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor))),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: status == Status.PENDING,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        FirebaseManager.shared.changeStatusAccount(scaffoldKey: _scaffoldKey, userId: user.uid, status: Status.ACTIVE);
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
                                AppLocalization.of(context).translate("accept"),
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                    SizedBox(width: 20,),
                  ],
                ),
              ),              Visibility(
                visible: status == Status.PENDING,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        FirebaseManager.shared.changeStatusAccount(scaffoldKey: _scaffoldKey, userId: user.uid, status: Status.Rejected);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                                AppLocalization.of(context).translate("Rejected"),
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                    SizedBox(width: 20,),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.Disable,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        FirebaseManager.shared.changeStatusAccount(scaffoldKey: _scaffoldKey, userId: user.uid, status: Status.ACTIVE);
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
                              AppLocalization.of(context).translate("activation"),
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                    SizedBox(width: 20,),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.ACTIVE,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showAlertDialog(context, title: AppLocalization.of(context).translate("Disable Account"), message: AppLocalization.of(context).translate("Are you sure disable account?"), titleBtnOne: "disabled", titleBtnTwo: "Close", actionBtnOne: () {
                          Navigator.of(context).pop();
                          FirebaseManager.shared.changeStatusAccount(scaffoldKey: _scaffoldKey, userId: user.uid, status: Status.Disable);
                        }, actionBtnTwo: () {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                              AppLocalization.of(context).translate("disabled"),
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                    SizedBox(width: 20,),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.Disable,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showAlertDialog(context, title: AppLocalization.of(context).translate("Delete Account"), message: AppLocalization.of(context).translate("Are you sure delete account?"), titleBtnOne: "Delete", titleBtnTwo: "Close", actionBtnOne: () {
                          Navigator.of(context).pop();
                          FirebaseManager.shared.changeStatusAccount(scaffoldKey: _scaffoldKey, userId: user.uid, status: Status.Deleted);
                        }, actionBtnTwo: () {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                                AppLocalization.of(context).translate("Delete"),
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
