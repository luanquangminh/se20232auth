import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:task_lqm_app_chuan/app/routes/app_pages.dart';

// ignore: camel_case_types
class header extends StatelessWidget {
  const header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Management',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              Text(
                'Manage tasks easily',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(flex: 1),
          Expanded(
            flex: 1,
            child: TextField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(left: 40, right: 10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  hintText: 'Search'),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Ionicons.notifications,
            color: Colors.grey,
            size: 30,
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.defaultDialog(
                title: 'Sign Out',
                content: const Text('Are you sure you want to Sign Out?'),
                cancel: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                confirm: ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.LOGIN),
                  child: const Text(
                    'Sign Out',
                    // style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }, // This was missing, causing the syntax error
            child: const Row(
              children: [
                Text('Sign Out'),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Ionicons.log_out_outline,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
