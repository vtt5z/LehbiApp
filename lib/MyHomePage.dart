import 'package:abc2/login_/EmployeeLoginPage.dart';
import 'package:abc2/login_/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> images = [
    'lib/assets/lehbe.jpg',
    'lib/assets/helpdoctor.jpg',
    'lib/assets/A2.jpg',
  ];

  final List<String> captions = [
    'We take care of you to ensure your comfort in every visit.',
    'Expert doctors ready to provide the best medical care.',
    'We care, diagnose, and treat – because your health is the top priority.',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // تدرج الخلفية
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF005F99), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 90), // مساحة فوق العنوان
              const Text(
                'Lehbi Renal Care',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 239, 241, 241),
                ),
              ),
              const SizedBox(height: 20), // مسافة بين العنوان والبطاقات

              // عرض البطاقات والصور
              SizedBox(
                width: double.infinity,
                height: 350, // ارتفاع البطاقات
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 300, // ارتفاع الصورة داخل البطاقة
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20), // مسافة بعد البطاقات

              // العبارات الصحية تحت البطاقة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  captions[_currentPage],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF005F99), // الحفاظ على لون النص الأصلي
                  ),
                ),
              ),

              const SizedBox(height: 40), // مسافة إضافية بين العبارات والنقاط

              // النقاط التفاعلية
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.blue.shade900
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                  );
                }),
              ),
            ],
          ),
          // زر ثابت في أسفل الشاشة
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showOptionsDialog(context);
                },
                icon: const Icon(
                  Icons.local_hospital, // أيقونة المستشفى
                  color: Colors.white,
                  size: 24,
                ),
                label: Text(
                  'Explore Healthcare',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold, // To enhance text appearance
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005F99), // لون أزرق غامق
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // حواف دائرية للزر
                  ),
                  elevation: 5, // إضافة ظل لزر
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16), // حواف دائرية لمربع الحوار
            ),
            backgroundColor: const Color(
                0xFF005F99), // خلفية مربع الحوار باللون الأزرق الغامق
            title: const Center(
              child: Text(
                'Select Login Method',
                style: TextStyle(
                  color: Colors.white, // White text color
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.work_outline, color: Colors.white),
                  title: const Text(
                    'Login as Employee',
                    style: TextStyle(
                      color: Colors.white, // White text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tileColor: const Color(
                      0xFF004F89), // Dark blue background for the card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Rounded corners for the card
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const EmployeeLoginPage(),
                    ));
                  },
                ),
                const Divider(
                  color: Colors.white, // White divider color
                  thickness: 1.0,
                ),
                ListTile(
                  leading:
                      const Icon(Icons.person_outline, color: Colors.white),
                  title: const Text(
                    'Continue as Guest',
                    style: TextStyle(
                      color: Colors.white, // White text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tileColor: const Color(
                      0xFF004F89), // Dark blue background for the card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Rounded corners for the card
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Login(),
                    ));
                  },
                ),
              ],
            ));
      },
    );
  }
}
