// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:paml_20190140086_ewallet/domain/models/report/report_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';

class ReportViewModel {
  late final List<ReportModel> dailyReports;
  late final List<TransactionModel> transactions;
  ReportViewModel({
    required this.dailyReports,
    required this.transactions,
  });

  ReportViewModel copyWith({
    List<ReportModel>? dailyReports,
    List<TransactionModel>? transactions,
  }) {
    return ReportViewModel(
      dailyReports: dailyReports ?? this.dailyReports,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dailyReports': dailyReports.map((x) => x.toMap()).toList(),
      'transactions': transactions.map((x) => x.toMap()).toList(),
    };
  }

  factory ReportViewModel.fromMap(Map<String, dynamic> map) {
    return ReportViewModel(
      dailyReports: List<ReportModel>.from((map['dailyReports'] as List<int>).map<ReportModel>((x) => ReportModel.fromMap(x as Map<String,dynamic>),),),
      transactions: List<TransactionModel>.from((map['transactions'] as List<int>).map<TransactionModel>((x) => TransactionModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportViewModel.fromJson(String source) => ReportViewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReportViewModel(dailyReports: $dailyReports, transactions: $transactions)';

  @override
  bool operator ==(covariant ReportViewModel other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.dailyReports, dailyReports) &&
      listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode => dailyReports.hashCode ^ transactions.hashCode;
}
