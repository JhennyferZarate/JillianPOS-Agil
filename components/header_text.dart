import 'package:flutter/material.dart';

import 'package:jillianpos/generated/l10n.dart';
import 'package:jillianpos/widgets/exit_button.dart';
import 'package:jillianpos/widgets/logo.dart';
import 'package:jillianpos/util/constants.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExitButton(pressedFunction: () => Navigator.pop(context)),
            Container(
              margin: const EdgeInsets.only(top: kDefaultSize * 2.5, right: kDefaultSize * 2.5),
              child: const Logo()
            ),
          ],
        ),
        const SizedBox(height: kDefaultSize),
        Text(
          S.of(context).enter.capitalize(),
          style: TextStyle(
              fontSize: kDefaultText * 2 * MediaQuery.of(context).textScaleFactor,
              color: kSecondaryColor),
        ),
        Text(
          S.of(context).userAndPass.capitalize(),
          style: TextStyle(
              fontSize: kDefaultText * 2 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor),
        ),
      ],
    );
  }
}
