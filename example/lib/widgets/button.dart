// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends GetResponsiveView {
  CustomButton(
      {this.text,
      this.color,
      this.colorBack,
      this.fun,
      this.width,
      this.height,
      this.fontWeight,
      this.fontSize});
  FontWeight? fontWeight;
  double? fontSize;
  Color? color;
  Color? colorBack;
  String? text;
  double? width;
  double? height;
  Function()? fun;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 120,
      height: height ?? 60,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(colorBack ?? Colors.red)),
        child: Text(
          text ?? "",
          style: TextStyle(
              color: color ?? Colors.white,
              fontSize: fontSize,
              fontWeight: fontWeight),
        ),
        onPressed: fun,
      ),
    );
  }
}
