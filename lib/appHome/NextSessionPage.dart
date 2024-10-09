import 'package:abc2/appHome/appontment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async'; // استيراد مكتبة Timer

class NextSessionPage extends StatefulWidget {
  final List<DateTime> nextAppointments; // استقبال قائمة الجلسات القادمة
  final List additionalData; // قد تحتاج إلى تحديد الغرض منها
  const NextSessionPage({
    super.key,
    required this.nextAppointments, // تمرير القيمة
    required this.additionalData, // تمرير القيمة
  });

  @override
  _NextSessionPageState createState() => _NextSessionPageState();
}

class _NextSessionPageState extends State<NextSessionPage> {
  late Timer _timer; // تعريف المتغير Timer

  @override
  void initState() {
    super.initState();
    _initializeNotifications(); // تهيئة الإشعارات
    _startCountdown(); // بدء العد التنازلي
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {}); // إعادة بناء الواجهة كل دقيقة
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // إلغاء المؤقت عند التخلص من الصفحة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upcoming Sessions',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF005F99),
                Color(0xFF005F99),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005F99), Color.fromARGB(255, 240, 241, 241)],
            // begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: user != null
                ? FirebaseFirestore.instance
                    .collection('appointments')
                    .where('user_id', isEqualTo: user.uid)
                    .snapshots()
                : Stream.empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'There are no upcoming sessions.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final nextAppointments = snapshot.data!.docs.map((doc) {
                final date = DateTime.parse(doc['date']);
                return {
                  'id': doc.id,
                  'date': date,
                  'start_time': doc['start_time'],
                };
              }).toList();

              _deleteExpiredAppointments(nextAppointments);

              return ListView.builder(
                itemCount: nextAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = nextAppointments[index];
                  final nextAppointment = appointment['date'];
                  final now = DateTime.now();
                  final remainingDuration = nextAppointment.difference(now);

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8), // حجم أصغر للبطاقة
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // حدود دائرية
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0), // تقليص الحشو
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your next session will be on',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('EEEE').format(nextAppointment),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal),
                                  ),
                                  Text(
                                    DateFormat('MM/dd').format(nextAppointment),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      appointment['id']);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // تصميم العداد بشكل 00:00:00
                          Center(
                            child: Text(
                              _formatFullDuration(remainingDuration),
                              style: const TextStyle(
                                fontSize: 30, // حجم كبير للعداد
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), // ترك مساحة إضافية
                          Center(
                            child: LinearProgressIndicator(
                              value: remainingDuration.isNegative
                                  ? 0.0 // إذا كان المتبقي سالبًا، نعين القيمة 0
                                  : (1.0 -
                                          (remainingDuration.inMinutes /
                                                  (24 * 60))
                                              .toDouble())
                                      .clamp(0.0,
                                          1.0), // تحويل إلى double والتأكد من النطاق
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Appointment()),
            (Route<dynamic> route) => false,
          );
        },
        label: const Text(
          'Add Your Next Session',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF005F99),
      ),
    );
  }

  // دالة جديدة لحساب الزمن بشكل 00:00:00
  String _formatFullDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    return '${days.toString().padLeft(2, '0')}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  Future<void> _initializeNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));

    _scheduleHealthTipsNotification(); // جدولة الإشعارات الصحية
  }

  Future<void> _scheduleHealthTipsNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const interval = Duration(hours: 5);
    final scheduledTime = DateTime.now().add(interval);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Health Tips',
      'Remember to take care of your health! Drink water and eat healthy food.',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'health_tips_channel',
          'Health Tips',
          channelDescription: 'Tips for maintaining health.',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _deleteExpiredAppointments(
      List<Map<String, dynamic>> appointments) async {
    final now = DateTime.now();
    for (var appointment in appointments) {
      final appointmentDate = appointment['date'] as DateTime;
      if (appointmentDate.isBefore(now)) {
        await _deleteAppointment(appointment['id']);
        _sendEndNotification(appointmentDate); // إرسال إشعار عند انتهاء الجلسة
      }
    }
  }

  Future<void> _sendEndNotification(DateTime appointmentDate) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.show(
      1,
      'Session Ended!',
      'We wish you a healthy day! Remember to drink water and eat healthy food.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'end_appointment_channel',
          'Session Ended',
          channelDescription: 'Notification for session end.',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> _deleteAppointment(String appointmentId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .delete();
    }
  }

  void _showDeleteConfirmationDialog(String appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _deleteAppointment(appointmentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
