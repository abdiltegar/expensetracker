import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_20190140086_ewallet/config/color.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/income/bloc/income_bloc.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/inputs/input_text.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _incomeBloc = IncomeBloc();

  final _trxDateCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  final _formAddKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _incomeBloc,
      child: BlocListener<IncomeBloc, IncomeState>(
        listener: (context, state) {
          if (state is IncomeAdded) {
            var snackBar = const SnackBar(content: Text('Data Berhasil Disimpan'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context, ['refresh']);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: mainDarkBlue,
            title: const Text("Tambah Pemasukan"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formAddKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildInputTrxDate(),
                    const SizedBox(height: 10,),
                    _buildInputAmount(),
                    const SizedBox(height: 10,),
                    _buildInputDescription(),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: (){
                                _incomeBloc.add(AddIncome(data: TransactionModel(
                                  id: "",
                                  amount: 0,
                                  description: "",
                                  isIncome: true,
                                  trxDate: Timestamp,
                                  userId: "",
                                )));
                              },
                              child: const Text("Save", style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _buildInputDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Deskripsi"),
        const SizedBox(height: 10.0),
        InputText(
          validatorMessage: "Deskripsi tidak boleh kosong",
          labelText: "exp : Gaji bulanan",
          style: 2,
          keyboardType: TextInputType.multiline,
          controller: _descriptionCtrl)
      ],
    );
  }

  Widget _buildInputAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Nominal"),
        const SizedBox(height: 10.0),
        InputText(
          validatorMessage: "Nominal tidak boleh kosong",
          labelText: "exp : 1000000",
          style: 2,
          keyboardType: TextInputType.number,
          controller: _amountCtrl)
      ],
    );
  }

  Widget _buildInputTrxDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Tanggal"),
        const SizedBox(height: 10.0),
        InputText(
          validatorMessage: "Tanggal tidak boleh kosong",
          labelText: "Masukkan tanggal",
          style: 2,
          keyboardType: TextInputType.datetime,
          controller: _trxDateCtrl)
      ],
    );
  }
}