import 'package:flutter/material.dart';
import 'package:abc2/appHome/Tests.dart'; // تأكد من استيراد الصفحة الصحيحة

class ServicesCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ServiceCard(
            serviceName: "Dialysis",
            imagePath: 'lib/assets/dalsis.jpg',
            onTap: () {
              // Action when "Dialysis" service is tapped
              // يمكنك إضافة أي إجراءات أخرى هنا
            },
          ),
          ServiceCard(
            serviceName: "Consultations",
            imagePath: 'lib/assets/doctocheel.jpg',
            onTap: () {
              // Action when "Medical Consultations" service is tapped
              // يمكنك إضافة أي إجراءات أخرى هنا
            },
          ),
          ServiceCard(
            serviceName: "Tests",
            imagePath: 'lib/assets/test.jpg',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TestsPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String imagePath;
  final VoidCallback? onTap; // إضافة callback للإجراء عند النقر

  const ServiceCard({
    Key? key,
    required this.serviceName,
    required this.imagePath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // استخدم callback هنا
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        color: Colors.white,
        child: Container(
          width: 100, // تقليل الحجم
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  height: 40, // تقليل حجم الصورة
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                serviceName,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
