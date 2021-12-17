import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/model/ads-model.dart';
import 'package:maintenance/model/notification-model.dart';
import 'package:maintenance/model/order-model.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/loader.dart';
import 'package:uuid/uuid.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/widgets/alert.dart';
import 'app_localization.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseManager {

  static final FirebaseManager shared = FirebaseManager();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection('User');
  final adsRef = FirebaseFirestore.instance.collection('Ads');
  final serviceRef = FirebaseFirestore.instance.collection('Service');
  final orderRef = FirebaseFirestore.instance.collection('Order');
  final notificationRef = FirebaseFirestore.instance.collection('Notification');
  final storageRef = FirebaseStorage.instance.ref();

  // TODO:- Start User

  Stream<List<UserModel>> getAllUsers() {
    return userRef.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<UserModel> getUserByUid({ @required String uid }) async {

    UserModel userTemp;

    var user = await userRef.doc(uid).snapshots().first;
    userTemp = UserModel.fromJson(user.data());

    return userTemp;
  }

  Future<UserModel> getCurrentUser() {
    return getUserByUid(uid: auth.currentUser.uid);
  }

  createAccountUser (
      {
        @required GlobalKey<ScaffoldState> scaffoldKey,
        @required String imagePath,
        @required String name,
        @required String phone,
        @required String email,
        @required String city,
        @required String password,
        @required UserType userType,
      }) async {

    showLoaderDialog(scaffoldKey.currentContext);

    if (!email.isValidEmail()) {
      scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("please enter a valid email"), isError: true);
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      return;
    }

    var userId = await _createAccountInFirebase(scaffoldKey: scaffoldKey, email: email, password: password);

    String imgUrl = "";

    if (imagePath != null && imagePath != "") {
      await _uploadImage(folderName: "user", imagePath: imagePath);
    }

    List<UserModel> users = await getAllUsers().first;

    if (userId != null) {
      userRef.doc(userId).set({
        "id": "${users.length}${Random().nextInt(99999)}",
        "image": imgUrl,
        "name": name,
        "phone": phone,
        "email": email,
        "city": city,
        "balance": 0,
        "lat": -1,
        "lng": -1,
        "status-account": 1,
        "type-user": userType.index,
        "uid": userId,
      })
          .then((value) async {

        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
        this.addNotifications(uidUser: userId, titleEN: "Welcome", titleAR: "مرحبا بك", detailsEN: "Welcome to our app\nWe wish you a happy experience", detailsAR: "مرحبا بك في تطبيقنا\nنتمنى لك تجربة رائعة");

        await getAllUsers().first.then((users) {

          for (var user in users) {
            if (user.userType == UserType.ADMIN) {
                this.addNotifications(uidUser: user.uid, titleEN: "New User", titleAR: "مستخدم جديد", detailsEN: "$name new created a new account", detailsAR: "$name أنشأ حساب جديد ");
            }
          }

        });

        Navigator.of(scaffoldKey.currentContext).pushNamedAndRemoveUntil("/ChooseUserType", (route) => false, arguments: "Account created successfully, Your account in now under review");

      })
          .catchError((err) {
        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Something went wrong"), isError: true);
      });
    } else {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
    }

  }

  createAccountAdminOrTech (
      {
        @required GlobalKey<ScaffoldState> scaffoldKey,
        @required UserType userType,
        @required UserCredential user,
      }) async {

    showLoaderDialog(scaffoldKey.currentContext);

    var userId = user.user.uid;

    if (userId != null) {
      userRef.doc(userId).set({
        "id": "${Random().nextInt(99999)}",
        "image": user.user.photoURL == null ? "" : user.user.photoURL,
        "name": user.user.displayName == null ? "" : user.user.displayName,
        "phone": user.user.phoneNumber == null ? "" : user.user.phoneNumber,
        "city": "",
        "balance": 0,
        "lat": -1,
        "lng": -1,
        "email": user.user.email,
        "status-account": 1,
        "type-user": userType.index,
        "uid": userId,
      })
          .then((value) async {
        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
        this.addNotifications(uidUser: userId, titleEN: "Welcome", titleAR: "مرحبا بك", detailsEN: "Welcome to our app\nWe wish you a happy experience", detailsAR: "مرحبا بك في تطبيقنا\nنتمنى لك تجربة رائعة");
        Navigator.of(scaffoldKey.currentContext).pop();
        await showAlertDialog(scaffoldKey.currentContext, title: AppLocalization.of(scaffoldKey.currentContext).translate("Done Successfully"), message: AppLocalization.of(scaffoldKey.currentContext).translate("Account created successfully, Your account in now under review"), showBtnTwo: false, actionBtnOne: () {
          Navigator.of(scaffoldKey.currentContext).pop();
        });
        Navigator.pushNamedAndRemoveUntil(scaffoldKey.currentContext, "/ChooseUserType", (route) => false, arguments: "Account created successfully, Your account in now under review");
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("The account has been successfully. created Your account is now under review"));
      })
          .catchError((err) {
        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Something went wrong"), isError: true);
      });
    } else {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
    }

  }

  changeStatusAccount({
    @required GlobalKey<ScaffoldState> scaffoldKey,
    @required String userId,
    @required Status status,
  } ) {
    showLoaderDialog(scaffoldKey.currentContext);

    userRef.doc(userId).update({
      "status-account": status.index,
    })
        .then((value) async {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("done successfully"));
    })
        .catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Something went wrong"), isError: true);
    });

  }

  updateAccount({
    @required GlobalKey<ScaffoldState> scaffoldKey,
    @required String image,
    @required String name,
    @required String city,
    @required String phoneNumber,
    @required String location,
  } ) async {
    showLoaderDialog(scaffoldKey.currentContext);

    String imageURL = "";

    if (image != "") {
      if (image.isURL()) {
        imageURL = image;
      } else {
        imageURL = await _uploadImage(folderName: "user", imagePath: image);
      }
    }

    double lat;
    double lng;

    var tempLatLng = location.split(", ");

    if (tempLatLng.length == 2) {
      lat = double.parse(tempLatLng.first);
      lng = double.parse(tempLatLng.last);
    } else {
      lat = -1;
      lng = -1;
    }

    userRef.doc(auth.currentUser.uid).update({
      "image": imageURL,
      "name": name,
      "phone": phoneNumber,
      "city": city,
      "lat": lat,
      "lng": lng,
    })
        .then((value) async {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      UserModel user = await UserProfile.shared.getUser();
      user.image = imageURL;
      user.name = name;
      user.city = city;
      user.lat = lat;
      user.lng = lng;
      user.phone = phoneNumber;
      UserProfile.shared.setUser(user: user);
      Navigator.of(scaffoldKey.currentContext).pop();
    })
        .catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Something went wrong"), isError: true);
    });

  }

  changePassword({
    @required GlobalKey<ScaffoldState> scaffoldKey,
    @required String newPassword,
    @required String confirmPassword,
  } ) async {
    showLoaderDialog(scaffoldKey.currentContext);

    auth.currentUser.updatePassword(newPassword).then((value) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      Navigator.of(scaffoldKey.currentContext).pop();
    }).catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Something went wrong"), isError: true);
    });

  }

  // TODO:- End User

  // TODO:- Start Auth

  signInWithGoogle({ GlobalKey<ScaffoldState> scaffoldKey, UserType userType }) async {

    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot doc = await userRef.doc(userCredential.user.uid).get();

    if (!doc.exists) {

      if (userType == UserType.ADMIN) {
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("This feature is allowed for admin only"), isError: true);
        return;
      } else {
        createAccountAdminOrTech(scaffoldKey: scaffoldKey, userType: userType, user: userCredential);
      }

    } else {
      await getUserByUid(uid: userCredential.user.uid).then((UserModel user) {

        if (user.userType != userType) {
          scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("User not found"), isError: true);
          auth.signOut();
          return;
        }

        switch (user.accountStatus) {
          case Status.ACTIVE:
            UserProfile.shared.setUser(user: user);
            Navigator.of(scaffoldKey.currentContext).pushNamedAndRemoveUntil('/Tabbar', (Route<dynamic> route) => false, arguments: user.userType);
            break;
          case Status.PENDING:
            scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Account under review"), isError: true);
            auth.signOut();
            break;
          case Status.Rejected:
            scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Your account has been denied"), isError: true);
            auth.signOut();
            break;
          case Status.Deleted:
            scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Your account has been deleted"), isError: true);
            auth.signOut();
            break;
        }

      });
    }
  }

  signInWithApple({ GlobalKey<ScaffoldState> scaffoldKey, UserType userType }) async {

    String generateNonce([int length = 32]) {
      final charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(length, (_) => charset[random.nextInt(charset.length)])
          .join();
    }

    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    DocumentSnapshot doc = await userRef.doc(userCredential.user.uid).get();

    if (!doc.exists) {

      if (userType == UserType.ADMIN) {
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("This feature is allowed for admin only"), isError: true);
        return;
      } else {
        createAccountAdminOrTech(scaffoldKey: scaffoldKey, userType: userType, user: userCredential);
      }

    } else {
      await getUserByUid(uid: userCredential.user.uid).then((UserModel user) {

        if (user.userType != userType) {
          scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("User not found"), isError: true);
          auth.signOut();
          return;
        }

        switch (user.accountStatus) {
          case Status.ACTIVE:
            UserProfile.shared.setUser(user: user);
            Navigator.of(scaffoldKey.currentContext).pushNamedAndRemoveUntil('/Tabbar', (Route<dynamic> route) => false, arguments: user.userType);
            break;
          case Status.PENDING:
            scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Account under review"), isError: true);
            auth.signOut();
            break;
          case Status.Rejected:
            scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Your account has been denied"), isError: true);
            auth.signOut();
            break;
          case Status.Deleted:
            scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Your account has been deleted"), isError: true);
            auth.signOut();
            break;
        }

      });
    }
  }

  login({ @required GlobalKey<ScaffoldState> scaffoldKey, @required String email, @required String password }) async {

    try {

      try {
   //     await FirebaseFirestore.instance.terminate();
        await FirebaseFirestore.instance.clearPersistence();
      } catch (e) {
      }
      showLoaderDialog(scaffoldKey.currentContext);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      await getUserByUid(uid: auth.currentUser.uid).then((UserModel user) {
        switch (user.accountStatus) {
          case Status.ACTIVE:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            UserProfile.shared.setUser(user: user);
            Navigator.of(scaffoldKey.currentContext).pushNamedAndRemoveUntil('/Tabbar', (Route<dynamic> route) => false, arguments: user.userType);
            break;
          case Status.PENDING:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Account under review"), isError: true);
            auth.signOut();
            break;
          case Status.Rejected:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Your account has been denied"), isError: true);
            auth.signOut();
            break;
          case Status.Deleted:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Your account has been deleted"), isError: true);
            auth.signOut();
            break;
          case Status.Disable:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Your account has been disabled"), isError: true);
            auth.signOut();
        }

      });

      return;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("user not found"), isError: true);
      } else if (e.code == 'wrong-password') {
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("wrong password"), isError: true);
      } else if (e.code == 'too-many-requests') {
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("The account is temporarily locked"), isError: true);
      } else {
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("Something went wrong"), isError: true);
      }
    }

    showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
    return;
  }

  Future<String> _createAccountInFirebase({GlobalKey<ScaffoldState> scaffoldKey, String email, String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("the email is already used"), isError: true);
      }
      return null;
    } catch (e) {
      scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("something went wrong"), isError: true);
      print(e);
      return null;
    }
  }

  signOut(context) async {
    try {
      showLoaderDialog(context);

      await FirebaseAuth.instance.signOut();
      await UserProfile.shared.setUser(user: null);
      showLoaderDialog(context, isShowLoader: false);
      Navigator.pushNamedAndRemoveUntil(context, "/Front", (route) => false);
    } catch (_) {
      showLoaderDialog(context, isShowLoader: false);
    }
  }

  Future<bool> forgotPassword({ @required GlobalKey<ScaffoldState> scaffoldKey, @required String email }) async {

    showLoaderDialog(scaffoldKey.currentContext);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      return true;
    } on FirebaseAuthException catch (e) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      if (e.code == 'user-not-found') {
        scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext).translate("user not found"), isError: true);
        return false;
      }
    }

  }
  deleteAccount(context, { @required String iduser }) async {

    showLoaderDialog(context);

    await userRef.doc(iduser).delete().then((_) => {

    }).catchError((e) {

    });

    showLoaderDialog(context, isShowLoader: false);

  }

  // TODO:- End Auth

  // TODO:- Start Ads

  addAds(
      context,
      {
        @required String image,
      }
      ) async {

    if (!image.isURL()) {
      String uid = adsRef.doc().id;
      showLoaderDialog(context);
      String imageUrl = await _uploadImage(folderName: "ads", imagePath: image);
      adsRef.doc(uid).set({
        "image": imageUrl,
        "createdDate": DateTime.now().toString(),
        "uid": uid,
      })
          .then((value) {
        showLoaderDialog(context, isShowLoader: false);
      })
          .catchError((err) {
        showLoaderDialog(context, isShowLoader: false);
      });
    }

  }

  deleteAds(context, { @required String idAds }) async {

    showLoaderDialog(context);

    await adsRef.doc(idAds).delete().then((_) => {

    }).catchError((_) {

    });

    showLoaderDialog(context, isShowLoader: false);

  }

  Stream<List<AdsModel>> getAds() {
    return adsRef.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return AdsModel.fromJson(doc.data());
      }).toList();
    });
  }

  // TODO:- End Ads

  // TODO:- Start Service

  addOrEditService(
      context,
      {
        String uid = "",
        @required List<String> images,
        @required String titleEN,
        @required String detailsEN,
        @required String titleAR,
        @required String detailsAR,
      }
      ) async {

    showLoaderDialog(context);

    String tempUid = (uid == null || uid == "") ? serviceRef.doc().id : uid;

    List<String> imagesUrl = [];

    for (var image in images) {
      if (image.isURL()) {
        imagesUrl.add(image);
      } else {
        String urlImage = await _uploadImage(folderName: "service", imagePath: image);
        imagesUrl.add(urlImage);
      }
    }

    serviceRef.doc(tempUid).set({
      "images": imagesUrl.join(", "),
      "title-en": titleEN,
      "details-en": detailsEN,
      "title-ar": titleAR,
      "details-ar": detailsAR,
      "createdDate": DateTime.now().toString(),
      "uid-owner": auth.currentUser.uid,
      "status": Status.PENDING.index,
      "message-en": "",
      "message-ar": "",
      "uid": tempUid,
    })
        .then((value) {
      showLoaderDialog(context, isShowLoader: false);
      Navigator.of(context).pop();
    })
        .catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });

  }

  changeServiceStatus(
      context,
      {
        @required ServiceModel service,
        @required Status status,
        String messageEN = "",
        String messageAR = "",
      }
      ) async {

    showLoaderDialog(context);

    serviceRef.doc(service.uid).update({
      "status": status.index,
      "message-en": messageEN,
      "message-ar": messageAR,
    })
        .then((value) {
      showLoaderDialog(context, isShowLoader: false);

      String titleEN = "";
      String messageEN = "";
      String titleAR = "";
      String messageAR = "";

      switch (status) {
        case Status.ACTIVE:
          titleEN = "Accept Service";
          messageEN = "${service.titleEN} has been accepted";
          titleAR = "قبول خدمة";
          messageAR = "قبول خدمة ${service.titleAR}";
          break;
        case Status.Rejected:
          titleEN = "Rejected Service";
          messageEN = "${service.titleEN} has been rejected";
          titleAR = "رفض خدمة";
          messageAR = "رفض خدمة ${service.titleAR}";
          break;
        case Status.Disable:
          titleEN = "Disable Service";
          messageEN = "${service.titleEN} has been Disable by admin";
          titleAR = "تعطيل الخدمة";
          messageAR = "تعطيل الخدمة ${service.titleAR}";
          break;
          case Status.Deleted:
          titleEN = "delete Service";
          messageEN = "${service.titleEN} has been deleted by admin";
          titleAR = "حذف الخدمة";
          messageAR = "حذف الخدمة ${service.titleAR}";
          break;
      }

      this.addNotifications(uidUser: service.uidOwner, titleEN: titleEN, titleAR: titleAR, detailsEN: messageEN, detailsAR: messageAR);

    })
        .catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });

  }

  deleteService(context, { @required String idService }) async {

    showLoaderDialog(context);

    await serviceRef.doc(idService).delete().then((_) => {

    }).catchError((e) {

    });

    showLoaderDialog(context, isShowLoader: false);

  }

// Stream<List<ServiceModel>> getAllServices() {
//   return serviceRef.snapshots().map((QuerySnapshot snapshot) {
//     return snapshot.docs.map((doc) {
//     return ServiceModel.fromJson(doc.data());
//    }).toList();
//  });
//  }

  Stream<List<ServiceModel>> getServices({ @required Status status }) {
    return serviceRef.where("status", isEqualTo: status.index).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return ServiceModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<ServiceModel>> getMyServices() {
    return serviceRef.where("uid-owner", isEqualTo: auth.currentUser.uid).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return ServiceModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<ServiceModel> getServiceById({ @required String id }) {
    return serviceRef.doc(id).snapshots().map((DocumentSnapshot snapshot) {
      return ServiceModel.fromJson(snapshot.data());
    });
  }

  // TODO:- End Service

  // TODO:- Start Order

  addOrEditOrder(
      context,
      {
        String uid = "",
        File image,
        double lat,
        double lng,
        @required String ownerId,
        @required String serviceId,
        @required String details,
      }
      ) async {

    showLoaderDialog(context);

    String urlImage = "";

    if (image != null) {
      urlImage = await _uploadImage(folderName: "orders", imagePath: image.path);
    }

    String tempUid = (uid == null || uid == "") ? orderRef.doc().id : uid;

    this.addNotifications(uidUser: ownerId, titleEN: "Service Request", titleAR: "طلب خدمة", detailsEN: "A new service has been requested", detailsAR: "تم طلب خدمة جديدة");

    orderRef.doc(tempUid).set({
      "user-id": auth.currentUser.uid,
      "service-id": serviceId,
      "owner-id": ownerId,
      "url-image": urlImage,
      "details": details,
      "lat": lat == null ? 0 : lat,
      "lng": lng == null ? 0 : lng,
      "createdDate": DateTime.now().toString(),
      "status": Status.PENDING.index,
      "message-en": "",
      "message-ar": "",
      "uid": tempUid,
    })
        .then((value) {
      showLoaderDialog(context, isShowLoader: false);
      Navigator.of(context).pop();
    })
        .catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });

  }

  changeOrderStatus(
      context,
      {
        @required String uid,
        @required Status status,
        String messageEN = "",
        String messageAR = "",
      }
      ) async {

    showLoaderDialog(context);

    orderRef.doc(uid).update({
      "status": status.index,
      "message-en": messageEN,
      "message-ar": messageAR,
    })
        .then((value) {
      showLoaderDialog(context, isShowLoader: false);
    })
        .catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });

  }

  deleteOrder(context, { @required String idorder }) async {

    showLoaderDialog(context);

    await orderRef.doc(idorder).delete().then((_) => {

    }).catchError((e) {

    });

    showLoaderDialog(context, isShowLoader: false);

  }

  Stream<List<OrderModel>> getOrdersByStatus({ @required Status status }) {
    return orderRef.where("status", isEqualTo: status.index).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<OrderModel>> getAllOrders() {
    return orderRef.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<OrderModel>> getMyOrdersTech() {
    return orderRef.where("owner-id", isEqualTo: auth.currentUser.uid).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<OrderModel>> getMyOrders() {
    return orderRef.where("user-id", isEqualTo: auth.currentUser.uid).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<OrderModel> getOrderById({ @required String id }) {
    return orderRef.doc(id).snapshots().map((DocumentSnapshot snapshot) {
      return OrderModel.fromJson(snapshot.data());
    });
  }

  // TODO:- End Order

  // TODO:- Start Notifications

  addNotifications(
      {
        @required String uidUser,
        @required String titleEN,
        @required String titleAR,
        @required String detailsEN,
        @required String detailsAR,
      }
      ) async {

    String uid = notificationRef.doc().id;

    notificationRef.doc(uid).set({
      "user-id": uidUser,
      "title-en": titleEN,
      "title-ar": titleAR,
      "details-en": detailsEN,
      "details-ar": detailsAR,
      "createdDate": DateTime.now().toString(),
      "is-read": false,
      "uid": uid,
    })
        .then((value) {

    })
        .catchError((err) {

    });

  }

  setNotificationRead() async {
    List<NotificationModel> items = await getMyNotifications().first;
    for (var item in items) {
      if (item.userId == auth.currentUser.uid && !item.isRead) {
        notificationRef.doc(item.uid).update({
          "is-read": true,
        });
      }
    }
  }

  Stream<List<NotificationModel>> getMyNotifications() {
    return notificationRef.where("user-id", isEqualTo: auth.currentUser.uid).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationModel.fromJson(doc.data());
      }).toList();
    });
  }

  // TODO:- End Notifications

  // TODO:- Start Wallet

  updateWalletToUser(context,
      {@required String uid, @required double balance}) {
    showLoaderDialog(context);

    userRef.doc(uid).update({
      "balance": balance,
    }).then((value) {
      showLoaderDialog(context, isShowLoader: false);
    }).catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });
  }

  // TODO:- End Wallet

  Future<String> _uploadImage({ @required String folderName, @required String imagePath }) async {
    UploadTask uploadTask = storageRef.child('$folderName/${Uuid().v4()}').putFile(File(imagePath));
    String url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

}