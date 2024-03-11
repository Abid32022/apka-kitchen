import 'package:Apka_kitchen/util/app_colors.dart';
import 'package:Apka_kitchen/util/dimensions.dart';
import 'package:Apka_kitchen/util/images.dart';
import 'package:Apka_kitchen/util/my_size.dart';
import 'package:Apka_kitchen/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataScreen extends StatelessWidget {
  final bool isCart;
  final String text;
  NoDataScreen({@required this.text, this.isCart = false});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          SizedBox(height:isCart?0: MySize.scaleFactorHeight*200,),
      Image.asset(
        isCart ? Images.empty_cart : Images.empty_box,
        width: MediaQuery.of(context).size.height*0.22, height: MediaQuery.of(context).size.height*0.22,
      ),
      SizedBox(height: MediaQuery.of(context).size.height*0.03),

      Text(
        isCart ? 'cart_is_empty'.tr : text,
        style: robotoMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Colors.black),
        textAlign: TextAlign.center,
      ),

    ]);
  }
}
