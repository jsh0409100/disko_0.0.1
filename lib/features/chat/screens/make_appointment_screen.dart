import 'package:flutter/material.dart';

import 'notification_example_screen.dart';

class MakeAppointmentScreen extends StatefulWidget {
  const MakeAppointmentScreen({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<MakeAppointmentScreen> createState() => _MakeAppointmentScreenState();
}

class _MakeAppointmentScreenState extends State<MakeAppointmentScreen>
    with RestorationMixin {
  void moveToNotificationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationExamplePage(),
        fullscreenDialog: true,
      ),
    );
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "약속 날짜",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                GestureDetector(
                  onTap: () {
                    _restorableDatePickerRouteFuture.present();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF4EEFF),
                      ),
                      padding: const EdgeInsets.fromLTRB(13, 6, 3, 6),
                      width: 109,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '날짜 선택',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Divider(color: Color(0xFFECECEC), thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "약속 시간",
                  style: Theme.of(context).textTheme.headlineMedium,
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
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF4EEFF),
                      ),
                      padding: const EdgeInsets.fromLTRB(13, 6, 3, 6),
                      width: 109,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '시간 선택',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Divider(color: Color(0xFFECECEC), thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "약속 전 나에게 알림",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                GestureDetector(
                  onTap: () async {},
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF4EEFF),
                      ),
                      padding: const EdgeInsets.fromLTRB(13, 6, 3, 6),
                      width: 109,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '30분 전',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Divider(color: Color(0xFFECECEC), thickness: 1),
          ),
          GestureDetector(
            onTap: moveToNotificationScreen,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text("완료"),
            ),
          )
        ],
      ),
    );
  }
}
