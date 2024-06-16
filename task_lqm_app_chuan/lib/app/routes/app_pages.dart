// ignore_for_file: prefer_const_constructors

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:task_lqm_app_chuan/app/modules/friends/bindings/friends_binding.dart';
import 'package:task_lqm_app_chuan/app/modules/friends/views/friends_view.dart';
import 'package:task_lqm_app_chuan/app/modules/home/bindings/home_binding.dart';
import 'package:task_lqm_app_chuan/app/modules/login/bindings/login_binding.dart';
import 'package:task_lqm_app_chuan/app/modules/login/views/login_view.dart';
import 'package:task_lqm_app_chuan/app/modules/home/views/home_view.dart';
import 'package:task_lqm_app_chuan/app/modules/profile/bindings/profile_binding.dart';
import 'package:task_lqm_app_chuan/app/modules/profile/views/profile_view.dart';
import 'package:task_lqm_app_chuan/app/modules/task/bindings/task_binding.dart';
import 'package:task_lqm_app_chuan/app/modules/task/views/task_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.HOME;
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(), // No error now
      binding: HomeBinding(),
      transition: Transition.upToDown,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FRIENDS,
      page: () => FriendsView(),
      binding: FriendsBinding(),
    ),
    GetPage(
      name: _Paths.TASK,
      page: () => TaskView(),
      binding: TaskBinding(),
    ),
  ];
}
