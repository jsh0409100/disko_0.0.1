import 'package:flutter/material.dart';

class MakeAppointmentScreen extends StatefulWidget {
  const MakeAppointmentScreen({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<MakeAppointmentScreen> createState() => _MakeAppointmentScreenState();
}

class _MakeAppointmentScreenState extends State<MakeAppointmentScreen>
    with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
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
          firstDate: DateTime.now(),
          lastDate: DateTime(2024),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('약속잡기'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("약속 날짜"),
                  GestureDetector(
                    onTap: () {
                      _restorableDatePickerRouteFuture.present();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFF4EEFF),
                        ),
                        child: const Text('Open Date Picker ▼', style: TextStyle(fontWeight: ),)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Selected: ${newTime!.hour.toString()} : ${newTime.minute.toString()}'),
                ));
              },
              child: const Text('Open Time Picker ▼'),
            ),
          ],
        ),
      ),
    );
  }
}
