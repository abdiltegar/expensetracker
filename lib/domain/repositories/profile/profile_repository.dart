import 'package:flutter/foundation.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/user/user_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/models/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final userInteractor = UserInteractor();

  Future<UserModel> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user = UserModel(
      id: '', 
      uid: '', 
      name: '', 
      email: '', 
      balance: 0
    );

    final userRes = await userInteractor.get(prefs.getString('uid')!, prefs.getString('email')!);
    debugPrint(' -- Get User Result : ${userRes.toString()}');

    if(userRes != null){
      user = UserModel(id: userRes.id, uid: userRes.uid, name: userRes.name, email: userRes.email, balance: userRes.balance);
    }

    return user;
  }
}