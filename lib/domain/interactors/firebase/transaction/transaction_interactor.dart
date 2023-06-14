import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';

class TransactionInteractor {

  Future<List<TransactionModel>> getLatest(String userId) async {

    List<TransactionModel> res = [];

    try{
      debugPrint('-- going to get latest trx');
      
      final data = await FirebaseFirestore.instance.collection('transactions')
      .where('user_id', isEqualTo:userId)
      .limit(5).get();

      for(var item in data.docs){
        TransactionModel transaction = TransactionModel(
          amount: item.data()['amount'],
          description: item.data()['description'],
          id: item.id,
          isIncome: item.data()['is_income'],
          trxDate: item.data()['trx_date'],
          userId: item.data()['user_id']
        );

        res.add(transaction);
      }
    }on FirebaseException catch(e){
      debugPrint(' -- failed get latest transaction: ${e.message}');
    }

    return res;

  }
}