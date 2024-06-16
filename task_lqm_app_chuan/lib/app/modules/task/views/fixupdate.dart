// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:date_time_picker/date_time_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:task_lqm_app_chuan/app/data/controller/auth_controller.dart';
// import 'package:task_lqm_app_chuan/app/utils/style/appColors.dart';
// import 'package:task_lqm_app_chuan/app/utils/widget/header.dart';
// import '../../../utils/widget/Sidebar.dart';
// import '../controllers/task_controller.dart';

// class TaskView extends GetView<TaskController> {
//   final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

//   final authCon = Get.find<AuthController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _drawerKey,
//       drawer: const SizedBox(width: 150, child: Sidebar()),
//       backgroundColor: Colors.blue[100],
//       body: SafeArea(
//         child: Row(
//           children: [
//             if (!context.isPhone)
//               const Expanded(
//                 flex: 2,
//                 child: Sidebar(),
//               ),
//             const SizedBox(),
//             Expanded(
//               flex: 15,
//               child: Column(
//                 children: [
//                   if (!context.isPhone)
//                     const header()
//                   else
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               _drawerKey.currentState!.openDrawer();
//                             },
//                             icon: const Icon(
//                               Icons.menu,
//                               color: AppColors.primaryText,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           const Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Task Management',
//                                 style:
//                                     TextStyle(fontSize: 20, color: Colors.grey),
//                               ),
//                               Text(
//                                 'Manage tasks easily',
//                                 style:
//                                     TextStyle(fontSize: 15, color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                           const Spacer(),
//                           const Icon(
//                             Ionicons.notifications,
//                             color: Colors.grey,
//                             size: 30,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(30),
//                             child: const CircleAvatar(
//                               backgroundColor: Colors.amber,
//                               radius: 25,
//                               foregroundImage: NetworkImage(
//                                   'https://images.pexels.com/photos/1084700/pexels-photo-1084700.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   Expanded(
//                     child: Container(
//                       padding: !context.isPhone
//                           ? const EdgeInsets.all(50)
//                           : const EdgeInsets.all(20),
//                       margin: !context.isPhone
//                           ? const EdgeInsets.all(10)
//                           : const EdgeInsets.all(0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: !context.isPhone
//                             ? BorderRadius.circular(50)
//                             : BorderRadius.circular(30),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'My Task',
//                             style: TextStyle(
//                               color: AppColors.primaryText,
//                               fontSize: 30,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Expanded(
//                             //stream user get task list
//                             child: StreamBuilder<
//                                     DocumentSnapshot<Map<String, dynamic>>>(
//                                 stream: authCon.streamUsers(
//                                     authCon.auth.currentUser!.email!),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return const Center(
//                                       child: CircularProgressIndicator(),
//                                     );
//                                   }
//                                   //get task id
//                                   var taskID = (snapshot.data!.data()
//                                           as Map<String, dynamic>)['task_id']
//                                       as List;
//                                   return ListView.builder(
//                                     itemCount: taskID.length,
//                                     clipBehavior: Clip.antiAlias,
//                                     shrinkWrap: true,
//                                     itemBuilder: (context, index) {
//                                       return StreamBuilder<
//                                               DocumentSnapshot<
//                                                   Map<String, dynamic>>>(
//                                           stream:
//                                               authCon.stramTask(taskID[index]),
//                                           builder: (context, snapshot2) {
//                                             if (snapshot2.connectionState ==
//                                                 ConnectionState.waiting) {
//                                               return const Center(
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               );
//                                             }
//                                             //data

//                                             var dataTask =
//                                                 snapshot2.data!.data();
//                                             var dataUserList =
//                                                 (snapshot2.data!.data() as Map<
//                                                         String,
//                                                         dynamic>)['assign_to']
//                                                     as List;
//                                             return GestureDetector(
//                                               onLongPress: () {
//                                                 Get.defaultDialog(
//                                                     title: dataTask?['title'] ??
//                                                         'No Title',
//                                                     content: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         TextButton.icon(
//                                                             onPressed: () {
//                                                               Get.back();
//                                                               controller
//                                                                   .titleController
//                                                                   .text = dataTask?[
//                                                                       'title'] ??
//                                                                   '';
//                                                               controller
//                                                                   .descriptionController
//                                                                   .text = dataTask?[
//                                                                       'description'] ??
//                                                                   '';
//                                                               controller
//                                                                   .dueDateController
//                                                                   .text = dataTask?[
//                                                                       'due_date'] ??
//                                                                   '';

//                                                               addEditTask(
//                                                                   context:
//                                                                       context,
//                                                                   type:
//                                                                       'Update',
//                                                                   docID: taskID[
//                                                                       index]);
//                                                             },
//                                                             icon: const Icon(
//                                                                 Ionicons
//                                                                     .pencil),
//                                                             label: const Text(
//                                                                 'Update')),
//                                                         TextButton.icon(
//                                                             onPressed: () {
//                                                               controller
//                                                                   .deleteTask(
//                                                                       taskID[
//                                                                           index]);
//                                                             },
//                                                             icon: const Icon(
//                                                                 Ionicons.trash),
//                                                             label: const Text(
//                                                                 'Delete')),
//                                                       ],
//                                                     ));
//                                                 // addEditTask(
//                                                 //     context: context,
//                                                 //     type: 'Update',
//                                                 //     docID:
//                                                 //         '2024-06-15T12:38:56.539');
//                                               },
//                                               child: Container(
//                                                 height: 200,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(20),
//                                                   color: AppColors.cardBG,
//                                                 ),
//                                                 margin:
//                                                     const EdgeInsets.all(10),
//                                                 padding:
//                                                     const EdgeInsets.all(20),
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Column(
//                                                       children: [
//                                                         Row(
//                                                           // mainAxisAlignment:
//                                                           //     MainAxisAlignment
//                                                           //         .spaceBetween,
//                                                           children: [
//                                                             SizedBox(
//                                                               height: 50,
//                                                               child: Expanded(
//                                                                 child: ListView
//                                                                     .builder(
//                                                                   padding:
//                                                                       EdgeInsets
//                                                                           .zero,
//                                                                   itemCount:
//                                                                       dataUserList
//                                                                           .length,
//                                                                   scrollDirection:
//                                                                       Axis.horizontal,
//                                                                   shrinkWrap:
//                                                                       true,
//                                                                   physics:
//                                                                       const ScrollPhysics(),
//                                                                   itemBuilder:
//                                                                       (context,
//                                                                           index2) {
//                                                                     return StreamBuilder<
//                                                                             DocumentSnapshot<
//                                                                                 Map<String,
//                                                                                     dynamic>>>(
//                                                                         stream: authCon.streamUsers(dataUserList[
//                                                                             index2]),
//                                                                         builder:
//                                                                             (context,
//                                                                                 snapshot3) {
//                                                                           if (snapshot3.connectionState ==
//                                                                               ConnectionState.waiting) {
//                                                                             return const Center(
//                                                                               child: CircularProgressIndicator(),
//                                                                             );
//                                                                           }
//                                                                           //data user photo
//                                                                           var dataUserImage = snapshot3
//                                                                               .data!
//                                                                               .data();

//                                                                           return ClipRRect(
//                                                                             borderRadius:
//                                                                                 BorderRadius.circular(25),
//                                                                             child:
//                                                                                 CircleAvatar(
//                                                                               backgroundColor: Colors.amber,
//                                                                               radius: 25,
//                                                                               foregroundImage: NetworkImage(dataUserImage!['photo']),
//                                                                             ),
//                                                                           );
//                                                                         });
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             const Spacer(),
//                                                             Container(
//                                                               height: 25,
//                                                               width: 80,
//                                                               color: AppColors
//                                                                   .primaryBG,
//                                                               child: Center(
//                                                                 child: Text(
//                                                                   '${dataTask?['status'] ?? 0}%',
//                                                                   style:
//                                                                       const TextStyle(
//                                                                     color: AppColors
//                                                                         .primaryText,
//                                                                     fontSize:
//                                                                         20,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const Spacer(),
//                                                     Container(
//                                                       height: 25,
//                                                       width: 80,
//                                                       color:
//                                                           AppColors.primaryBG,
//                                                       child: Center(
//                                                         child: Text(
//                                                           '${dataTask?['total_task_finished'] ?? 0} / ${dataTask?['total_task'] ?? 0}',
//                                                           style:
//                                                               const TextStyle(
//                                                             color: AppColors
//                                                                 .primaryText,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       dataTask?['title'] ??
//                                                           'No Title',
//                                                       style: const TextStyle(
//                                                         color: AppColors
//                                                             .primaryText,
//                                                         fontSize: 20,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       dataTask?[
//                                                               'description'] ??
//                                                           'No Description',
//                                                       style: const TextStyle(
//                                                         color: AppColors
//                                                             .primaryText,
//                                                         fontSize: 15,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           });
//                                     },
//                                   );
//                                 }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Align(
//         alignment: const Alignment(0.95, 0.95),
//         child: FloatingActionButton.extended(
//           onPressed: () {
//             addEditTask(context: context, type: 'Add', docID: '');
//           },
//           label: const Text('Add Task'),
//           icon: const Icon(Ionicons.add),
//         ),
//       ),
//     );
//   }

//   void addEditTask(
//       {required BuildContext context,
//       required String type,
//       required String docID}) {
//     Get.bottomSheet(
//       SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
//           margin: context.isPhone
//               ? EdgeInsets.zero
//               : const EdgeInsets.only(left: 150, right: 150),
//           // height: Get.height,
//           decoration: const BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//             color: Colors.white,
//           ),
//           child: Form(
//             key: controller.formKey,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             child: Column(
//               children: [
//                 Text(
//                   '$type Task',
//                   style: const TextStyle(
//                       color: AppColors.primaryText,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     hintText: 'Title',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   controller: controller.titleController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Cannot be empty';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   keyboardType: TextInputType.multiline,
//                   maxLines: 5,
//                   decoration: InputDecoration(
//                     hintText: 'Description',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   controller: controller.descriptionController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Cannot be empty';
//                     }
//                     return null;
//                   },
//                 ),
//                 DateTimePicker(
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime(2100),
//                   dateLabelText: 'Due Date',
//                   decoration: InputDecoration(
//                     hintText: 'Due Date',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   controller: controller.dueDateController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Cannot be empty';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 ConstrainedBox(
//                   constraints:
//                       BoxConstraints.tightFor(width: Get.width, height: 40),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       controller.saveUpdateTask(
//                         type: type.toString(),
//                         title: controller.titleController.text,
//                         description: controller.descriptionController.text,
//                         dueDate: controller.dueDateController.text,
//                         docId: docID.toString(),
//                       );
//                     },
//                     child: Text(type),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
