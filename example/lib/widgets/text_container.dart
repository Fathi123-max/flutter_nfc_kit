// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextContainer extends GetResponsiveView {
  double? fontSize;

  Color? color;
  double? height;
  String? text;
  double? width;
  FontWeight? fontWeight;
  TextContainer({
    this.fontSize,
    this.color,
    this.height,
    this.text,
    this.width,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 50,
      // color: Colors.amber,
      height: height ?? 20,
      child: Text(
        text ?? "none",
        style: TextStyle(
            color: color ?? Colors.white,
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.normal),
      ),
    );
  }
}
