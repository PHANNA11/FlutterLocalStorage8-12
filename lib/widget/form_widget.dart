import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  TextFormWidget(
      {super.key,
      this.controller,
      this.hindText,
      this.maxLine,
      this.textColor,
      this.onChanged});
  String? hindText;
  TextEditingController? controller;
  int? maxLine;
  Color? textColor;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(color: textColor),
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: hindText ?? 'Enter text',
        ),
        onChanged: onChanged,
        maxLines: maxLine ?? 1,
      ),
    );
  }
}
