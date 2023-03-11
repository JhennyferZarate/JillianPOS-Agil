import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:jillianpos/User/controller/user_controller.dart';
import 'package:jillianpos/widgets/appbar_default.dart';
import 'package:jillianpos/widgets/menu_lateral.dart';
import 'package:jillianpos/util/constants.dart';
import 'package:jillianpos/Standby/standby_screen.dart';
import 'package:jillianpos/util/api.dart';
import 'components/users_body.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);
  static String routeName = "/users";

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> with WidgetsBindingObserver {
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.detached){
      API.logOutAPI(context);
      Navigator.pushNamedAndRemoveUntil(context, StandbyScreen.routeName, (route) => false);
    }
  }

  @override
  void dispose(){
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserController(context),
      child: WillPopScope(
        onWillPop: () => showExitPopup(context),
        child: const Scaffold(
          backgroundColor: kPrimaryColorLight,
          drawer: MenuLateral(),
          appBar: AppBarDefault(),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: BodyUsers()
              )
            ],
          ),
        ),
      ),
    );
  }
}
