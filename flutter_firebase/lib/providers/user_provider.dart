import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/db/dbhelper.dart';
import 'package:flutter_firebase/models/userModel.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> userList = [];
  Future<void> addUser(UserModel userModel) => DBHelper.addUser(userModel);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserByUid(String uid) =>
      DBHelper.getUserByUid(uid);

  Future<void> updatProfile(String uid, Map<String, dynamic> map) =>
      DBHelper.updateProfile(uid, map);

  Future<String> updateImage(XFile xFile) async {
    final imgeName = DateTime.now().millisecondsSinceEpoch.toString();
    final photoRef = FirebaseStorage.instance.ref().child('picture/$imgeName');
    final uploadTask = photoRef.putFile(File(xFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
}
