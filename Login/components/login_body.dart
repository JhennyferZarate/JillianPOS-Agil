import 'package:flutter/material.dart';

import 'package:jillianpos/util/constants.dart';
import 'package:jillianpos/Login/components/dropdown_button.dart';
import 'package:jillianpos/Login/components/header_text.dart';
import 'package:jillianpos/Login/components/pin_row.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        HeaderText(),
        SizedBox(height: kDefaultSize),
        DropButton(),
        SizedBox(height: kDefaultSize * 2),
        PinRow(),
      ],
    );
  }
}
