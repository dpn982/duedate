import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final String initialValue;
  final String prefixText;
  final TextInputType inputType;
  final Function(String) validator;
  final Function(String) onSaved;
  final Function onTap;
  final TextEditingController controller;
  final bool visible;
  final int maxLines;

  const CustomTextFormField(
      {Key key,
      this.label,
      this.initialValue,
      this.prefixText: "",
      this.inputType: TextInputType.text,
      this.validator,
      this.onSaved,
      this.onTap,
      this.controller,
      this.visible: true,
      this.maxLines: 1})
      : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final OutlineInputBorder outlineBorder = OutlineInputBorder(
    borderSide: BorderSide(
      width: 1.0,
      color: Colors.black,
    ),
  );
  final EdgeInsetsGeometry fieldPadding = EdgeInsets.only(bottom: 15.0);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Padding(
        padding: fieldPadding,
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.inputType,
          initialValue: widget.initialValue,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            prefixText: widget.prefixText,
            labelText: widget.label,
            labelStyle: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
            fillColor: Colors.white,
            focusColor: Colors.white,
            filled: false,
            enabledBorder: outlineBorder,
            focusedBorder: outlineBorder,
            border: outlineBorder,
          ),
          onTap: widget.onTap,
          validator: widget.validator,
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}
