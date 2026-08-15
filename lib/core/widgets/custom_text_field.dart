import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      this.maxLines = 1,
      required this.labelText,
      required this.hintText,
      this.onChanged});
  final TextEditingController controller;
  final int maxLines;
  final String labelText;
  final String hintText;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      validator: (v) {
        if (v!.isEmpty) {
          return 'لا يمكن ان يكون الحقل فارغ';
        }
        return null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            top: 21.h,
            bottom: 20.h,
          ),
          filled: true,
          fillColor: Colors.amber,
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 350.w))),
    );
  }
}
