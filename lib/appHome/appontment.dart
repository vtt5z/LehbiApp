import 'package:abc2/appHome/NextSessionPage.dart';
import 'package:abc2/appHome/Lehbipage.dart'; // تأكد من استيراد الصفحة الصحيحة
import 'package:abc2/appHome/appontmentdoctor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  List<String> predefinedDays = [];
  List<DateTime> selectedDays = [];
  TimeOfDay? customStartTime;
  TimeOfDay? customEndTime;
  bool isSaving = false;
  bool useCustomDays = false;
  String? selectedCard;

  @override
  void initState() {
    super.initState();
    _requestExactAlarmPermission();
    _initializeNotifications();
    _fetchPredefinedDays();
  }

  Future<void> _fetchPredefinedDays() async {
    final response =
        await http.get(Uri.parse('https://api.yourservice.com/days'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        predefinedDays = List<String>.from(data['days']);
      });
    } else {
      throw Exception('فشل في تحميل البيانات');
    }
  }

  Future<void> _requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> _initializeNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF005F99), // اللون الأول للتدرج
              Color.fromARGB(255, 255, 255, 255), // اللون الثاني للتدرج
            ],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text(
                'Dialysis Sessions',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent, // خلفية شفافة
              elevation: 0, // إزالة الظل
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Lehbipage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  // بطاقات الوقت المميزة
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTimeCard('5 AM - 10 AM'),
                        _buildTimeCard('11 AM - 3 PM'),
                        _buildTimeCard('4 PM - 8 PM'),
                        _buildTimeCard('8 PM - 12 AM'),
                      ],
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Select Custom Days'),
                    value: useCustomDays,
                    onChanged: (value) {
                      setState(() {
                        useCustomDays = value;
                      });
                    },
                  ),
                  if (useCustomDays) ...[
                    TableCalendar(
                      focusedDay: DateTime.now(),
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      selectedDayPredicate: (day) {
                        return selectedDays.contains(day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          if (selectedDays.contains(selectedDay)) {
                            selectedDays.remove(selectedDay);
                          } else {
                            selectedDays.add(selectedDay);
                          }
                        });
                      },
                    ),
                  ],
                  ListTile(
                    title: const Text('Select Session Time'),
                    subtitle: Text(
                      'From ${customStartTime?.format(context) ?? 'Not set'} to ${customEndTime?.format(context) ?? 'Not set'}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    onTap: () async {
                      await _selectTimeRange();
                    },
                  ),
                  ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            await _saveSchedule();
                          },
                    child: isSaving
                        ? const CircularProgressIndicator()
                        : const Text('Save Schedule'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  heroTag: 'sessionDays',
                  onPressed: () {
                    _showNextAppointments();
                  },
                  label: const Text(
                    'View Session Days',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color(0xFF005F99),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لإنشاء البطاقات المميزة للأوقات
  Widget _buildTimeCard(String timeRange) {
    return Expanded(
      child: Card(
        color: selectedCard == timeRange ? Colors.blue : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: InkWell(
          onTap: () {
            setState(() {
              customStartTime = _getStartTimeForCard(timeRange);
              customEndTime = _getEndTimeForCard(timeRange);
              selectedCard = timeRange;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeRange,
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        selectedCard == timeRange ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.access_time,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالتين لحساب وقت البداية والنهاية بناءً على البطاقة المختارة
  TimeOfDay _getStartTimeForCard(String timeRange) {
    switch (timeRange) {
      case '5 AM - 10 AM':
        return const TimeOfDay(hour: 5, minute: 0);
      case '11 AM - 3 PM':
        return const TimeOfDay(hour: 11, minute: 0);
      case '4 PM - 8 PM':
        return const TimeOfDay(hour: 16, minute: 0);
      case '8 PM - 12 AM':
        return const TimeOfDay(hour: 20, minute: 0);
      default:
        return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  TimeOfDay _getEndTimeForCard(String timeRange) {
    switch (timeRange) {
      case '5 AM - 10 AM':
        return const TimeOfDay(hour: 10, minute: 0);
      case '11 AM - 3 PM':
        return const TimeOfDay(hour: 15, minute: 0);
      case '4 PM - 8 PM':
        return const TimeOfDay(hour: 20, minute: 0);
      case '8 PM - 12 AM':
        return const TimeOfDay(hour: 23, minute: 59);
      default:
        return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  Future<void> _selectTimeRange() async {
    final startTime = await showTimePicker(
      context: context,
      initialTime: customStartTime ?? TimeOfDay(hour: 5, minute: 0),
    );
    final endTime = await showTimePicker(
      context: context,
      initialTime: customEndTime ?? TimeOfDay(hour: 10, minute: 0),
    );
    if (startTime != null && endTime != null) {
      setState(() {
        customStartTime = startTime;
        customEndTime = endTime;
      });
    }
  }

  Future<void> _saveSchedule() async {
    setState(() {
      isSaving = true;
    });

    if (selectedDays.isEmpty && !useCustomDays) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select session days')),
      );
      setState(() {
        isSaving = false;
      });
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving appointments')),
      );
      setState(() {
        isSaving = false;
      });
      return;
    }

    final dateFormatter = DateFormat('yyyy-MM-dd');
    final timeFormatter = DateFormat('HH:mm');

    try {
      List<DateTime> nextAppointments = [];

      for (var day in selectedDays) {
        final now = DateTime.now();
        final appointmentDateTime = DateTime(
          day.year,
          day.month,
          day.day,
          customStartTime?.hour ?? 5,
          customStartTime?.minute ?? 0,
        );

        if (appointmentDateTime.isAfter(now.add(const Duration(minutes: 5)))) {
          await _addAppointmentToFirestore(user.uid, day, appointmentDateTime);
          nextAppointments.add(appointmentDateTime);
        } else {
          final nextWeekDate = day.add(const Duration(days: 7));
          await _addAppointmentToFirestore(
              user.uid, nextWeekDate, appointmentDateTime);
          nextAppointments.add(appointmentDateTime);
        }

        await _scheduleNotifications(appointmentDateTime, day);
      }

      if (nextAppointments.isNotEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NextSessionPage(
              nextAppointments: nextAppointments,
              additionalData: [],
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No upcoming session scheduled')),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule saved successfully')),
      );
    } catch (e) {
      print('Error saving schedule: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving schedule')),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  Future<void> _addAppointmentToFirestore(
      String userId, DateTime day, DateTime appointmentDateTime) async {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final timeFormatter = DateFormat('HH:mm');

    await FirebaseFirestore.instance.collection('appointments').add({
      'user_id': userId,
      'date': dateFormatter.format(day),
      'start_time': timeFormatter.format(appointmentDateTime),
      'end_time': timeFormatter.format(DateTime(
        day.year,
        day.month,
        day.day,
        customEndTime?.hour ?? 10,
        customEndTime?.minute ?? 0,
      )),
    });
  }

  Future<void> _scheduleNotifications(
      DateTime appointmentDateTime, DateTime day) async {
    final notificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Appointment Reminder', // Title
      'Reminder: You have an appointment at ${DateFormat('HH:mm').format(appointmentDateTime)}', // Body
      tz.TZDateTime.from(appointmentDateTime, tz.local), // Notification time
      platformChannelSpecifics, // Notification details
      androidAllowWhileIdle: true, // Allow notification while idle
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime, // Time interpretation
      matchDateTimeComponents: DateTimeComponents.time, // Match components
    );
  }

  void _showNextAppointments() {
    Navigator.pushNamed(
      context,
      '/NextSessionPage',
      arguments: {
        'nextAppointments': selectedDays,
        'additionalData': [],
      },
    );
  }

  void _showNextAppointments2() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Appontmentdoctor(),
      ),
    );
  }
}
