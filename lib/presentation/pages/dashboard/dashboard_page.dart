import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paml_20190140086_ewallet/config/style.dart';
import 'package:paml_20190140086_ewallet/domain/models/dashboard/dashboard_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/profile_pics/profile_pic.dart';

import '../../../config/color.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _dashboardBloc = DashboardBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _dashboardBloc..add(GetDataDashboard()),
      child: Scaffold(
        body: Container(
          height: double.infinity,
          color: mainBackgroundWhite,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if(state is DashboardLoaded){
                  return RefreshIndicator(
                    onRefresh: () async => _dashboardBloc..add(GetDataDashboard()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ProfilePic(
                                backgroundColor: mainDarkBlue,
                                firstName: 'Test',
                                textColor: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.data.user!.name,
                                      style: displayNameStyle,
                                    ),
                                    Text(
                                      ' ${state.data.user!.email}',
                                      style: displayEmailStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _balanceCard(state.data.user!.balance),
                        _latestTransactionCard(state.data.latestTransactions)
                      ],
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ProfilePic(
                              backgroundColor: mainDarkBlue,
                              firstName: '-',
                              textColor: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    '-',
                                    style: displayNameStyle,
                                  ),
                                  Text(
                                    '-',
                                    style: displayEmailStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _balanceCard(0),
                      _latestTransactionCard([])
                    ],
                  );
                }
              },
            ),
          ),
        )
      ),
    );
  }

  Widget _balanceCard(int balance) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Colors.yellow, Colors.amber],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Balance',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.normal)),
              SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          NumberFormat.simpleCurrency(locale: 'id').format(balance),
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _latestTransactionCard(List<TransactionModel> transactions) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transaksi terakhir',
                style: TextStyle(color: mainDarkBlue),
              ),
              Column(
                children: transactions.map((e) {
                  return _transactionItemCard(e);
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _transactionItemCard(TransactionModel transaction) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      child: ListTile(
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(transaction.trxDate.millisecondsSinceEpoch)), 
                style: const TextStyle(color: Colors.grey)),
            TextSpan(
                text: " ${transaction.description}",
                style: transaction.isIncome ? const TextStyle(color: Colors.green) : const TextStyle(color: Colors.red)),
          ]),
        ),
        trailing: Text(
          NumberFormat.simpleCurrency(locale: 'id').format(transaction.amount),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )
      ),
    );
  }
}
