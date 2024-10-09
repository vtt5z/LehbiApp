import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DoctorInfoCard extends StatelessWidget {
  final String doctorName; // Name is required
  final String? doctorSpecialty; // Specialty is optional
  final String? doctorExperience; // Experience is optional
  final String imageUrl; // Image URL is required
  final String? advice; // Advice is optional
  final String employeeNumber; // Employee number is required
  final String email; // Email is required

  const DoctorInfoCard({
    Key? key,
    required this.doctorName,
    this.doctorSpecialty,
    this.doctorExperience,
    required this.imageUrl,
    this.advice,
    required this.employeeNumber,
    required this.email, // Adding email
  }) : super(key: key);

  // Function to generate a random password
  String generateRandomPassword(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_=+';
    Random random = Random();
    return List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
  }

  // Function to save data to Firestore
  Future<void> saveToFirestore() async {
    // Check if a doctor with the same email exists
    final existingDoctorQuery = await FirebaseFirestore.instance
        .collection('employees')
        .where('email', isEqualTo: email)
        .get();

    String randomPassword =
        generateRandomPassword(12); // Generate a random password

    if (existingDoctorQuery.docs.isNotEmpty) {
      // If the email exists, update the record
      var existingDoctor =
          existingDoctorQuery.docs.first; // Use the first record
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(existingDoctor.id)
          .update({
        'doctorName': doctorName,
        'doctorSpecialty': doctorSpecialty,
        'doctorExperience': doctorExperience,
        'imageUrl': imageUrl,
        'advice': advice,
        'employeeNumber': employeeNumber,
        'password': randomPassword, // Save the password
      });
    } else {
      // If not found, save the data as a new entry
      await FirebaseFirestore.instance.collection('employees').add({
        'doctorName': doctorName,
        'doctorSpecialty': doctorSpecialty,
        'doctorExperience': doctorExperience,
        'imageUrl': imageUrl,
        'employeeNumber': employeeNumber,
        'email': email,
        'advice': advice,
        'password': randomPassword, // Save the password
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Save data to Firestore when building the card
    saveToFirestore();

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 9,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 11),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100.0), // Adjusted for LTR
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Change to start for LTR
                children: [
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Change to start for LTR
                    children: [
                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005F99),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.verified, color: Colors.teal, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (doctorSpecialty != null) ...[
                    Text(
                      doctorSpecialty!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (doctorExperience != null) ...[
                    Text(
                      "Experience: $doctorExperience", // Translated
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  if (advice != null) ...[
                    Directionality(
                      textDirection: TextDirection.ltr, // Change to LTR
                      child: Text(
                        "Advice: $advice", // Translated
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.left, // Change to left for LTR
                      ),
                    ),
                  ],
                  const SizedBox(height: 15),
                ],
              ),
            ),
            Positioned(
              left: 0, // Adjusted for LTR
              top: 0,
              bottom: 40,
              child: CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(imageUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
