import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  const InputText({super.key, required this.validatorMessage, required this.prefixIcon, required this.labelText, required this.controller});

  final String validatorMessage;
  final Icon prefixIcon;
  final String labelText;
  final TextEditingController controller;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) => value.toString().isEmpty ? widget.validatorMessage : null,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide.none
        ),
        prefixIcon: widget.prefixIcon,
        hintText: widget.labelText,
        fillColor: Colors.grey.shade200,
        filled: true
      ),
      controller: widget.controller,
    );
  }
}