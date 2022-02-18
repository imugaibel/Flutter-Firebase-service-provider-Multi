import 'package:flutter/cupertino.dart';
import 'package:omni/enums/language.dart';
import 'package:omni/model/user-model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {

  static final UserProfile shared = UserProfile();

  Future<Language> getLanguage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int languageIndex = prefs.get('language');
      return languageIndex == null ? null : Language.values[languageIndex];
    } catch(e) {
      return null;
    }
  }

  setLanguage({ @required Language language }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('language', language == null ? null : language.index);
    } catch(e) {

    }
  }

  Future<UserModel> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.get('user') == "" ? null : userModelFromJson(prefs.get('user'));
    } catch(e) {
      return null;
    }
  }

  setUser({ @required UserModel user }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user == null ? "" : userModelToJson(user));
    } catch(e) {

    }
  }

}