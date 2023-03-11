import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart' as alert;

import 'package:jillianpos/Models/user.dart';
import 'package:jillianpos/util/local_data_controller.dart';
import 'package:jillianpos/util/api.dart';
import 'package:jillianpos/util/constants.dart';
import 'package:jillianpos/generated/l10n.dart';
import 'package:jillianpos/startDrawer/start_drawer_screen.dart';
import 'package:jillianpos/Standby/standby_screen.dart';

class LoginController with ChangeNotifier {
  int _countAttempts = 0;
  int get countAttempts => _countAttempts;
  set countAttempts(int attempt) {
    _countAttempts = attempt;
    notifyListeners();
  }

  Users? _currentUser;
  Users? get currentUser => _currentUser;
  set currentUser(Users? user) {
    _currentUser = user;
    notifyListeners();
  }

  final TextEditingController _currentPassword = TextEditingController();
  TextEditingController get currentPassword => _currentPassword;
  String get currentPasswordText => _currentPassword.text;
  set currentPasswordText(String text) {
    _currentPassword.text = text;
    notifyListeners();
  }

  void updatePassword(String password) {
    if (currentPasswordText.length != 6) currentPasswordText = (currentPasswordText + password);
  }

  void clearPassword() {
    if (currentPasswordText.isNotEmpty) currentPasswordText = currentPasswordText.substring(0, currentPasswordText.length - 1);
  }

  void changeUser(Users? newUser) {
    currentUser = newUser;
    currentPassword.clear();
    LocalDataController.actualUser = newUser;
    notifyListeners();
  }

  Future<Users> authenticationUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return await API.generateToken({
        "USERNAME": currentUser?.userName,
        "PASSWORD": currentPassword.text,
        "MAC": prefs.getString(macConstantPreference)
      });
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> onCompletePassword(BuildContext context) async {
    try {
      EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);
      Users user = await authenticationUser();
      EasyLoading.dismiss();

      if (user.status == true) {
        LocalDataController.actualUser = user;
        currentPasswordText = "";

        EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);
        await createPrimaryHost(context);
        EasyLoading.dismiss();

        await kDefaultAlert(context, S.of(context).credentialsCorrect.capitalize(), alertType: alert.AlertType.success).show();
        Navigator.pushNamed(context, StartDrawerScreen.routeName);
      }
      else {
        countAttempts++;
      }
    }
    catch (e) {
      EasyLoading.dismiss();
      countAttempts++;
      kDefaultAlert(context, e.toString(), alertType: alert.AlertType.error).show();
    }

    if (countAttempts >= 3) {
      await kDefaultAlert(context, S.of(context).exceededAttempt.capitalize(), alertType: alert.AlertType.error).show();
      Navigator.popUntil(context, ModalRoute.withName(StandbyScreen.routeName));
    }
  }

  Future<void> createPrimaryHost(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? urlPrimaryAPI = await API.getHostNameCompanyAPI(context);
    if (urlPrimaryAPI != null){
      urlPrimaryAPI = "http://$urlPrimaryAPI/API-JillianPOS";
      // urlPrimaryAPI = "http://192.168.31.240/API-JillianPOS";
      await prefs.setString(hostPrimaryNameConstant, urlPrimaryAPI);
    }
  }
}
