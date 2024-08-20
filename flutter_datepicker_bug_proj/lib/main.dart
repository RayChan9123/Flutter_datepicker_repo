import 'package:flutter/material.dart';
import 'package:flutter_datepicker_bug_proj/presentation/datePickerBug.dart';
//import 'package:flutter_application_2/presentation/datePickerExample.dart';

/// Flutter code sample for [showDatePicker].

void main() => runApp(const DatePickerApp());

class DatePickerApp extends StatelessWidget {
  const DatePickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      restorationScopeId: 'app',
      home: DatePickerExample(restorationId: 'main'),
    );
  }
}
