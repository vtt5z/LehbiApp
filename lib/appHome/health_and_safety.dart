import 'package:flutter/material.dart';

class HealthAndSafety extends StatelessWidget {
  const HealthAndSafety({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(); // العودة للخلف
        return false; // لمنع العودة الافتراضية
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'الصحة والسلامة',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF005F99),
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back, color: Colors.white), // زر العودة
            onPressed: () {
              Navigator.of(context)
                  .popAndPushNamed('/Lehbipage'); // العودة للخلف
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF005F99),
                Color(0xFF005F99), // اللون الأول للتدرج
                Color.fromARGB(255, 255, 255, 255), // اللون الثاني للتدرج
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // إضافة المحتوى هنا
            ],
          ),
        ),
      ),
    );
  }
}
