import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paml_20190140086_ewallet/domain/models/user/user_model.dart';

class UserInteractor {

  Future<UserModel?> get(String uid) async {
    UserModel? res;

    try{
      final data = await FirebaseFirestore.instance.collection('users')
      .where('uid', isEqualTo: uid)
      .limit(1).get();

      for (var item in data.docs){
        Map<String, dynamic> tempData = Map.from(item.data());
        final id = <String, String>{'id': item.id};
        tempData.addEntries(id.entries);

        res = UserModel.fromMap(tempData);
      }
    } on FirebaseException catch (e){
      debugPrint('error message : ${e.message}');
    }

    return res;
  } 

  Future add(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('users')
      .doc()
      .set(data);
    } on FirebaseException catch (e) {
      debugPrint('code : ${e.code}');
      debugPrint('message : ${e.message}');
    }
  }

  Future update(String id, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('users')
      .doc(id)
      .update(data);
    } on FirebaseException catch (e) {
      debugPrint('code : ${e.code}');
      debugPrint('message : ${e.message}');
    }
  }

  Future delete(String id) async {
    try {
      await FirebaseFirestore.instance.collection('users')
      .doc(id)
      .delete();
    } on FirebaseException catch (e) {
      debugPrint('code : ${e.code}');
      debugPrint('message : ${e.message}');
    }
  }

}