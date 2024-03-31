import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatelessWidget {
  final TextEditingController controller;
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  DateInputField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: const InputDecoration(labelText: 'Fecha'),
      keyboardType: TextInputType.datetime,
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (date != null) {
          controller.text = formatter.format(date);
        }
      },
    );
  }
}
