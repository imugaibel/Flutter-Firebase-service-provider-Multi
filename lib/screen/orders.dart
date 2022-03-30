import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/model/order-model.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/screen/chat.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/loader.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Language lang = Language.ENGLISH;

  Status status = Status.ACTIVE;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      if (value != null) {
        setState(() {
          lang = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context)!.translate("Orders")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _header(),
            Expanded(
              child: FutureBuilder<UserModel?>(
                  future: UserProfile.shared.getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List<OrderModel>>(
                          stream: snapshot.data!.userType == UserType.ADMIN
                              ? FirebaseManager.shared.getAllOrders()
                              : snapshot.data!.userType == UserType.TECHNICIAN
                                  ? FirebaseManager.shared.getMyOrdersTech()
                                  : FirebaseManager.shared.getMyOrders(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<OrderModel> orders = [];

                              for (var order in snapshot.data!) {
                                if (order.status == status) {
                                  orders.add(order);
                                }
                              }

                              return orders.isEmpty
                                  ? Center(
                                      child: Text(
                                          AppLocalization.of(context)!
                                              .translate("no orders"),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    )
                                  : ListView.builder(
                                      itemCount: orders.length,
                                      itemBuilder: (context, index) {
                                        return _item(context,
                                            order: orders[index]);
                                      },
                                    );
                            } else {
                              return Center(child: loader(context));
                            }
                          });
                    } else {
                      return Center(
                        child: loader(context),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalization.of(context)!.translate("Status Order:-"),
          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: Status.ACTIVE,
                      groupValue: status,
                      onChanged: (Status? value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context)!.translate("active")),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: Status.PENDING,
                      groupValue: status,
                      onChanged: (Status? value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context)!.translate("in review")),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: Status.Rejected,
                      groupValue: status,
                      onChanged: (Status? value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context)!.translate("rejected")),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: Status.Finished,
                      groupValue: status,
                      onChanged: (Status? value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context)!.translate("finished")),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: Status.canceled,
                      groupValue: status,
                      onChanged: (Status? value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context)!.translate("canceled")),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 1,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _item(context, {required OrderModel order}) {
    String statusTitle = "";
    Widget statusIcon = const Icon(
      Icons.check,
      size: 22,
      color: Colors.green,
    );

    switch (order.status) {
      case Status.ACTIVE:
        statusTitle = AppLocalization.of(context)!.translate("Activity");
        statusIcon = const Icon(
          Icons.timer,
          size: 22,
          color: Colors.blue,
        );
        break;
      case Status.PENDING:
        statusTitle = AppLocalization.of(context)!.translate("In Review");
        statusIcon = const Icon(
          Icons.update,
          size: 22,
          color: Colors.yellow,
        );
        break;
      case Status.Rejected:
        statusTitle = AppLocalization.of(context)!.translate("Rejected");
        statusIcon = const Icon(
          Icons.report,
          size: 22,
          color: Colors.red,
        );
        break;
      case Status.Finished:
        statusTitle = AppLocalization.of(context)!.translate("Finished");
        statusIcon = const Icon(
          Icons.check,
          size: 22,
          color: Colors.green,
        );
        break;
      case Status.Deleted:
        // TODO: Handle this case.
        break;
      case Status.Disable:
        // TODO: Handle this case.
        break;
      case Status.canceled:
        statusTitle = AppLocalization.of(context)!.translate("cancele");
        statusIcon = const Icon(
          Icons.report,
          size: 22,
          color: Colors.orange,
        );
        break;
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed("/OrderDetails", arguments: order),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalization.of(context)!.translate("Service: "),
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(width: 10),
                        StreamBuilder<ServiceModel>(
                            stream: FirebaseManager.shared
                                .getServiceById(id: order.serviceId),
                            builder: (context, snapshot) {
                              String serviceName = snapshot.hasData
                                  ? lang == Language.ARABIC
                                      ? snapshot.data!.titleAR
                                      : snapshot.data!.titleEN
                                  : "";
                              return Text(serviceName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.secondary));
                            }),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Chat(
                              order: order,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.chat,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      AppLocalization.of(context)!.translate("Details"),
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: 10),
                    Text(order.details,
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
                Visibility(
                  visible: order.status == Status.Rejected,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            AppLocalization.of(context)!
                                .translate("Reason of refuse: "),
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(width: 10),
                          Text(
                              lang == Language.ARABIC
                                  ? order.messageAR: order.messageEN,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.secondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: order.status == Status.canceled,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            AppLocalization.of(context)!
                                .translate("Reason of cancele: "),
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(width: 10),
                          Text(
                              lang == Language.ARABIC
                                  ? order.messageAR: order.messageEN,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.secondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      AppLocalization.of(context)!.translate("Tech name: "),
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: 10),
                    FutureBuilder<UserModel>(
                        future: FirebaseManager.shared
                            .getUserByUid(uid: order.ownerId),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.hasData ? snapshot.data!.name : "",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary),
                          );
                        }),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      AppLocalization.of(context)!.translate("Customer name: "),
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: 10),
                    FutureBuilder<UserModel>(
                        future: FirebaseManager.shared
                            .getUserByUid(uid: order.userId),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.hasData ? snapshot.data!.name : "",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary),
                          );
                        }),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      AppLocalization.of(context)!.translate("Date: "),
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      order.createdDate.changeDateFormat(),
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        statusIcon,
                        const SizedBox(width: 10),
                        Text(
                          statusTitle,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
