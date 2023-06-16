import 'package:flutter/material.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/transaction/transaction_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/user/user_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/models/dashboard/dashboard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardRepository {

  final UserInteractor userInteractor = UserInteractor();
  final TransactionInteractor transactionInteractor = TransactionInteractor();

  Future<DashboardModel> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{
      final user = await userInteractor.get(prefs.getString('uid')!, prefs.getString('email'));  
      if(user == null){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
      }

      final latestTransactions = await transactionInteractor.getLatest(prefs.getString('uid')!);

      return DashboardModel(user: user, latestTransactions: latestTransactions);
    }catch(e){

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }

    return DashboardModel(user: null, latestTransactions: []);
  }

}