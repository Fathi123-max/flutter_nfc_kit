import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/widgets/button.dart';
import 'package:flutter_nfc_kit_example/widgets/text_container.dart';
import 'package:get/get.dart';

class Bottom_Sheet extends GetResponsiveView {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        height: 350,
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextContainer(
                  color: Colors.grey,
                  text: "Ready to scan",
                  height: 40,
                  width: 170,
                  fontSize: 23,
                ),
              ),
              Container(
                color: Colors.amber,
                height: 100,
                width: 400,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextContainer(
                  color: Colors.black,
                  text: "Please tap NFC tags",
                  height: 40,
                  width: 170,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                color: Colors.black,
                colorBack: Colors.grey,
                text: "Annulment",
                width: 300,
              )
            ],
          ),
        )),
        width: 400,
        // Your other widget contents go here
      ),
    );
  }
}
