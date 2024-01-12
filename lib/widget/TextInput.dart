import 'package:flutter/material.dart';

class TextInput extends TextFormField {
  TextInput(
      {required String label,
        required bool obscureText,
        required TextEditingController controller,
        required Icon icon})
      : super(
      controller: controller,
      cursorColor: const Color(0xFF000000),
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF999999)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF000000))),
        prefixIconColor: const Color(0xFF999999),
        filled: true,
        fillColor: const Color(0xFFDDDDDD),
      ),
      obscureText: obscureText);
}
