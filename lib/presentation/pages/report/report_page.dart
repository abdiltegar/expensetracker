import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paml_20190140086_ewallet/config/color.dart';
import 'package:paml_20190140086_ewallet/config/style.dart';
import 'package:paml_20190140086_ewallet/domain/helpers/date_formatter.dart';
import 'package:paml_20190140086_ewallet/domain/models/report/report_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/report/bloc/report_bloc.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/inputs/input_date.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/inputs/input_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  final now = DateTime.now();

  @override
  void initState() {
    _startDateCtrl.text = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 7)));
    _endDateCtrl.text = DateFormat('yyyy-MM-dd').format(now);
    _filterDateCtrl.text = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 7)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: mainDarkBlue,
        title: const Text("Laporan"),
      ),
      body: BlocProvider(
        create: (context) => refreshData(),
        child: RefreshIndicator(
          onRefresh: () async => refreshData(),
          child: SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(color: mainBackgroundWhite),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<ReportBloc, ReportState>(
                  builder: (context, state) {
                    if(state is ReportLoaded){
                      int max = state.data.maxIncome > state.data.maxOutcome ? state.data.maxIncome : state.data.maxOutcome;
                      debugPrint("report loaded, data : ${state.data.toString()}");
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _dailyReportCard(state.data.dailyReports, max),
                            const SizedBox(height: 10,),
                            _transactionCard(state.data.transactions),
                            const SizedBox(height: 10,)
                          ],
                        ),
                      );
                    }else{
                      return Column(
                        children: [
                          _dailyReportCard([], 0),
                          const SizedBox(height: 10,),
                          _transactionCard([])
                        ],
                      );
                    }
                  },
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

  Widget _dailyReportCard(List<ReportModel> reports, int max) {
    debugPrint('debug reports : ${reports.toString()}');
    final _tooltip = TooltipBehavior();

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
                    'Perbandingan Pemasukan dan Pengeluaran',
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
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Form(
                      child: Row(
                        children: [
                          Expanded(child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text("Mulai"),
                                const SizedBox(height: 5,),
                                Expanded(
                                  child: InputDate(validatorMessage: "-", labelText: "-", keyboardType: TextInputType.datetime, controller: _startDateCtrl, style: 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text("Sampai"),
                                const SizedBox(height: 5,),
                                Expanded(
                                  child: InputDate(validatorMessage: "-", labelText: "-", keyboardType: TextInputType.datetime, controller: _endDateCtrl, style: 2),
                                ),
                              ],
                            )
                          ),
                          const SizedBox(width: 10,),
                          IconButton(
                            onPressed: () async => refreshData(), 
                            icon: const Icon(CupertinoIcons.search_circle_fill),
                            color: mainDarkBlue,
                          )
                        ],
                      ),
                    ),
                  ),
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(minimum: 0, maximum: max.toDouble(), interval: 500000),
                    tooltipBehavior: _tooltip,
                    series: <ChartSeries<ReportModel, String>>[
                      ColumnSeries<ReportModel, String>(
                          dataSource: reports,
                          xValueMapper: (ReportModel data, _) => data.date,
                          yValueMapper: (ReportModel data, _) => data.income,
                          name: 'Pemasukan',
                          gradient: gradientGreenStyle
                      ),
                      ColumnSeries<ReportModel, String>(
                          dataSource: reports,
                          xValueMapper: (ReportModel data, _) => data.date,
                          yValueMapper: (ReportModel data, _) => data.outcome,
                          name: 'Pengeluaran',
                          gradient: gradientRedStyle
                      )
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 10, width: 10, decoration: const BoxDecoration(gradient: gradientGreenStyle),),
                      const Text(" Pemasukan "),
                      const SizedBox(width:20),
                      Container(height: 10, width: 10, decoration: const BoxDecoration(gradient: gradientRedStyle),),
                      const Text(" Pengeluaran "),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionCard(List<TransactionModel> transactions){
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
                    'Rekap transaksi per hari',
                    style: TextStyle(
                        color: mainBackgroundWhite,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Form(
                  child: Row(
                    children: [
                      Expanded(child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Transaksi pada "),
                            const SizedBox(height: 5,),
                            Expanded(
                              child: InputDate(validatorMessage: "-", labelText: "-", keyboardType: TextInputType.datetime, controller: _filterDateCtrl, style: 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10,),
                      IconButton(
                        onPressed: () async => refreshData(), 
                        icon: const Icon(CupertinoIcons.search_circle_fill),
                        color: mainDarkBlue,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: transactions.map((e) {
                  return _transactionItemCard(e);
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  ReportBloc refreshData(){
    debugPrint("refreshing");
    return _reportBloc
      ..add(GetDataReport(
          startDate: dateFormatter.dateFormatYMD(
              Timestamp.fromDate(DateTime.parse(_startDateCtrl.text))),
          endDate: dateFormatter.dateFormatYMD(
              Timestamp.fromDate(DateTime.parse(_endDateCtrl.text))),
          filterDate:
              Timestamp.fromDate(DateTime.parse(_filterDateCtrl.text))));
  }

  Widget _transactionItemCard(TransactionModel transaction) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      child: ListTile(
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: dateFormatter.dateFormatYMD(transaction.trxDate), 
              style: const TextStyle(color: Colors.grey)
            ),
            TextSpan(
              text: "\n${transaction.description}",
              style: const TextStyle(color: Colors.black),
            )
          ]),
        ),
        trailing: Text(
          transaction.isIncome ? NumberFormat.simpleCurrency(locale: 'id').format(transaction.amount) : '- ${NumberFormat.simpleCurrency(locale: 'id').format(transaction.amount)}',
          style: transaction.isIncome ? incomeNumberStyle : outcomeNumberStyle,
        )
      ),
    );
  }
}
