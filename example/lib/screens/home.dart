import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/widgets/bottom_sheet.dart';
import 'package:flutter_nfc_kit_example/widgets/button.dart';
import 'package:flutter_nfc_kit_example/widgets/dialog.dart';
import 'package:flutter_nfc_kit_example/widgets/text_container.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 200,
                        color: Colors.amber,
                        height: 50,
                        child: Text(""),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 200,
                        color: Colors.amber,
                        height: 150,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                          color: Colors.white,
                          colorBack: Colors.blue,
                          text: "Read",
                          fun: () {
                            showModalBottomSheet(
                              context: context,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              builder: (context) {
                                return Bottom_Sheet();
                              },
                            );
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                          color: Colors.white,
                          colorBack: Colors.redAccent,
                          text: "Write",
                          fun: () {
                            Get.dialog(Dialog(
                                child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: DialogWidget(),
                            )));
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      TextContainer(
                          width: 200,
                          // color: Colors.amber,
                          height: 20,
                          color: Colors.white,
                          text: "See instruction For Use"),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 200,
                        color: Colors.amber,
                        height: 150,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextContainer(
                        width: 200,
                        // color: Colors.amber,
                        height: 20,
                        color: Colors.white,
                        text: "You need Help:",
                      ),
                      TextContainer(
                        width: 200,
                        // color: Colors.amber,
                        height: 20,
                        color: Colors.white,
                        text: "Contact us Here:",
                      ),
                    ]),
              ),
            )),
      ),
    );
  }
}
