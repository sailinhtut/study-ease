import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TestScreen extends StatelessWidget {
  TestScreen({super.key});

  final letterControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Test Screen")),
      body: ListView(children: [
        AppButton(
          text: "Date Picker",
          onTap: () {
            showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1));
          },
        )
      ]),
    );
  }
}
