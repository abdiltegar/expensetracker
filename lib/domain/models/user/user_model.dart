// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String uid;
  final String name;
  final double balance;
  UserModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.balance,
  });

  UserModel copyWith({
    String? id,
    String? uid,
    String? name,
    double? balance,
  }) {
    return UserModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'name': name,
      'balance': balance,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      name: map['name'] as String,
      balance: map['balance'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, uid: $uid, name: $name, balance: $balance)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.uid == uid &&
      other.name == name &&
      other.balance == balance;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      uid.hashCode ^
      name.hashCode ^
      balance.hashCode;
  }
}