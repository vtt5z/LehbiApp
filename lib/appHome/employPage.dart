import 'dart:io';
import 'package:abc2/appHome/emplyefiles/Appointmeent.dart';
import 'package:abc2/appHome/emplyefiles/MedicalReportsPage.dart';
import 'package:abc2/appHome/emplyefiles/PatientRecordPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Employpage extends StatefulWidget {
  final String doctorName;
  final String employeeNumber;

  const Employpage({
    super.key,
    required this.doctorName,
    required this.employeeNumber,
  });

  @override
  _EmploypageState createState() => _EmploypageState();
}

class _EmploypageState extends State<Employpage> {
  int _selectedIndex = 0;

  // الدالة لبناء الصفحة الحالية بناءً على الفهرس المحدد
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Container(); // يمكن وضع المحتوى الأساسي هنا
      case 1:
        return const PatientRecordPage();
      case 2:
        return const AppointmentPage();
      case 3:
        return const MedicalReportsPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF005F99),
        title: const Center(
            child: Text(
          'مجمع اللهبي الطبي',
          style: TextStyle(color: Colors.white),
        )),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF005F99),
              ),
              child: Row(
                children: [
                  FutureBuilder<String?>(
                    future: _fetchImageUrl(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                        );
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                        );
                      } else {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: _updateImage,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(snapshot.data!),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _updateImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.doctorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'رقم الموظف: ${widget.employeeNumber}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // قائمة الأيقونات لتسهيل التواصل بين الموظفين
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('الدردشة مع الزملاء'),
              onTap: () {
                // إضافة كود للدردشة هنا
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('الإشعارات'),
              onTap: () {
                // إضافة كود للإشعارات هنا
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_phone),
              title: const Text('قائمة الأرقام الهامة'),
              onTap: () {
                // إضافة كود لقائمة الأرقام الهامة هنا
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('الدعم الفني'),
              onTap: () {
                // إضافة كود للدعم الفني هنا
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // الخلفية بالتدرج
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF005F99), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // المحتوى الأساسي
          _buildPage(_selectedIndex),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'سجل المرضى',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'المواعيد',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'التقارير الطبية',
          ),
        ],
        backgroundColor: const Color(0xFF005F99),
        currentIndex: _selectedIndex,
        selectedItemColor:
            const Color(0xFF005F99), // اللون عند الاختيار (أزرق غامق)
        unselectedItemColor:
            Colors.black54, // اللون عند عدم الاختيار (أسود غامق)
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // تغيير الفهرس المحدد
          });
        },
      ),
    );
  }

  Future<String?> _fetchImageUrl() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('employeeNumber', isEqualTo: widget.employeeNumber)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first['imageUrl'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching imageUrl: $e');
      return null;
    }
  }

  Future<void> _updateImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      try {
        // تحميل الصورة إلى Firebase Storage
        String filePath = 'employees/${widget.employeeNumber}.jpg';
        await FirebaseStorage.instance
            .ref(filePath)
            .putFile(File(imageFile.path));

        // الحصول على رابط الصورة بعد التحميل
        String downloadUrl =
            await FirebaseStorage.instance.ref(filePath).getDownloadURL();

        // تحديث رابط الصورة في Firestore
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(widget.employeeNumber) // استخدم employeeNumber كمفتاح
            .update({'imageUrl': downloadUrl});
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }
}
