import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/model/chat-model.dart';
import 'package:maintenance/model/order-model.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:timeago/timeago.dart' as timeago;

class Chat extends StatelessWidget {
  final OrderModel order;

  Chat({Key? key, required this.order}) : super(key: key);

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProfile.shared.getLanguage().then((value) {
      timeago.setLocaleMessages(
          value == Language.ARABIC ? 'ar' : 'en',
          value == Language.ARABIC
              ? timeago.ArMessages()
              : timeago.EnMessages());
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context)!.translate("Chat")),
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel?>(
          future: UserProfile.shared.getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserModel user = snapshot.data!;

              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<List<ChatModel>>(
                            stream: FirebaseManager.shared
                                .getChatByUidOrder(uidOrder: order.uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<ChatModel> messages = [];

                                for (var message in snapshot.data!) {
                                  if (message.uidUser == order.userId) {
                                    messages.add(message);
                                  }
                                }

                                messages.sort((a, b) {
                                  return DateTime.parse(a.createdDate)
                                      .compareTo(
                                          DateTime.parse(b.createdDate));
                                });

                                return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 30,
                                  ),
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    return _item(context,
                                        currentUser: user,
                                        message: messages[index]);
                                  },
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                      ),
                      Visibility(
                        visible: user.userType != UserType.ADMIN,
                        child: const SizedBox(
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: user.userType != UserType.ADMIN,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 35,
                              child: IconButton(
                                icon: Icon(
                                  Icons.attach_file,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () => _getAttachFile(context),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: AppLocalization.of(context)!
                                      .translate("Enter message"),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 35,
                              child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () async {
                                  if (_messageController.text.trim() != "") {
                                    _sendMessage(
                                      context,
                                      message: _messageController.text.trim(),
                                    );
                                    _messageController.text = "";
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  Widget _item(
    context, {
    required UserModel currentUser,
    required ChatModel message,
  }) {
    bool myMessage =
        message.uidSender == FirebaseManager.shared.auth.currentUser!.uid;

    if (currentUser.userType == UserType.ADMIN) {
      myMessage = message.uidSender != message.uidUser;
    }

    return Row(
      children: [
        Visibility(
          visible: !myMessage,
          child: const Expanded(
            child: SizedBox(),
          ),
        ),
        Column(
          crossAxisAlignment:
              myMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color:
                    (myMessage ? Theme.of(context).primaryColor : Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: message.image != ""
                  ? _itemImage(message.image)
                  : _itemText(message.message),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  timeago.format(DateTime.parse(message.createdDate)),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
        Visibility(
          visible: myMessage,
          child: const Expanded(
            child: SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _itemText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _itemImage(String imagePath) {
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      width: 150,
      height: 150,
    );
  }

  Widget _itemPdf(String path) {
    return const Icon(
      Icons.picture_as_pdf,
      size: 56,
      color: Colors.white,
    );
  }

  _getAttachFile(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  AppLocalization.of(context)!.translate('Camera'),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onTap: () =>
                    _selectImage(context, imageSource: ImageSource.camera),
              ),
              ListTile(
                leading: Icon(
                  Icons.image,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  AppLocalization.of(context)!.translate('Gallery'),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onTap: () =>
                    _selectImage(context, imageSource: ImageSource.gallery),
              ),
              // ListTile(
              //   leading: Icon(
              //     Icons.picture_as_pdf,
              //     color: Theme.of(context).primaryColor,
              //   ),
              //   title: Text(
              //     AppLocalization.of(context).translate('Pdf file'),
              //     style: TextStyle(color: Theme.of(context).primaryColor),
              //   ),
              //   onTap: () =>
              //       _selectImage(context, imageSource: ImageSource.gallery),
              // ),
            ],
          );
        });
  }

  _selectImage(context, {required ImageSource imageSource}) async {
    PickedFile? image =
        await ImagePicker.platform.pickImage(source: imageSource);

    String? uidReceiver =
        FirebaseManager.shared.auth.currentUser!.uid == order.userId
            ? order.userId
            : order.ownerId;

    Navigator.of(context).pop();

    FirebaseManager.shared.sendMessage(context,
        image: image!.path,
        uidOrder: order.uid,
        uidService: order.serviceId,
        uidReceiver: uidReceiver,
        uidUser: order.userId);
  }

  _sendMessage(context, {required String message}) {
    String? uidReceiver =
        FirebaseManager.shared.auth.currentUser!.uid == order.userId
            ? order.userId
            : order.ownerId;

    FirebaseManager.shared.sendMessage(context,
        message: message,
        uidOrder: order.uid,
        uidService: order.serviceId,
        uidReceiver: uidReceiver,
        uidUser: order.userId);
  }
}
