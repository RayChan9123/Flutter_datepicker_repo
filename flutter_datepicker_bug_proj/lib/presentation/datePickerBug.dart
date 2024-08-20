import 'package:flutter/material.dart';

class DatePickerExample extends StatefulWidget {
  const DatePickerExample({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

//created two vars to store the start_date and end_date
DateTime start_date = DateTime.now();
DateTime end_date = DateTime.now();

/// RestorationProperty objects can be used because of RestorationMixin.
class _DatePickerExampleState extends State<DatePickerExample>
    with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;

  //use the var in the
  final RestorableDateTime _selectedDate = RestorableDateTime(start_date);
  final RestorableDateTime _selectedEndDate = RestorableDateTime(end_date);

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  late final RestorableRouteFuture<DateTime?>
      _restorableEndDatePickerRouteFuture = RestorableRouteFuture<DateTime?>(
    onComplete: _selectEndDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _endDatePickerRoute,
        arguments: _selectedEndDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          //forbidden date chosen that are later than the end date
          lastDate: end_date,
        );
      },
    );
  }

  @pragma('vm:entry-point')
  static Route<DateTime> _endDatePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'end_date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          //forbidden date chosen that are before than the start date
          firstDate: start_date,
          lastDate: DateTime(2033),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
    registerForRestoration(_selectedEndDate, 'selected_end_date');
    registerForRestoration(
        _restorableEndDatePickerRouteFuture, 'end_date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        start_date = newSelectedDate;
        _dateController.text =
            '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  void _selectEndDate(DateTime? newSelectedEndDate) {
    if (newSelectedEndDate != null) {
      setState(() {
        _selectedEndDate.value = newSelectedEndDate;
        end_date = newSelectedEndDate;
        _endDateController.text =
            '${_selectedEndDate.value.day}/${_selectedEndDate.value.month}/${_selectedEndDate.value.year}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedEndDate.value.day}/${_selectedEndDate.value.month}/${_selectedEndDate.value.year}'),
        ));
      });
    }
  }

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text =
        '${start_date.day}/${start_date.month}/${start_date.year}';
    _endDateController.text =
        '${end_date.day}/${end_date.month}/${end_date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Selected Date',
              border: OutlineInputBorder(),
            ),
          ),
          Center(
            child: OutlinedButton(
              onPressed: () {
                _restorableDatePickerRouteFuture.present();
              },
              child: const Text('Open Date Picker'),
            ),
          ),
          TextFormField(
            controller: _endDateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Selected End Date',
              border: OutlineInputBorder(),
            ),
          ),
          Center(
            child: OutlinedButton(
              onPressed: () {
                _restorableEndDatePickerRouteFuture.present();
              },
              child: const Text('Open End Date Picker'),
            ),
          ),
        ],
      ),
    );
  }
}
