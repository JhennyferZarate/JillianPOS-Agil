import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:jillianpos/Login/components/login_body.dart';
import 'package:jillianpos/Login/controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = "/login";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginController>(
      create: (context) => LoginController(),
      child: const Scaffold(
        body: SingleChildScrollView(
          child: LoginBody(),
        )
      ),
    );
  }
}
