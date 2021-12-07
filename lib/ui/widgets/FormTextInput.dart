import 'package:app/utils/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormTextInput extends StatefulWidget {

  final BuildContext? context;
  final String? hint;
  final TextEditingController? controller;

  FormTextInput({
    Key? key,
    @required this.context,
    @required this.hint,
    @required this.controller
  }) : super(key: key);

  @override
  _FormTextInputState createState() => _FormTextInputState();

}

class _FormTextInputState extends State<FormTextInput> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textAlign: TextAlign.left,
      maxLines: 1,
      enableSuggestions: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: AppTheme.colorAccent),
        ),
        labelText: widget.hint,
      ),
      validator: (String? value) => value!.isEmpty ? "Please enter valid input." : null,
    );
  }

}
