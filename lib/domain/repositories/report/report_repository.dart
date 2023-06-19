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
  final dateFormatter = DateFormatter();

  Future<ReportViewModel> getByRangeDate(String startDate, String endDate, Timestamp filterDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{
      var transactions = await transactionInteractor.getByDate(prefs.getString('uid')!, filterDate);

      List<ReportModel> dailyReports = [];
      final daysToGenerate = DateTime.parse(endDate).difference(DateTime.parse(startDate)).inDays;
      
      for(int i = 0; i <= daysToGenerate; i++){
        var thisDate = dateFormatter.dateFormatYMD(Timestamp.fromDate(DateTime.parse(startDate).add(Duration(days: i))));
        var resReportInteractor = await reportInteractor.getByDate(prefs.getString('uid')!, thisDate );

        if(resReportInteractor != null){
          ReportModel report = ReportModel(
            id: resReportInteractor.id, 
            date: resReportInteractor.date, 
            amount: resReportInteractor.amount, 
            income: resReportInteractor.income, 
            outcome: resReportInteractor.outcome, 
            userId: resReportInteractor.userId
          );
          dailyReports.add(report);
        }else{
          ReportModel report = ReportModel(
            id: "", 
            date: thisDate, 
            amount: 0, 
            income: 0, 
            outcome: 0, 
            userId: prefs.getString('uid')!
          );
          dailyReports.add(report);
        }
      }

      return ReportViewModel(dailyReports: dailyReports, transactions: transactions);
    }catch(e){

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }

    return ReportViewModel(dailyReports: [], transactions: []);
  }

}