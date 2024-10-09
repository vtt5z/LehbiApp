
import 'package:flutter/material.dart';

class DoctorInfoPage extends StatelessWidget {
  final String doctorName;
  final String doctorSpecialty;
  final String imageUrl;

  const DoctorInfoPage({
    Key? key,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctorName),
        backgroundColor: const Color(0xFF005F99),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80, // تكبير صورة الطبيب
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(height: 20),
            Text(
              doctorName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              doctorSpecialty,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
