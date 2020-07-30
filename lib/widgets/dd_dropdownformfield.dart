import 'package:flutter/material.dart';

class CustomDropdownFormField<T> extends StatefulWidget {
  final String label;
  final String hint;
  final T value;
  final ValueChanged<T> onChanged;
  final bool visible;
  final List<DropdownMenuItem<T>> items;

  const CustomDropdownFormField(
      {Key key,
      this.label,
      this.hint: "",
      this.value,
      this.onChanged,
      this.visible: true,
      this.items})
      : super(key: key);

  @override
  _CustomDropdownFormFieldState createState() =>
      _CustomDropdownFormFieldState<T>();
}

class _CustomDropdownFormFieldState<T> extends State<CustomDropdownFormField<T>> {
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
        child: DropdownButtonFormField<T>(
          hint: Text(widget.hint),
          items: widget.items,
          decoration: InputDecoration(
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
          value: widget.value,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
