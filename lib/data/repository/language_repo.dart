import 'package:Apka_kitchen/data/model/response/language_model.dart';
import 'package:Apka_kitchen/util/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
