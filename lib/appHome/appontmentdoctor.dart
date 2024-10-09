import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Appontmentdoctor  extends StatefulWidget {
  const Appontmentdoctor ({super.key});

  @override
  _AppointmentDoctorState createState() => _AppointmentDoctorState();
}

class _AppointmentDoctorState extends State<Appontmentdoctor > {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<Map<String, dynamic>> appointments = []; // To store appointments
  final String userEmail =
      'your_email@example.com'; // Enter your email here

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize time zones
    _initializeNotifications();
    _fetchAppointments();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _fetchAppointments() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('email',
              isEqualTo: userEmail) // Filtering appointments by email
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          appointments = snapshot.docs.map((doc) {
            return {
              'doctorName': doc['doctorName'],
              'appointmentDate': doc['appointmentDate'].toDate().toString(),
              'email': doc['email'],
              'fullName': doc['fullName'],
              'phone': doc['phone'],
            };
          }).toList();
        });

        for (var appointment in appointments) {
          DateTime appointmentTime =
              (appointment['appointmentDate'] as DateTime);
          DateTime notificationTime =
              appointmentTime.subtract(const Duration(hours: 3));
          await _scheduleNotification(
              notificationTime, appointment['doctorName']);
        }
      } else {
        setState(() {
          appointments = [];
        });
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  Future<void> _scheduleNotification(
      DateTime scheduledNotificationDateTime, String doctorName) async {
    final tz.TZDateTime tzScheduledDateTime = tz.TZDateTime.from(
      scheduledNotificationDateTime,
      tz.local,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Upcoming Appointment',
      'You have an appointment with $doctorName in 3 hours.',
      tzScheduledDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Information'),
        backgroundColor: const Color(0xFF005F99),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005F99), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: appointments.isNotEmpty
              ? ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointment = appointments[index];
                    return Dismissible(
                      key: Key(appointment['email'] +
                          appointment['appointmentDate']),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // Here you can add code to delete the appointment if needed
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${appointment['doctorName']} appointment has been deleted.'),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Doctor Name: ${appointment['doctorName']}',
                                  style: const TextStyle(fontSize: 20)),
                              const SizedBox(height: 10),
                              Text(
                                  'Appointment Date: ${appointment['appointmentDate']}',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 10),
                              Text('Email: ${appointment['email']}',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 10),
                              Text('Full Name: ${appointment['fullName']}',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 10),
                              Text('Phone Number: ${appointment['phone']}',
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
