import 'package:abc2/appHome/employPage.dart';
import 'package:abc2/button.dart/custombutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class EmployeeLoginPage extends StatefulWidget {
  const EmployeeLoginPage({super.key});

  @override
  State<EmployeeLoginPage> createState() => _EmployeeLoginPageState();
}

class _EmployeeLoginPageState extends State<EmployeeLoginPage> {
  TextEditingController loginController =
      TextEditingController(); // New controller for general use
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formStat = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> login() async {
    if (formStat.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        QuerySnapshot querySnapshot;

        String input = loginController.text;

        // Check if the input is an email or employee number
        if (RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input)) {
          // Login with email
          querySnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .where('email', isEqualTo: input)
              .where('password', isEqualTo: passwordController.text)
              .get();
        } else {
          // Login with employee number
          querySnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .where('employeeNumber', isEqualTo: input)
              .where('password', isEqualTo: passwordController.text)
              .get();
        }

        if (querySnapshot.docs.isNotEmpty) {
          // If a matching employee is found
          var employeeDoc = querySnapshot.docs.first;
          String doctorName = employeeDoc['doctorName']; // Retrieve doctor's name
          String employeeNumber =
              employeeDoc['employeeNumber']; // Retrieve employee number

          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Success',
            desc: 'Login successful!',
          )..show();

          // Pass data to Employpage
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Employpage(
              doctorName: doctorName,
              employeeNumber: employeeNumber,
            ),
          ));
        } else {
          // If no matching employee is found
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Incorrect employee number, email, or password.',
          )..show();
        }
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'An error occurred during login.',
        )..show();
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF005F99), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Form(
                  key: formStat,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50),
                      const Center(
                        child: Icon(
                          Icons.login,
                          size: 100,
                          color: Color(0xFF005F99),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF005F99),
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Employee Number or Email',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0xFF005F99),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: loginController,
                        decoration: InputDecoration(
                          hintText: 'Email or Employee Number',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter employee number or email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Password',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0xFF005F99),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: '**********',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        obscureText: true,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Custombutton(
                        title: 'Login',
                        onPressed: () async {
                          await login(); // Call login function to validate first
                        },
                      ),
                      const SizedBox(height: 200),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/MyHomePage',
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Icon(
                            Icons.home,
                            color: Color(0xFF005F99),
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
