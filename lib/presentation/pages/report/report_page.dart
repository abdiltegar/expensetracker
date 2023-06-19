import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paml_20190140086_ewallet/config/color.dart';
import 'package:paml_20190140086_ewallet/domain/helpers/date_formatter.dart';
import 'package:paml_20190140086_ewallet/domain/models/report/report_model.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/report/bloc/report_bloc.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _reportBloc = ReportBloc();
  final dateFormatter = DateFormatter();

  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();
  final _filterDateCtrl = TextEditingController();

  @override
  void initState() {
    var now = DateTime.now();
    _startDateCtrl.text = DateFormat('yyyy-MM-dd').format(now);
    _endDateCtrl.text = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 30)));;
    _filterDateCtrl.text = DateFormat('yyyy-MM-dd').format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainDarkBlue,
        title: const Text("Laporan"),
      ),
      body: BlocProvider(
        create: (context) => _reportBloc..add(GetDataReport(
          startDate: dateFormatter.dateFormatYMD(Timestamp.fromDate(DateTime.parse(_startDateCtrl.text))), 
          endDate: dateFormatter.dateFormatYMD(Timestamp.fromDate(DateTime.parse(_endDateCtrl.text))),
          filterDate: Timestamp.fromDate(DateTime.parse(_filterDateCtrl.text))
        )),
        child: RefreshIndicator(
          onRefresh: () async => _reportBloc..add(GetDataReport(
          startDate: dateFormatter.dateFormatYMD(Timestamp.fromDate(DateTime.parse(_startDateCtrl.text))), 
          endDate: dateFormatter.dateFormatYMD(Timestamp.fromDate(DateTime.parse(_endDateCtrl.text))),
          filterDate: Timestamp.fromDate(DateTime.parse(_filterDateCtrl.text))
        )),
          child: SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(color: mainBackgroundWhite),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _dailyReportCard()
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

  Widget _dailyReportCard(List<ReportModel> reports) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(0), top: Radius.circular(10)),
                  color: mainDarkBlue),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Transaksi terbaru',
                    style: TextStyle(
                        color: mainBackgroundWhite,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: reports.map((e) {
                  return _transactionItemCard(e);
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
