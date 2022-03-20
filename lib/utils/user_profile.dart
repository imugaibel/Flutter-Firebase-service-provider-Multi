import 'package:shared_preferences/shared_preferences.dart';
import '../enums/language.dart';
import '../model/user-model.dart';

class UserProfile {
  static final UserProfile shared = UserProfile();

  Future<Language?> getLanguage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? languageIndex = prefs.get('language') as int?;
      return languageIndex == null ? null : Language.values[languageIndex];
    } catch(e) {
      return null;
    }
  }

  setLanguage({ required Language language }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('language', language.index);
    } catch(e) {
      return null;

    }
  }

  Future<UserModel?> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.get('user') == ""
          ? null
          : userModelFromJson(prefs.get('user').toString());
    } catch (e) {
      return null;
    }
  }

  setUser({UserModel? user}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user == null ? "" : userModelToJson(user));
    } catch (e) {
      return null;
    }
  }
}
