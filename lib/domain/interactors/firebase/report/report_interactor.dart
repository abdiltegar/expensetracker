import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paml_20190140086_ewallet/domain/models/report/report_model.dart';

class ReportInteractor {

  Future<List<ReportModel>> get(String userId, int limit) async {
    List<ReportModel> res = [];

    try{
      final data = await FirebaseFirestore.instance.collection('daily_reports')
      .where('user_id', isEqualTo:userId)
      .limit(limit).get();

      for(var item in data.docs){
        ReportModel transaction = ReportModel(
          amount: item.data()['amount'],
          id: item.id,
          date: item.data()['date'],
          userId: item.data()['user_id']
        );

        res.add(transaction);
      }
    }on FirebaseException catch(e){
      debugPrint(' -- failed get last 30 days report: ${e.message}');
    }

    return res;
  }

  Future<ReportModel?> getByDate(String userId, String date) async {

    try{
      final data = await FirebaseFirestore.instance.collection('daily_reports')
      .where('user_id', isEqualTo:userId)
      .where('date', isEqualTo:date)
      .limit(1).get();

      if(data.docs.isNotEmpty){

        ReportModel res = ReportModel(
          id: data.docs[0].id, 
          userId: data.docs[0].data()['user_id'], 
          date: data.docs[0].data()['date'], 
          amount: data.docs[0].data()['amount']
        );
        debugPrint('-- res 5 -- ${res.toString()}');

        return res;      
      }
    }on FirebaseException catch(e){
      debugPrint(' -- failed get last 30 days report: ${e.message}');
    }

    return null;
  }

  Future add(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('daily_reports')
      .doc()
      .set(data);
    } on FirebaseException catch (e) {
      debugPrint('code : ${e.code}');
      debugPrint('message : ${e.message}');
    }
  }

  Future update(String id, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('daily_reports')
      .doc(id)
      .update(data);
    } on FirebaseException catch (e) {
      debugPrint('code : ${e.code}');
      debugPrint('message : ${e.message}');
    }
  }

  Future delete(String id) async {
    try {
      await FirebaseFirestore.instance.collection('daily_reports')
      .doc(id)
      .delete();
    } on FirebaseException catch (e) {
      debugPrint('code : ${e.code}');
      debugPrint('message : ${e.message}');
    }
  }

}