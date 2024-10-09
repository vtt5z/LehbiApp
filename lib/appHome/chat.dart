import 'package:abc2/appHome/ChatDetailPage.dart';
import 'package:abc2/appHome/DoctorCard.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005F99), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // List of Doctors
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatDetailPage(
                      doctorName: "Dr. Ahmed Ali",
                      doctorSpecialty: "Kidney Specialist",
                      imageUrl: "lib/assets/doctorPNG/saudiD.jpg",
                      doctorId: '0002',
                      userId: 'user_01',
                      bio:
                          "Experienced kidney specialist with over 10 years in the field.",
                    ),
                  ),
                );
              },
              child: const DoctorInfoCard(
                doctorName: "Dr. Ahmed Aburahma",
                doctorSpecialty: "Kidney Specialist",
                doctorExperience: "10 years",
                imageUrl: "lib/assets/doctorPNG/saudiD.jpg",
                employeeNumber: '0002',
                email: 'bbye3322@gmail.com',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatDetailPage(
                      doctorName: "Dr. Firdaws",
                      doctorSpecialty: "Women's Specialist",
                      imageUrl: "lib/assets/doctorPNG/wemanD.jpg",
                      doctorId: '0007',
                      userId: 'user_02',
                      bio:
                          "Specializing in women's health with over 8 years of experience.",
                    ),
                  ),
                );
              },
              child: const DoctorInfoCard(
                doctorName: "Dr. Firdaws",
                doctorSpecialty: "Women's Specialist",
                doctorExperience: "8 years",
                imageUrl: "lib/assets/doctorPNG/wemanD.jpg",
                employeeNumber: '0007',
                email: 'mohammed@gmail.com',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatDetailPage(
                      doctorName: "Dr. Nourah Hussain",
                      doctorSpecialty: "General Practitioner",
                      imageUrl: "lib/assets/doctorPNG/wamenDoctor1.jpg",
                      doctorId: '0006',
                      userId: 'user_03',
                      bio:
                          "General practitioner dedicated to providing comprehensive care.",
                    ),
                  ),
                );
              },
              child: const DoctorInfoCard(
                doctorName: "Dr. Nourah Hussain",
                doctorSpecialty: "General Practitioner",
                doctorExperience: "5 years",
                imageUrl: "lib/assets/doctorPNG/wamenDoctor1.jpg",
                employeeNumber: '0006',
                email: 'hh144@gmail.com',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatDetailPage(
                      doctorName: "Dr. Leila Fouad",
                      doctorSpecialty: "Dermatology Specialist",
                      imageUrl: "lib/assets/doctorPNG/wamenDoctor.jpg",
                      doctorId: '0008',
                      userId: 'user_04',
                      bio:
                          "Expert in treating skin conditions with 7 years of experience.",
                    ),
                  ),
                );
              },
              child: const DoctorInfoCard(
                doctorName: "Dr. Leila Fouad",
                doctorSpecialty: "Dermatology Specialist",
                doctorExperience: "7 years",
                imageUrl: "lib/assets/doctorPNG/wamenDoctor.jpg",
                employeeNumber: '0008',
                email: 'bbye33232@gmail.com',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatDetailPage(
                      doctorName: "Dr. Fatima Jassim",
                      doctorSpecialty: "Cardiology Specialist",
                      imageUrl: "lib/assets/doctorPNG/wamenDSctor.jpg",
                      doctorId: '0005',
                      userId: 'user_05',
                      bio:
                          "Cardiologist with extensive experience in heart diseases.",
                    ),
                  ),
                );
              },
              child: const DoctorInfoCard(
                doctorName: 'Dr. Ahmed Sabri',
                doctorSpecialty: "Kidney Specialist",
                doctorExperience: "15 years",
                imageUrl: "lib/assets/doctorPNG/doctorsabri.jpg",
                employeeNumber: '0005',
                email: 'bbyr676@gmail.com',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatDetailPage(
                      doctorName: "Dr. Sarah Mahmoud",
                      doctorSpecialty: "Nutrition Specialist",
                      imageUrl: "lib/assets/doctorPNG/doctorsabri.jpg",
                      doctorId: '0004',
                      userId: 'user_06',
                      bio:
                          "Nutritionist dedicated to improving dietary health.",
                    ),
                  ),
                );
              },
              child: const DoctorInfoCard(
                doctorName: "Dr. Sarah Mahmoud",
                doctorSpecialty: "Nutrition Specialist",
                doctorExperience: "6 years",
                imageUrl: "lib/assets/doctorPNG/wamenDSctor.jpg",
                employeeNumber: '0004',
                email: 'bbyr0099@gmail.com',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatDetailPage(
                      doctorName: "Dr. Adel Kamal",
                      doctorSpecialty: "General Surgery Specialist",
                      imageUrl: "lib/assets/doctorAli.jpg",
                      doctorId: '0003',
                      userId: 'user_07',
                      bio:
                          "Skilled surgeon with a focus on minimally invasive procedures.",
                    ),
                  ),
                );
              },
              child: const DoctorInfoCard(
                doctorName: "Dr. Adel Kamal",
                doctorSpecialty: "General Surgery Specialist",
                doctorExperience: "12 years",
                imageUrl: "lib/assets/doctorAli.jpg",
                employeeNumber: '0003',
                email: 'bbyr2111@gmail.com',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
