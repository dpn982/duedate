import 'package:flutter/material.dart';

class CustomSwitchFormField extends StatefulWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;
  final bool visible;

  const CustomSwitchFormField(
      {Key key, this.label, this.value, this.onChanged, this.visible: true})
      : super(key: key);

  @override
  _CustomSwitchFormFieldState createState() => _CustomSwitchFormFieldState();
}

class _CustomSwitchFormFieldState extends State<CustomSwitchFormField> {
  final EdgeInsetsGeometry fieldPadding = EdgeInsets.only(bottom: 15.0);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Padding(
        padding: fieldPadding,
        child: SwitchListTile(
          title: Text(
            widget.label,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          activeTrackColor: Colors.green,
          inactiveTrackColor: Colors.red,
          value: widget.value,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
