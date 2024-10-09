import 'package:abc2/appHome/DoctorCard.dart';
import 'package:abc2/appHome/EducationalContentSection.dart';
import 'package:abc2/appHome/aboutus.dart';
import 'package:abc2/appHome/appontment.dart';
import 'package:abc2/appHome/bookappontment.dart';
import 'package:abc2/appHome/card.dart';
import 'package:abc2/appHome/cardinf.dart';
import 'package:abc2/appHome/chat.dart';
import 'package:abc2/appHome/health_and_safety.dart';
import 'package:abc2/appHome/pharmacy.dart';
import 'package:abc2/appHome/profile.dart';
import 'package:abc2/login_/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Lehbipage extends StatefulWidget {
  const Lehbipage({super.key});

  @override
  State<Lehbipage> createState() => _LehbipageState();
}

class _LehbipageState extends State<Lehbipage> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  int _selectedIndex = 0; // لتتبع الصفحة المحددة
  String displayName = "اسم المستخدم"; // الاسم الافتراضي
  String email = "البريد الإلكتروني"; // البريد الإلكتروني الافتراضي
  String userId = FirebaseAuth.instance.currentUser?.uid ?? ""; // ID المستخدم
  String? _profileImageUrl; // متغير لحفظ رابط الصورة

  Future<void> getUserDataFromFirestore() async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userData.exists) {
        setState(() {
          displayName = userData['fullName'] ?? "اسم المستخدم";
          email = userData['email'] ?? "البريد الإلكتروني";
          _profileImageUrl = userData['profileImageUrl']; // استدعاء رابط الصورة
        });
      } else {
        setState(() {
          displayName =
              FirebaseAuth.instance.currentUser?.displayName ?? "اسم المستخدم";
          email =
              FirebaseAuth.instance.currentUser?.email ?? "البريد الإلكتروني";
        });
      }
    } catch (e) {
      setState(() {
        displayName =
            FirebaseAuth.instance.currentUser?.displayName ?? "اسم المستخدم";
        email = FirebaseAuth.instance.currentUser?.email ?? "البريد الإلكتروني";
      });
    }
  }

  Future<void> refreshData() async {
    await getUserDataFromFirestore();
  }

  @override
  void initState() {
    super.initState();
    getUserDataFromFirestore();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Home"; // Translated from Arabic
      case 1:
        return "Pharmacy"; // Translated from Arabic
      case 2:
        return "Consult Your Doctor Now"; // Translated from Arabic
      case 3:
        return "Profile"; // Translated from Arabic
      default:
        return "";
    }
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 150, // Reduced height for better fit
                  crossAxisSpacing: 8, // Reduced spacing
                  mainAxisSpacing: 8, // Reduced spacing
                ),
                itemBuilder: (context, i) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text('Doctor $i')), // Placeholder text
                  );
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
              const DoctorInfoCard(
                doctorName: "Dr. Ali Al-Lahbi",
                advice:
                    'Commitment to dialysis sessions: It is essential to keep the scheduled dialysis sessions to ensure regular blood purification and prevent toxin accumulation.',
                imageUrl: "lib/assets/doctorPNG/doctorali.jpg",
                employeeNumber: '0001',
                email: 'bbyr2222@gmail.com',
              ),
              ServicesCarousel(),
              const DoctorInfoCard(
                doctorName: "Dr. Ahmed Aburahma",
                doctorSpecialty: "Nephrology Specialist",
                doctorExperience: "10 Years",
                imageUrl: "lib/assets/doctorPNG/saudiD.jpg",
                employeeNumber: '0002',
                email: 'bbye3322@gmail.com',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Consultation Button
                  Container(
                    padding: const EdgeInsets.all(8), // Reduced padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {}, // Button press action
                          child: Text(
                            'Get a Consultation',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Color(0xFF004F89), // Button background color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8), // Reduced padding for button
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Booking Appointment Button
                  Container(
                    padding: const EdgeInsets.all(8), // Reduced padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BookAppointment(),
                            ));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Color(0xFF004F89), // Button background color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8), // Reduced padding for button
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                          ),
                          child: const Text(
                            'Book Appointment',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ServicesSection(),
              HealthRecipesSection(),
              AboutUs(),
            ],
          ),
        );
      case 1:
        return PharmacyPage();
      case 2:
        return const ChatPage();
      case 3:
        return const ProfilePage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // ارتفاع الـ AppBar
        child: Container(
          color: const Color(0xFF005F99),
          child: AppBar(
            title: Text(
              _getAppBarTitle(),
              style: const TextStyle(color: Colors.white), // جعل لون النص أبيض
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent, // جعل الخلفية شفافة
            elevation: 0, // إزالة الظل
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(displayName),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : null,
                child: _profileImageUrl == null
                    ? Text(
                        displayName.isNotEmpty ? displayName[0] : '',
                        style: const TextStyle(fontSize: 40.0),
                      )
                    : null,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF0288D1),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.teal),
                      title: const Text(
                          'Appointments & Reminders'), // Translated from Arabic
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const Appointment()), // Replace with your Appointment screen widget
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.health_and_safety,
                          color: Colors.green),
                      title: const Text(
                          'Daily Health Tracking'), // Translated from Arabic
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const HealthAndSafety()), // Replace with your HealthAndSafety screen widget
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.chat, color: Colors.orange),
                      title: const Text(
                          'Contact Doctors'), // Translated from Arabic
                      onTap: () {
                        // Add navigation logic here
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.folder_shared, color: Colors.red),
                      title: const Text(
                          'Electronic Health Record'), // Translated from Arabic
                      onTap: () {
                        // Add navigation logic here
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.location_on, color: Colors.purple),
                      title: const Text(
                          'Find Nearby Clinics'), // Translated from Arabic
                      onTap: () {
                        // Add navigation logic here
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.video_library, color: Colors.teal),
                      title: const Text(
                          'Educational Articles & Videos'), // Translated from Arabic
                      onTap: () {
                        // Add navigation logic here
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.settings_applications_sharp,
                          color: Colors.blue),
                      title:
                          const Text('App Settings'), // Translated from Arabic
                      onTap: () {
                        // Add navigation logic here
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                heroTag:
                    'logout', // Modified to use English tag for consistency
                onPressed: () async {
                  // Disconnect from Google and sign out from Firebase
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  await googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut();

                  // Navigate back to the login page
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                label: const Text(
                  'Log Out', // Translated from Arabic to English
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                backgroundColor:
                    const Color(0xFF005F99), // Same color as the rest of the UI
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: refreshData, // دالة التحديث
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005F99), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _buildPage(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: 'Pharmacy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 4, 64, 114),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 5, 55, 95),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
