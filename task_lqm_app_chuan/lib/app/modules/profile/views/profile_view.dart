import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:task_lqm_app_chuan/app/data/controller/auth_controller.dart';
import 'package:task_lqm_app_chuan/app/utils/widget/myTask.dart';
import 'package:task_lqm_app_chuan/app/utils/widget/header.dart';
import 'package:task_lqm_app_chuan/app/utils/widget/profileW.dart';
import '../../../utils/style/appColors.dart';
import '../../../utils/widget/Sidebar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final authConn = Get.find<AuthController>();

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: const SizedBox(width: 150, child: Sidebar()),
      backgroundColor: Colors.blue[100], // Example replacement
      body: SafeArea(
        child: Row(
          children: [
            if (!context.isPhone)
              const Expanded(
                flex: 2,
                child: Sidebar(),
              )
            else
              const SizedBox(),
            Expanded(
              flex: 15,
              child: Column(
                children: [
                  if (!context.isPhone)
                    const header()
                  else
                    Container(
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
                          const SizedBox(
                            width: 15,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Task Management',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                              Text(
                                'Manage tasks easily',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.defaultDialog(
                                title: 'Sign Out',
                                content: const Text(
                                    'Are you sure you want to Sign Out?'),
                                cancel: ElevatedButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Cancel'),
                                ),
                                confirm: ElevatedButton(
                                  onPressed: () => authConn.logout(),
                                  child: const Text(
                                    'Sign Out',
                                    // style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Text('Sign Out',
                                    style: TextStyle(
                                        color: AppColors.primaryText,
                                        fontSize: 16)),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Ionicons.log_out_outline,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  //content
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileW(),
                          const Text(
                            'My Task',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: SizedBox(
                                height: 200,
                                child: myTask(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
