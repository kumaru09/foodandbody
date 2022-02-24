import 'package:flutter/widgets.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/screens/initial_info/initial_info.dart';
import 'package:foodandbody/screens/login/login.dart';
import 'package:foodandbody/screens/main_screen/main_page.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [MainPage.page()];
    case AppStatus.initialize:
      return [InitialInfo.page()];
    case AppStatus.unauthenticated:
    default:
      return [Login.page()];
  }
}
