import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_20190140086_ewallet/config/color.dart';
import 'package:paml_20190140086_ewallet/domain/models/transaction/transaction_model.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/outcome/bloc/outcome_bloc.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/inputs/input_date.dart';
import 'package:paml_20190140086_ewallet/presentation/widgets/inputs/input_text.dart';

class AddOutcomePage extends StatefulWidget {
  const AddOutcomePage({super.key});

  @override
  State<AddOutcomePage> createState() => _AddOutcomePageState();
}

class _AddOutcomePageState extends State<AddOutcomePage> {
  final _outcomeBloc = OutcomeBloc();

  final _trxDateCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  final _formAddKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _outcomeBloc,
      child: BlocListener<OutcomeBloc, OutcomeState>(
        listener: (context, state) {
          if (state is OutcomeAdded) {
            Navigator.pop(context, ['refresh']);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: mainDarkBlue,
              title: const Text("Tambah Pengeluaran"),
            ),
            body: BlocBuilder<OutcomeBloc, OutcomeState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formAddKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _buildInputTrxDate(),
                          const SizedBox(
                            height: 10,
                          ),
                          _buildInputAmount(),
                          const SizedBox(
                            height: 10,
                          ),
                          _buildInputDescription(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formAddKey.currentState!
                                          .validate()) {
                                        _formAddKey.currentState!.save();
                                        debugPrint("Validate");

                                        try {
                                          String dateStringTrx =
                                              _trxDateCtrl.text;
                                          DateTime dateTimeTrx =
                                              DateTime.parse(dateStringTrx);
                                          debugPrint("Validate 1");

                                          var data = TransactionModel(
                                            id: "",
                                            amount: int.parse(_amountCtrl.text),
                                            description: _descriptionCtrl.text,
                                            isIncome: false,
                                            trxDate:
                                                Timestamp.fromDate(dateTimeTrx),
                                            userId: "",
                                          );

                                          debugPrint(data.toString());

                                          _outcomeBloc
                                              .add(AddOutcome(data: data));

                                          debugPrint("Validate 2");
                                        } catch (e) {
                                          debugPrint(e.toString());
                                        }
                                      } else {
                                        debugPrint("Not Validate");
                                      }
                                    },
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )),
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
        InputDate(
            prefixIcon: const Icon(CupertinoIcons.calendar),
            validatorMessage: "Tanggal tidak boleh kosong",
            labelText: "Masukkan tanggal",
            keyboardType: TextInputType.datetime,
            controller: _trxDateCtrl)
      ],
    );
  }
}