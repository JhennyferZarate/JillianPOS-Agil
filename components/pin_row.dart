import 'package:flutter/material.dart';
import 'package:jillianpos/util/local_data_controller.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:jillianpos/util/constants.dart';
import 'package:jillianpos/Login/controller/login_controller.dart';

class PinRow extends StatelessWidget {
  const PinRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Provider.of<LoginController>(context);

    return Column(
      children: [
        SizedBox(
          width: 300.0,
          child: PinCodeTextField(
            keyboardType: TextInputType.none,
            enablePinAutofill: false,
            readOnly: true,
            appContext: context,
            length: 6,
            obscuringWidget: Container(
              width: 25.0,
              height: 25.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: kPrimaryColor),
            ),
            animationType: AnimationType.scale,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.circle,
              borderRadius: BorderRadius.circular(50.0),
              fieldHeight: 25.0,
              fieldWidth: 25.0,
              selectedColor: kPrimaryColor,
              activeColor: kPrimaryColor,
              inactiveColor: kPrimaryColor,
            ),
            controller: loginController.currentPassword,
            onChanged: (value) {/*keyboard controller*/},
            onCompleted: (String text) => loginController.onCompletePassword(context)
          ),
        ),
        SizedBox(
          width: 500,
          child: NumericKeyboard(
            onKeyboardTap: (String value) => loginController.updatePassword(value),
            textColor: kPrimaryColor,
            leftButtonFn: () => loginController.clearPassword(),
            leftIcon: const Icon(
              FontAwesomeIcons.solidCopyright,
              color: kPrimaryColor,
              size: kDefaultText * 2.5,
            ),
          ),
        ),
        const SizedBox(height: kDefaultSize),
        Text("HOST: ${LocalDataController.actualURLAPI}")
      ],
    );
  }
}
