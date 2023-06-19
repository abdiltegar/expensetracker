import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/transaction/transaction_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionRepository {
  final transactionInteractor = TransactionInteractor();
  
  Future<List<TransactionModel>> getByDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{
      return await transactionInteractor.getByDate(prefs.getString('uid')!, Timestamp.fromDate(DateTime.parse(date))); 
    }catch(e){

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }

    return [];
  }
}