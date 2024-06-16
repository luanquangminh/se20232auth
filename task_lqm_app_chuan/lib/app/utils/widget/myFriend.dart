// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:task_lqm_app_chuan/app/data/controller/auth_controller.dart';
import 'package:task_lqm_app_chuan/app/routes/app_pages.dart';
import 'package:task_lqm_app_chuan/app/utils/style/appColors.dart';

class MyFriend extends StatelessWidget {
  final authCon = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'My friends',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 30,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.FRIENDS),
                  child: Text(
                    'More',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 20,
                    ),
                  ),
                ),
                Icon(
                  Ionicons.chevron_forward,
                  color: AppColors.primaryText,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: authCon.streamFriends(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var myFriends = (snapshot.data!.data()
                    as Map<String, dynamic>)['emailFriends'] as List;
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: myFriends.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: !context.isPhone ? 2 : 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                        stream: authCon.streamUsers(myFriends[index]),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          var data = snapshot2.data!.data();

                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image(
                                  image: NetworkImage(data!['photo']),
                                  height: 115,
                                  width: 115,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                data['name'],
                                style: const TextStyle(
                                    color: AppColors.primaryText),
                              )
                            ],
                          );
                        });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
