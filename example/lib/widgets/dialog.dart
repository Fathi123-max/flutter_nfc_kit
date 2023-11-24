import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/widgets/button.dart';
import 'package:flutter_nfc_kit_example/widgets/text_container.dart';
import 'package:get/get.dart';

class DialogWidget extends GetResponsiveView {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        // width: 500,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextContainer(
                color: Colors.black,
                fontSize: 20,
                height: 30,
                width: 250,
                text: "Change the Link",
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none),
                    filled: true,
                    hintStyle: TextStyle(height: 3.7, color: Colors.grey),
                    hintText: "URL",
                    fillColor: Colors.white70,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CustomButton(
                      height: 50,
                      width: 140,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      colorBack: Colors.black,
                      text: "Refresh Link",
                    ),
                    Spacer(),
                    CustomButton(
                      height: 50,
                      width: 77,
                      fontSize: 9,
                      text: "Cancel",
                      fontWeight: FontWeight.bold,
                      colorBack: Colors.black,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
