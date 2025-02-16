import 'package:Apka_kitchen/helper/route_helper.dart';
import 'package:Apka_kitchen/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(1, 40),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, RouteHelper.getInitialRoute());
      },
      child: RichText(text: TextSpan(children: [
        TextSpan(text: '${'continue_as'.tr} ', style: robotoRegular.copyWith(color: Colors.black)),
        TextSpan(text: 'guest'.tr, style: robotoMedium.copyWith(color: Colors.black)),
      ])),
    );
  }
}
