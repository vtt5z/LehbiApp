import 'package:abc2/appHome/LehbiPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: const Text(
          "Tests",
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: const Color(0xFF005F99),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Lehbipage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005F99), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // صف التحاليل
              Container(
                height: 120,
                padding: const EdgeInsets.all(10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    TestCard(
                        testName: "Blood Test",
                        color: Colors.red,
                        icon: FontAwesomeIcons.tint),
                    TestCard(
                        testName: "Sugar Test",
                        color: Colors.blue,
                        icon: FontAwesomeIcons.candyCane),
                    TestCard(
                        testName: "Cholesterol Test",
                        color: Colors.green,
                        icon: FontAwesomeIcons.cheese),
                    TestCard(
                        testName: "Liver Function",
                        color: Colors.orange,
                        icon: FontAwesomeIcons.lungs),
                    TestCard(
                        testName: "Kidney Function",
                        color: Colors.purple,
                        icon: FontAwesomeIcons.stethoscope),
                    TestCard(
                        testName: "Thyroid Test",
                        color: Colors.yellow,
                        icon: FontAwesomeIcons.th),
                    TestCard(
                        testName: "Vitamin D",
                        color: Colors.teal,
                        icon: FontAwesomeIcons.sun),
                  ],
                ),
              ),
              // بطاقة عرض التفاصيل
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ongoing Tests",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "1. Blood Test - Completed",
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          "2. Sugar Test - Pending Results",
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          "3. Cholesterol Test - In Progress",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // بطاقة الملفات
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Test Files",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        FileCard(
                            fileName: "Blood Test Results", date: "2024-10-01"),
                        const SizedBox(height: 8),
                        FileCard(
                            fileName: "Sugar Level Report", date: "2024-10-02"),
                        const SizedBox(height: 8),
                        FileCard(
                            fileName: "Cholesterol Test", date: "2024-10-03"),
                        const SizedBox(height: 8),
                        FileCard(
                            fileName: "Liver Function", date: "2024-09-03"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestCard extends StatelessWidget {
  final String testName;
  final Color color;
  final IconData icon;

  const TestCard(
      {Key? key,
      required this.testName,
      required this.color,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      color: color.withOpacity(0.8),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              testName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileCard extends StatelessWidget {
  final String fileName;
  final String date;

  const FileCard({Key? key, required this.fileName, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                // هنا يمكنك إضافة الكود لتحميل الملف
              },
            ),
          ],
        ),
      ),
    );
  }
}
