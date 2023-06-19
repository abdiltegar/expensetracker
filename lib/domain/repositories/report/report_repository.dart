import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paml_20190140086_ewallet/domain/helpers/date_formatter.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/report/report_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/transaction/transaction_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/models/report/report_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/report/report_view_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportRepository{
  final ReportInteractor reportInteractor = ReportInteractor();
  final TransactionInteractor transactionInteractor = TransactionInteractor();

  Future<ReportViewModel> getByRangeDate(String startDate, String endDate, Timestamp filterDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{
      var reports = await reportInteractor.getByRangeDate(prefs.getString('uid')!, startDate, endDate);
      var transactions = await transactionInteractor.getByDate(prefs.getString('uid')!, filterDate);

      return  
    }catch(e){

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }

    return [];
  }

}