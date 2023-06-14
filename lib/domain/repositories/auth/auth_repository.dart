import 'package:flutter/material.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/auth/auth_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/interactors/firebase/user/user_interactor.dart';
import 'package:paml_20190140086_ewallet/domain/models/auth/auth_login_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/auth/auth_register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final authInteractor = AuthInteractor();
  final userInteractor = UserInteractor();

  Future<AuthLoginModel> login(String email, String password) async {
    final loginRes = await authInteractor.login(email, password);
    debugPrint(' -- Login Result : ${loginRes.toString()}');
    if (loginRes.status) {
      debugPrint(' -- Going to get user -- ');

      final userRes = await userInteractor.get(loginRes.data!.uid, email);
      debugPrint(' -- Get User Result : ${userRes.toString()}');

      if(userRes != null){
        setPreferences(loginRes.data!.uid, loginRes.data!.email, userRes.name);
      }else{
        return AuthLoginModel(status: false, message: 'user tidak ditemukan!', data: null);
      }

    }
    return loginRes;
  }

  Future<AuthRegisterModel> register(String email, String password, String name) async {
    final registerRes = await authInteractor.register(email, password);
    if (registerRes.status) {

      final newUser = <String, dynamic>{
        'uid': registerRes.data!.uid,
        'name': name,
        'balance': 0
      };

      await userInteractor.add(newUser);

      setPreferences(registerRes.data!.uid, registerRes.data!.email, name);
    }

    debugPrint(' -- Register Result : ${registerRes.toString()}');
    return registerRes;
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return true;
  }

  void setPreferences(String uid, String? email, String? name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
    prefs.setString('email', email!);
    prefs.setString('name', name!);
  }
}