import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  late final String id;
  late final String userId;
  late final int amount;
  late final bool isIncome;
  late final Timestamp trxDate;
  late final String description;
}