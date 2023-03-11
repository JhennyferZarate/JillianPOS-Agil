import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:jillianpos/Models/user.dart';
import 'package:jillianpos/User/controller/user_controller.dart';
import 'package:jillianpos/generated/l10n.dart';
import 'package:jillianpos/util/constants.dart';
import 'package:jillianpos/widgets/button_principal.dart';
import 'new_user.dart';

class BodyUsers extends StatelessWidget {
  const BodyUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Padding(
      padding: const EdgeInsets.all(2 * kDefaultSize),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).users.capitalize(),
                style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white, fontWeight: FontWeight.bold)
              ),
              const SizedBox(width: kDefaultSize),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(kPrimaryRadiusCircular)),
                    suffixIcon: const Icon(Icons.search, color: kPrimaryColor,),
                    hintText: S.of(context).search.capitalize(),
                    fillColor: Colors.white,
                    filled: true),
                  onChanged: (value) => userController.searchUsers(value, context),
                ),
              ),
              const SizedBox(width: kDefaultSize),
              ButtonPrincipal(
                text: S.of(context).search,
                actionTap: () => userController.fetchUsers(context),
                height: 55,
                width: 200,
                sizeText: 16,
                switchColor: true,
              ),
              const SizedBox(width: kDefaultSize),
              ButtonPrincipal(
                text: S.of(context).newUserButton,
                actionTap: () async {
                  await EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);

                  userController.rows = [];
                  Alert(
                    closeIcon: const Icon(Icons.close, size: 32),
                    context: context,
                    style: const AlertStyle(isButtonVisible: false),
                    content: const NewUser(),
                  ).show();

                  EasyLoading.dismiss();
                },
                height: 55,
                width: 200,
                sizeText: 16,
                switchColor: true,
              )
            ],
          ),
          const SizedBox(height: kDefaultSize,),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: kPrimaryBorderCircular),
              padding: const EdgeInsets.all(kDefaultSize),
              child: SingleChildScrollView(
                child: FutureBuilder<List<Users>>(
                  future: userController.futureUsers,
                  builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
                    if(snapshot.hasError){
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.error.toString(), textAlign: TextAlign.center,),
                        )
                      );
                    }
                    else if(snapshot.hasData) {
                      if (snapshot.data!.isEmpty) return Center(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(S.of(context).noData.capitalize())));

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 30,
                          columns: userController.createColumns(context),
                          rows: userController.rows,
                        ),
                      );
                    }
                    else {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}
