import 'package:intl/intl.dart';
import 'package:paml_20190140086_ewallet/domain/helpers/date_formatter.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/report/report_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/transaction/transaction_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/models/report/report_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeRepository {
  final TransactionInteractor transactionInteractor = TransactionInteractor();
  final ReportInteractor reportInteractor = ReportInteractor();

  Future<List<TransactionModel>> get () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return transactionInteractor.getByIsIncome(prefs.getString('uid')!, true);
  }

  Future add(TransactionModel data) async {
    DateFormatter dateFormatter = DateFormatter();

    final newIncome = <String, dynamic>{
      'user_id': data.userId,
      'amount': data.amount,
      'description': data.description,
      'is_income': data.isIncome,
      'trx_date': data.trxDate
    };
    
    var dailyReport = await reportInteractor.getByDate(data.userId, dateFormatter.dateFormatYMD(data.trxDate));
    if(dailyReport != null){ // if report at data.date is not empty , update the amount
      int updatedAmount = data.isIncome ? dailyReport.amount + data.amount : dailyReport.amount - data.amount;

      var updatedReport = <String, dynamic>{
        'user_id': data.userId,
        'date': dateFormatter.dateFormatYMD(data.trxDate),
        'amount': updatedAmount
      };

      await reportInteractor.update(dailyReport.id, updatedReport);
    } else {// if report at data.date is empty , add new report

      var newReport = <String, dynamic>{
        'user_id': data.userId,
        'date': dateFormatter.dateFormatYMD(data.trxDate),
        'amount': data.amount
      };

      await reportInteractor.add(newReport);
    }
    return await transactionInteractor.add(newIncome);
  }

  Future edit(TransactionModel data) async {
    DateFormatter dateFormatter = DateFormatter();

    final updatedIncome = <String, dynamic>{
      'user_id': data.userId,
      'amount': data.amount,
      'description': data.description,
      'is_income': data.isIncome,
      'trx_date': data.trxDate
    };

    var prevIncome = await transactionInteractor.getById(data.id);
    if(prevIncome == null){
      return false;
    }

    var dailyReport = await reportInteractor.getByDate(data.userId, dateFormatter.dateFormatYMD(data.trxDate));
    if(dailyReport != null){ // if report at data.date is not empty , update the amount
      int updatedAmount = data.isIncome ? (dailyReport.amount - prevIncome.amount) + data.amount : (dailyReport.amount - prevIncome.amount) - data.amount;

      var updatedReport = <String, dynamic>{
        'user_id': data.userId,
        'date': dateFormatter.dateFormatYMD(data.trxDate),
        'amount': updatedAmount
      };

      await reportInteractor.update(dailyReport.id, updatedReport);
    } else {// if report at data.date is empty , add new report

      var newReport = <String, dynamic>{
        'user_id': data.userId,
        'date': dateFormatter.dateFormatYMD(data.trxDate),
        'amount': data.amount
      };

      await reportInteractor.add(newReport);
    }
    
    return await transactionInteractor.update(data.id,updatedIncome);
  }

  Future delete(String id) async {
    DateFormatter dateFormatter = DateFormatter();

    var data = await transactionInteractor.getById(id);
    if(data == null){
      return false;
    }

    var dailyReport = await reportInteractor.getByDate(data.userId, dateFormatter.dateFormatYMD(data.trxDate));
    if(dailyReport != null){ // if report at data.date is not empty , update the amount
      int updatedAmount = data.isIncome ? dailyReport.amount - data.amount : dailyReport.amount +  data.amount;

      var updatedReport = <String, dynamic>{
        'user_id': data.userId,
        'date': dateFormatter.dateFormatYMD(data.trxDate),
        'amount': updatedAmount
      };

      await reportInteractor.update(dailyReport.id, updatedReport);
    }
    
    return await transactionInteractor.delete(data.id);
  }
}