import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:task_lqm_app_chuan/app/data/controller/auth_controller.dart';
import 'package:task_lqm_app_chuan/app/modules/profile/controllers/profile_controller.dart';
import 'package:task_lqm_app_chuan/app/utils/style/appColors.dart';
import 'package:task_lqm_app_chuan/app/utils/widget/UpcomingTask.dart';
import 'package:task_lqm_app_chuan/app/utils/widget/myFriend.dart';
import 'package:task_lqm_app_chuan/app/utils/widget/myTask.dart';
import 'package:task_lqm_app_chuan/app/utils/widget/header.dart';
import '../../../utils/widget/Sidebar.dart';

class HomeView extends GetView<ProfileController> {
  final authCon = Get.find<AuthController>();

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: const SizedBox(width: 150, child: Sidebar()),
      backgroundColor: Colors.blue[100], // Example replacement
      body: Row(
        children: [
          !context.isPhone
              ? const Expanded(
                  flex: 2,
                  child: Sidebar(),
                )
              : const SizedBox(),
          Expanded(
            flex: 15,
            child: Column(
              children: [
                !context.isPhone
                    ? const header()
                    : Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _drawerKey.currentState!.openDrawer();
                              },
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.grey,
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Task Management',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey),
                                ),
                                Text(
                                  'Manage tasks easily',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Ionicons.notifications,
                              color: Colors.grey,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 25,
                                foregroundImage: NetworkImage(
                                    authCon.auth.currentUser!.photoURL!),
                              ),
                            ),
                          ],
                        ),
                      ),
                Expanded(
                  child: Container(
                    padding: !context.isPhone
                        ? const EdgeInsets.all(50)
                        : const EdgeInsets.all(20),
                    margin: !context.isPhone
                        ? const EdgeInsets.all(10)
                        : const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: !context.isPhone
                          ? BorderRadius.circular(50)
                          : BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Task',
                          style: TextStyle(
                              color: AppColors.primaryText, fontSize: 30),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //my task
                        SizedBox(
                          height: Get.height * 0.3,
                          child: myTask(),
                        ),
                        !context.isPhone
                            ? Expanded(
                                child: Row(
                                  children: [
                                    UpcomingTask(),
                                    MyFriend(),
                                  ],
                                ),
                              )
                            : const UpcomingTask()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
