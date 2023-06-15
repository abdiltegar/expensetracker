import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_20190140086_ewallet/config/style.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/auth/bloc/auth_bloc.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/auth/login_page.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/home_page.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/buttons/button_screen.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/inputs/input_email.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/inputs/input_password.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/inputs/input_repassword.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/inputs/input_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthBloc _authBloc = AuthBloc();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _rePasswordCtrl = TextEditingController();

  final _formRegisterKey = GlobalKey<FormState>();

  Widget _buildInputName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Name", style: labelStyle),
        const SizedBox(height: 10.0),
        InputText(
            prefixIcon:
                const Icon(Icons.person_outline_rounded, color: Colors.white),
            validatorMessage: "Nama tidak boleh kosong",
            labelText: "Masukkan nama anda",
            style: 1,
            keyboardType: TextInputType.text,
            controller: _nameCtrl)
      ],
    );
  }

  Widget _buildInputEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Email", style: labelStyle),
        const SizedBox(height: 10.0),
        InputEmail(
            prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
            labelText: "Masukkan email",
            style: 1,
            controller: _emailCtrl)
      ],
    );
  }

  Widget _buildInputPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Password", style: labelStyle),
        const SizedBox(height: 10.0),
        InputPassword(
            prefixIcon: const Icon(Icons.key_outlined, color: Colors.white),
            labelText: "Masukkan password",
            style: 1,
            controller: _passwordCtrl)
      ],
    );
  }

  Widget _buildInputRePassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Re-Password", style: labelStyle),
        const SizedBox(height: 10.0),
        InputRePassword(
          prefixIcon: const Icon(Icons.key_outlined, color: Colors.white),
          labelText: "Konfirmasi password",
          style: 1,
          controller: _rePasswordCtrl,
          passwordController: _passwordCtrl,
        )
      ],
    );
  }

  Widget _buildSigninBtn() {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage())),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Sudah punya akun? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Masuk',
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
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is AuthRegisterLoaded) {
            if (state.response.status) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Pendaftaran berhasil'),
                    content: const Text(''),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                            (route) => false);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                }
              );
              
            }
          }
        },
        child: Scaffold(
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF74AFF5), Color(0xFF398AE5)]))),
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
                            "Daftar",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Form(
                            key: _formRegisterKey,
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                _buildInputName(),
                                const SizedBox(height: 10),
                                _buildInputEmail(),
                                const SizedBox(height: 10),
                                _buildInputPassword(),
                                const SizedBox(height: 10),
                                _buildInputRePassword(),
                                const SizedBox(height: 10),
                                ButtonScreen(
                                  isLoading: (state is AuthLoginLoading) ? true : false,
                                  text: 'DAFTAR',
                                  action: () {
                                    if (_formRegisterKey.currentState!.validate()) {
                                      _formRegisterKey.currentState!.save();

                                      _authBloc.add(AuthRegister(
                                        email: _emailCtrl.text, password: _passwordCtrl.text, name: _nameCtrl.text
                                      ));
                                    } else {
                                      debugPrint("Not Validate");
                                    }
                                  }
                                ),
                              ],
                            ),
                          ),
                          _buildSigninBtn(),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
