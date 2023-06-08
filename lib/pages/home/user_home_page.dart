import 'package:table_calendar/table_calendar.dart';

import '../../models/user.dart';
import '../../services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserHomePage extends StatefulWidget {
  final UserData userData;
  const UserHomePage({super.key, required this.userData});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarGT(userData: widget.userData),
          const SizedBox(height: 10),
          CalendarWidget()
        ],
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  Map<DateTime, List> events = {
    DateTime(2023, 6, 7): ['Event A', 'Event B'],
    DateTime(2023, 6, 10): ['Event C'],
    // Add more events here
  };
  List _getEventsForTheDay(DateTime day) {
    DateTime yau = day.toLocal().subtract(const Duration(hours: 1));
    return events[yau] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      eventLoader: _getEventsForTheDay,
      rowHeight: 45,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarStyle: CalendarStyle(
        markerDecoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 1),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(
          color: Colors.black,
        ),
        todayDecoration: BoxDecoration(
          border:
              Border.all(color: const Color.fromRGBO(191, 76, 76, 1), width: 2),
          color: const Color.fromRGBO(191, 76, 76, 0.05),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Color.fromRGBO(191, 76, 76, 1),
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      headerStyle:
          const HeaderStyle(formatButtonVisible: false, titleCentered: true),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay; // update _focusedDay here as well
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}

Widget buildEventDots(DateTime date, List events) {
  return Row(
    children: events.map((event) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red, // Customize the dot color as desired
        ),
      );
    }).toList(),
  );
}

class AppBarGT extends StatelessWidget {
  final UserData userData;
  const AppBarGT({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromRGBO(191, 76, 76, 1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12))),
      constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height * 0.35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          UserProfileGT(userData: userData),
          const IconsStatsGT(),
        ],
      ),
    );
  }
}

class UserProfileGT extends StatelessWidget {
  final UserData userData;
  const UserProfileGT({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [userNameGT(userData), Image.asset('images/profile-photo.png')],
    );
  }
}

Widget userNameGT(UserData userData) {
  final now = DateTime.now();
  String timeGT = DateFormat('yMMMEd').format(now);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        timeGT,
        style: const TextStyle(
            fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
      ),
      Text(
        "Hello ${userData.username}",
        style: const TextStyle(
            fontSize: 27, color: Colors.white, fontWeight: FontWeight.w400),
      ),
    ],
  );
}

class IconsStatsGT extends StatelessWidget {
  const IconsStatsGT({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 254, 254, 0.95),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.85),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            iconStat("images/calendar-icon.png", "Times Per Week", "3"),
            iconStat("images/stopwatch-icon.png", "Avg. Training \nTime", "55"),
            iconStat("images/zumba-icon.png", "Last Training\n Session",
                "2 days ago")
          ],
        ));
  }
}

Widget iconStat(String iconName, String textDefault, String textNumber) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(191, 76, 76, 1),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Image.asset(iconName)),
      Text(
        textNumber,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 10, color: Colors.black, fontWeight: FontWeight.w900),
      ),
      Text(
        textDefault,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 10, color: Colors.black, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
