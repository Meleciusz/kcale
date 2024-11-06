import 'package:flutter/widgets.dart';
import '../../../home/home.dart';
import '../../login/view/login_page.dart';
import '../bloc/app_bloc.dart';

/*
 *Main description:
This file contains the routes for the main page.
 */
List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
){
  switch(state){
    case AppStatus.authenticated:
      return[Home.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}