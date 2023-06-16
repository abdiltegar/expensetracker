import 'package:paml_20190140086_ewallet/domain/helpers/date_formatter.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/report/report_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/models/report/report_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportRepository{
  final ReportInteractor reportInteractor = ReportInteractor();

  Future<List<ReportModel>> getByRangeDate(String startDate, String endDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{

      return await reportInteractor.getByRangeDate(prefs.getString('uid')!, startDate, endDate); 
    }catch(e){

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }

    return [];
  }

}