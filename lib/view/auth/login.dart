import 'package:flutter/material.dart';
import 'package:paml_20190140086_ewallet/utilities/constant.dart';
import 'package:paml_20190140086_ewallet/view/auth/register.dart';
import 'package:paml_20190140086_ewallet/widget/input_email.dart';
import 'package:paml_20190140086_ewallet/widget/input_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final _formLoginKey = GlobalKey<FormState>();

  Widget _buildInputEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Email",style: labelStyle),
        const SizedBox(height: 10.0),
        InputEmail(prefixIcon: const Icon(Icons.email_outlined, color:Colors.white), labelText: "Enter your email", style: 1, controller: emailCtrl)
      ],
    );
  }

  Widget _buildInputPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Password",style: labelStyle),
        const SizedBox(height: 10.0),
        InputPassword(prefixIcon: const Icon(Icons.key_outlined, color:Colors.white), labelText: "Enter your password", style: 1, controller: passwordCtrl)
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (){
          if(_formLoginKey.currentState!.validate()){
            _formLoginKey.currentState!.save();
          }else{
            debugPrint("Not Validate");
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: Colors.white,
        ),
        child: const Text("Login", style: TextStyle(color: Color(0xFF398AE5)),),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF74AFF5),
                  Color(0xFF398AE5)
                ]
              )
            )
          ),
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 40,
                right: 40,
                top: 100,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Expense\nTracker",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Sign-In",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Form(
                    key: _formLoginKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildInputEmail(),
                        const SizedBox(height: 10),
                        _buildInputPassword(),
                        const SizedBox(height: 10),
                        _buildLoginBtn(),
                      ],
                    ),
                  ),
                  _buildSignupBtn(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}