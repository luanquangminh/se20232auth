// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:task_lqm_app_chuan/app/data/controller/auth_controller.dart';
import 'package:task_lqm_app_chuan/app/utils/style/appColors.dart';
import 'package:task_lqm_app_chuan/app/utils/widget/processTask.dart';

// ignore: camel_case_types
class myTask extends StatelessWidget {
  final authCon = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
//stream user get task list
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: authCon.streamUsers(authCon.auth.currentUser!.email!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
//get task id
            var taskID = (snapshot.data!.data()
                as Map<String, dynamic>)['task_id'] as List;
            return ListView.builder(
              itemCount: taskID.length,
              clipBehavior: Clip.antiAlias,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: authCon.stramTask(taskID[index]),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
//data
                      var dataTask = snapshot2.data!.data();
                      var dataUserList = (snapshot2.data!.data()
                          as Map<String, dynamic>)['assign_to'] as List;
                      return GestureDetector(
                        onLongPress: () {
                          Get.defaultDialog(
                              title: dataTask['title'],
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                      onPressed: () {
                                        Get.back();
                                        authCon.titleController.text =
                                            dataTask?['title'] ?? '';
                                        authCon.descriptionController.text =
                                            dataTask?['description'] ?? '';
                                        authCon.dueDateController.text =
                                            dataTask?['due_date'] ?? '';

                                        addEditTask(
                                            context: context,
                                            type: 'Update',
                                            docID: taskID[index]);
                                      },
                                      icon: const Icon(Ionicons.pencil),
                                      label: const Text('Update')),
                                  // TextButton.icon(
                                  //     onPressed: () {
                                  //       Get.back();
                                  //       authCon.titleController.text =
                                  //           dataTask['title'];
                                  //       authCon.descriptionController.text =
                                  //           dataTask['description'];
                                  //       authCon.dueDateController.text =
                                  //           dataTask['due_date'];

                                  //       addEditTask(
                                  //           context: context,
                                  //           type: 'Update',
                                  //           docID: taskID[index]);
                                  //     },
                                  //     icon: const Icon(Ionicons.pencil),
                                  //     label: const Text('Update')),
                                  TextButton.icon(
                                      onPressed: () {
                                        authCon.deleteTask(taskID[index]);
                                      },
                                      icon: const Icon(Ionicons.trash),
                                      label: const Text('Delete')),
                                ],
                              ));
                        },
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.cardBG,
                          ),
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: Expanded(
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: dataUserList.length,
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (context, index2) {
                                              return StreamBuilder<
                                                      DocumentSnapshot<
                                                          Map<String,
                                                              dynamic>>>(
                                                  stream: authCon.streamUsers(
                                                      dataUserList[index2]),
                                                  builder:
                                                      (context, snapshot3) {
                                                    if (snapshot3
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                    //data user photo
                                                    var dataUserImage =
                                                        snapshot3.data!.data();

                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.amber,
                                                        radius: 25,
                                                        foregroundImage:
                                                            NetworkImage(
                                                                dataUserImage![
                                                                    'photo']),
                                                      ),
                                                    );
                                                  });
                                            },
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 25,
                                        width: 80,
                                        color: AppColors.primaryBG,
                                        child: Center(
                                          child: Text(
                                            '${dataTask!['status']}%',
                                            style: const TextStyle(
                                              color: AppColors.primaryText,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                height: 25,
                                width: 80,
                                color: AppColors.primaryBG,
                                child: Center(
                                  child: Text(
                                    '${dataTask['total_task_finished']} / ${dataTask['total_task']}',
                                    style: const TextStyle(
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                dataTask['title'],
                                style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                dataTask['description'],
                                style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            );
          }),
    );
  }
}
