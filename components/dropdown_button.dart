import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:jillianpos/Login/controller/login_controller.dart';
import 'package:jillianpos/Models/user.dart';
import 'package:jillianpos/generated/l10n.dart';
import 'package:jillianpos/util/api.dart';
import 'package:jillianpos/util/constants.dart';
import 'package:jillianpos/util/local_data_controller.dart';
import 'dart:io';

class DropButton extends StatelessWidget {
  const DropButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Provider.of<LoginController>(context);

    return SizedBox(
      width: 500,
      child: DropdownSearch<Users>(
        dropdownBuilder: (context, user) {
          if (user == null) {
            return ListTile(title: Text(S.of(context).selectUserName.capitalize()));
          }
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: (user.photoPath == null || user.photoPath!.isEmpty)
                    ? const AssetImage('assets/img/defaultImage.png')
                    : FileImage(File((LocalDataController.localDirectory?.path ?? "") + constPathImages + user.photoPath!)) as ImageProvider,
                  fit: BoxFit.cover))),
            title: Text(user.userName ?? ""),
          );
        },
        popupProps: PopupProps.menu(
          showSearchBox: true,
          itemBuilder: (context, user, selected) {
            return ListTile(
              leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                          image: (user.photoPath == null || user.photoPath!.isEmpty)
                              ? const AssetImage('assets/img/defaultImage.png')
                              : FileImage(File((LocalDataController.localDirectory?.path ?? "") + constPathImages + user.photoPath!)) as ImageProvider,
                          fit: BoxFit.cover))),
              title: Text(user.userName ?? ""),
            );
          },
        ),
        dropdownButtonProps: const DropdownButtonProps(
          isVisible: true,
          icon: Icon(Icons.keyboard_arrow_down, color: kPrimaryColor, size: kDefaultText * 2.5),
        ),
        asyncItems: (_) => API.getUsersLoginAPI(context),
        onChanged: (Users? newUser) => loginController.changeUser(newUser),
        itemAsString: (item) => item.userName ?? "",
        dropdownDecoratorProps: DropDownDecoratorProps(        dropdownSearchDecoration: InputDecoration(
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(kPrimaryRadiusCircular)),
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          hintText: S.of(context).selectUserName.capitalize(),)
        ),
      ),
    );
  }
}
