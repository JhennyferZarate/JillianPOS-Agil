import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

import 'package:jillianpos/Models/user.dart';
import 'package:jillianpos/User/components/new_user.dart';
import 'package:jillianpos/util/api.dart';
import 'package:jillianpos/util/constants.dart';
import 'package:jillianpos/widgets/button_principal.dart';
import 'package:jillianpos/generated/l10n.dart';
import 'package:jillianpos/util/local_data_controller.dart';
import 'dart:io';

class UserController with ChangeNotifier{
  UserController(BuildContext context) {
    futureUsers = API.getUsersAPI(context);
    // fetchUsers(context);
  }
  late Future<List<Users>> futureUsers;

  List<DataRow> _rows = [];
  List<DataRow> get rows => _rows;
  set rows(List<DataRow> rows){
    _rows = rows;
    notifyListeners();
  }

  Future<void> fetchUsers(BuildContext context) async {
    await EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);

    rows = await createRows(await futureUsers, context);

    EasyLoading.dismiss();
  }

  List<DataColumn> createColumns(BuildContext context) => [
    const DataColumn(label: Text("")),
    DataColumn(label: Text(S.of(context).name.capitalize(), style: const TextStyle(fontWeight: FontWeight.bold),)),
    DataColumn(label: Text(S.of(context).user.capitalize(), style: const TextStyle(fontWeight: FontWeight.bold),)),
    DataColumn(label: Text(S.of(context).birthdate.capitalize(), style: const TextStyle(fontWeight: FontWeight.bold),)),
    DataColumn(label: Text(S.of(context).rol.capitalize(), style: const TextStyle(fontWeight: FontWeight.bold),)),
    DataColumn(label: Text(S.of(context).email.capitalize(), style: const TextStyle(fontWeight: FontWeight.bold),)),
    DataColumn(label: Text(S.of(context).status.capitalize(), style: const TextStyle(fontWeight: FontWeight.bold),)),
    const DataColumn(label: Text(""))
  ];

  Future<List<DataRow>> createRows(List<Users> users, BuildContext context) async {
    return users.map<DataRow>((user) => DataRow(cells: [
              DataCell(
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: (user.photoPath!.isEmpty)
                          ? const AssetImage('assets/img/defaultImage.png')
                          : FileImage(File((LocalDataController.localDirectory?.path ?? "") + constPathImages + user.photoPath!)) as ImageProvider,
                      fit: BoxFit.cover
                    )
                  )
                )
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
                  child: Text(
                    user.firstName!.split(' ')[0] + " " + user.lastName!.split(' ')[0],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
                  child: Text(
                    user.userName ?? "",
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
                  child: Text(
                    DateFormat("MM-dd-yyyy").format(user.birthDate!),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
                  child: Text(
                    user.rol?.rolName ?? "",
                    overflow: TextOverflow.ellipsis,
                  )
                )
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
                  child: Text(
                    user.email ?? "",
                    overflow: TextOverflow.ellipsis
                  )
                )
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 50, maxWidth: 100),
                  child: Text(
                    user.status ? S.of(context).active.capitalize() : S.of(context).inactive.capitalize(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis
                  ),
                )
              ),
              DataCell(
                ButtonPrincipal(
                  text: S.of(context).edit,
                  actionTap: () {
                    Alert(
                      closeIcon: const Icon(Icons.close, size: 32),
                      context: context,
                      style: const AlertStyle(isButtonVisible: false),
                      content: NewUser(user: user),
                    ).show();
                  },
                  height: 40,
                  width: 80,
                  sizeText: 12,
                )
              ),
            ])).toList();
  }

  void searchUsers(String text, BuildContext context) async {
    List<Users> aux = [];
    List<Users> users = await futureUsers;

    if(text.isEmpty) {
      rows = await createRows(users, context);
    }
    else{
      aux = users.where((user) => user.userName!.toLowerCase().contains(text.toLowerCase())).toList();
      rows = await createRows(aux, context);
    }
  }
}