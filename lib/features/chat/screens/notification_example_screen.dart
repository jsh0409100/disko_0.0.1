import 'package:flutter/material.dart';

import '../../../common/utils/local_notification.dart';

class NotificationExamplePage extends StatefulWidget {
  const NotificationExamplePage({Key? key}) : super(key: key);

  @override
  State<NotificationExamplePage> createState() => _NotificationExamplePageState();
}

class _NotificationExamplePageState extends State<NotificationExamplePage> {
  late final NotificationService notificationService;
  @override
  void initState() {
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    super.initState();
  }

  void listenToNotificationStream() => notificationService.behaviorSubject.listen((payload) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage(payload)));
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JustWater"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 100),
            child: Image.asset("assets/disko_icon.png", scale: 0.6),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await notificationService.showLocalNotification(
                        id: 0, title: "바로 알림 기능", body: "어플 알림 테스트", payload: "방금 알림을 받으셨습니다");
                  },
                  child: const Text("Drink Now")),
              ElevatedButton(
                  onPressed: () async {
                    await notificationService.showScheduledLocalNotification(
                      id: 1,
                      title: "알림 예약 기능",
                      body: "알림 예약 테스트!",
                      payload: "예약된 알림이 보내졌습니다",
                    );
                  },
                  child: const Text("Schedule Drink ")),
              ElevatedButton(
                  onPressed: () {
                    notificationService.sendNotification(
                      ownerToken:
                          'dHiUc7w1QKaHNaG568as8g:APA91bFL63YSL4KPMN6WkxIMhemJ1WUi7q4VthfQyk3G793DfmmqjHDMns4fHLYEfDZgutMVtF6jxI-G1P6dX_27c4WLPPPYH4tC-8sQSeee5cpcNg6ZW0icClnTyFzkpLynB-Zfb-G6',
                      postTitle: '글글글',
                    );
                  },
                  child: const Text("토큰으로 메세지"))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  notificationService.cancelAllNotifications();
                },
                child: const Text(
                  "Cancel All Drinks",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage(
    this.payload, {
    Key? key,
  }) : super(key: key);

  static const String routeName = '/secondPage';

  final String? payload;

  @override
  State<StatefulWidget> createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  String? _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Second Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('payload : ${_payload ?? ''}'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),
            ],
          ),
        ),
      );
}
