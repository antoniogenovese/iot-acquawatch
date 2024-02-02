import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class Timer extends StatefulWidget {
  final String cron;
  final VoidCallback updatePage;

  @override
  const Timer({Key? key, required this.cron, required this.updatePage})
      : super(key: key);

  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<Timer> {
  bool isTimerFinished = false;

  @override
  Widget build(BuildContext context) {
    List<String> parole = widget.cron.split(' ');

    int cronMinutes = int.parse(parole[0]);
    int cronHours = int.parse(parole[1]);
    int cronDay;
    int cronMonth;

    DateTime now = DateTime.now();
    parole[2] != "*" ? cronDay = int.parse(parole[2]) : cronDay = now.day;
    parole[3] != "*" ? cronMonth = int.parse(parole[3]) : cronMonth = now.month;
    DateTime nextCron =
        DateTime(now.year, cronMonth, cronDay, cronHours, cronMinutes);

    if (nextCron.isBefore(now)) {
      nextCron =
          DateTime(now.year, cronMonth + 1, cronDay, cronHours, cronMinutes);
    }
    Duration timeRemaining = nextCron.difference(now);

    int days = timeRemaining.inDays;
    int hours = timeRemaining.inHours % 24;
    int minutes = (timeRemaining.inMinutes % 60) - 1;
    int seconds = timeRemaining.inSeconds % 60;

    return Container(
      child: Column(
        children: [
          Text("Next water change in: ", style: TextStyle(fontSize: 25)),
          TimerCountdown(
              timeTextStyle: TextStyle(fontSize: 20),
              spacerWidth: 0,
              format: CountDownTimerFormat.daysHoursMinutesSeconds,
              endTime: DateTime.now().add(
                Duration(
                  days: days,
                  hours: hours,
                  minutes: minutes,
                  seconds: seconds,
                ),
              ),
              descriptionTextStyle: TextStyle(fontSize: 20),
              colonsTextStyle: TextStyle(fontSize: 20),
              onEnd: () {
                setState(() {
                  isTimerFinished = true;
                });
                Future.delayed(Duration(seconds: 90), () {
                  widget.updatePage();
                });
              }),
          SizedBox(height: 20),
          Text(isTimerFinished == true ? 'WATER RECYCLING IN PROGRESS...' : '',
              style: TextStyle(fontSize: 25)),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
