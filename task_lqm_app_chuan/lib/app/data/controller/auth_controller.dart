import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_lqm_app_chuan/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? _userCredential;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController searchFriendsController,
      titleController,
      descriptionController,
      dueDateController;

  @override
  void onInit() {
    super.onInit();
    searchFriendsController = TextEditingController();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    dueDateController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    // searchFriendsController.dispose();
  }

  @override
  void onClose() {
    super.onClose();
    searchFriendsController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print(googleUser!.email);

    // Once signed in, return the UserCredential
    await auth
        .signInWithCredential(credential)
        .then((value) => _userCredential = value);

    //firebase

    CollectionReference users = firestore.collection('users');
    final cekUser = await users.doc(googleUser.email).get();
    if (!cekUser.exists) {
      users.doc(googleUser.email).set({
        'uid': _userCredential!.user!.uid,
        'name': googleUser.displayName,
        'email': googleUser.email,
        'photo': googleUser.photoUrl,
        'createdAt': _userCredential!.user!.metadata.creationTime.toString(),
        'lastLoginAt':
            _userCredential!.user!.metadata.lastSignInTime.toString(),
        // 'list_cari':[]
      }).then((value) async {
        String temp = '';
        try {
          for (var i = 0; i < googleUser.displayName!.length; i++) {
            temp = temp + googleUser.displayName![i];
            await users.doc(googleUser.email).set({
              'list_cari': FieldValue.arrayUnion([temp.toUpperCase()])
            }, SetOptions(merge: true));
          }
        } catch (e) {
          print(e);
        }
      });
    } else {
      users.doc(googleUser.email).update({
        'lastLoginAt':
            _userCredential!.user!.metadata.lastSignInTime.toString(),
      });
    }
    Get.offAllNamed(Routes.HOME);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  var kataCari = [].obs;
  var hasiPencarion = [].obs;
  void searchFriends(String keyword) async {
    CollectionReference users = firestore.collection('users');

    if (keyword.isNotEmpty) {
      final hasilQuery = await users
          .where('list_cari', arrayContains: keyword.toUpperCase())
          .get();
      if (hasilQuery.docs.isNotEmpty) {
        for (var i = 0; i < hasilQuery.docs.length; i++) {
          kataCari.add(hasilQuery.docs[i].data() as Map<String, dynamic>);
        }
      }
      if (kataCari.isNotEmpty) {
        hasiPencarion.value = [];
        kataCari.forEach((element) {
          print(element);
          hasiPencarion.add(element);
        });
        kataCari.clear();
      }
    } else {
      kataCari.value = [];
      hasiPencarion.value = [];
    }
    kataCari.refresh();
    hasiPencarion.refresh();
  }

  void addFriends(String _emailFriends) async {
    CollectionReference friends = firestore.collection('friends');
    final cekFriends = await friends.doc(auth.currentUser!.email).get();

    //cek data
    if (cekFriends.data() == null) {
      await friends.doc(auth.currentUser!.email).set({
        'emailMe': auth.currentUser!.email,
        'emailFriends': [_emailFriends],
      }).whenComplete(
          () => Get.snackbar("Friends", "Friends successfully added"));
    } else {
      await friends.doc(auth.currentUser!.email).set({
        'emailFriends': FieldValue.arrayUnion([_emailFriends]),
      }, SetOptions(merge: true)).whenComplete(
          () => Get.snackbar("Friends", "Friends successfully added"));
    }
    kataCari.clear();
    hasiPencarion.clear();
    searchFriendsController.dispose();
    Get.back();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamFriends() {
    return firestore
        .collection('friends')
        .doc(auth.currentUser!.email)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUsers(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPeople() async {
    CollectionReference friendsCollect = firestore.collection('friends');
    final cekFriends = await friendsCollect.doc(auth.currentUser!.email).get();
    var listFriends =
        (cekFriends.data() as Map<String, dynamic>)['emailFriends'] as List;
    QuerySnapshot<Map<String, dynamic>> hasil = await firestore
        .collection('users')
        .where('email', whereNotIn: listFriends)
        .get();

    return hasil;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> stramTask(String taskID) {
    return firestore.collection('task').doc(taskID).snapshots();
  }

  void saveUpdateTask({
    String? title,
    String? description,
    String? dueDate,
    String? docId,
    String? type,
    required String docID,
  }) async {
    print(title);
    print(description);
    print(dueDate);
    print(docId);
    print(type);

    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    CollectionReference taskColl = firestore.collection('task');
    CollectionReference userColl = firestore.collection('users');
    var taskID = DateTime.now().toIso8601String();

    if (type == 'Add') {
      await taskColl.doc(taskID).set({
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'status': '0',
        'total_task': 0,
        'total_task_finished': 0,
        'task_detail': [],
        'assign_to': [auth.currentUser!.email],
        'created_by': [auth.currentUser!.email],
      }).whenComplete(() async {
        await userColl.doc(auth.currentUser!.email).set({
          'task_id': FieldValue.arrayUnion([taskID])
        }, SetOptions(merge: true));
        Get.back();
        Get.snackbar('Task', 'Sucessfully $type');
      }).catchError((error) {
        Get.snackbar('Task', 'Error $type');
      });
    } else {
      await taskColl.doc(docId).update({
        'title': title,
        'description': description,
        'dueDate': dueDate,
      }).whenComplete(() async {
        // await userColl.doc(authCon.auth.currentUser!.email).set({
        //   'task_id': FieldValue.arrayUnion([taskID])
        // }, SetOptions(merge: true));
        Get.back();
        Get.snackbar('Task', 'Sucessfully $type');
      }).catchError((error) {
        Get.snackbar('Task', 'Error $type');
      });
    }
  }

  void deleteTask(String taskID) async {
    CollectionReference taskColl = firestore.collection('task');
    CollectionReference userColl = firestore.collection('users');

    await taskColl.doc(taskID).delete().whenComplete(() async {
      await userColl.doc(auth.currentUser!.email).set({
        'task_id': FieldValue.arrayRemove([taskID])
      }, SetOptions(merge: true));
      Get.back();
      Get.snackbar('Task', 'Sucessfully Delete');
    });
  }
}
