import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myTextFormField(
    {required TextEditingController controller,
    int? maxLines = 1,
      String Function(String?)? validator,
    required String hintText,
    required Widget prefixIcon,
    Widget? suffixIcon,
    TextInputType? keyboardType,
      required InputDecoration decoration}) {

  return Padding(
    padding: EdgeInsets.all(15),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black),
        ),
        errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.black),
        ),
        focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}
