import 'package:abc2/button.dart/custombutton.dart';
import 'package:abc2/login_/login.dart';
import 'package:abc2/themeApp/textformfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController fullName = TextEditingController(); // Full name field
  final GlobalKey<FormState> formStat = GlobalKey<FormState>();

  Future<String?> validateUsername(String? value) async {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }

    // Length validation
    if (value.length < 3) {
      return 'Username must be more than 3 characters';
    }

    // Check for valid characters
    if (!RegExp(r'^[A-Za-z].*').hasMatch(value)) {
      return 'Username must start with a letter';
    }

    // Check if the username already exists in Firestore
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: value)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return 'Username is already taken';
    }

    return null; // No errors
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formStat,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF005F99), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: const Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF005F99),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Full name field
                const Text(
                  'Full Name',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF005F99),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Textformfield(
                  hintText: 'John Doe',
                  mycontroller: fullName,
                  validator: (val) {
                    if (val == '') {
                      return 'Please enter your full name';
                    }
                    return null; // Only check for empty value
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  'Username',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF005F99),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Textformfield(
                  hintText: 'john_doe123',
                  mycontroller: username,
                  validator: (val) {
                    if (val == '') {
                      return 'Please enter a username';
                    }
                    return null; // Only check for empty value
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  'Email',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF005F99),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Textformfield(
                  hintText: 'example@gmail.com',
                  mycontroller: email,
                  validator: (val) {
                    if (val == '') {
                      return 'Please enter your email';
                    }
                    return null; // Only check for empty value
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  'Password',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF005F99),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Textformfield(
                  hintText: '**********',
                  mycontroller: password,
                  validator: (val) {
                    if (val == '') {
                      return 'Please enter your password';
                    }
                    return null; // Only check for empty value
                  },
                ),
                const SizedBox(height: 25),
                Custombutton(
                  title: 'Register',
                  onPressed: () async {
                    if (formStat.currentState!.validate()) {
                      String? usernameError =
                          await validateUsername(username.text);
                      if (usernameError != null) {
                        // Display username error to the user
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          title: 'Error',
                          desc: usernameError,
                          btnOkOnPress: () {},
                        ).show();
                        return; // Exit early if there's an error
                      }

                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );

                        // Add user information to Firestore
                        final userId = credential.user?.uid; // Get user ID
                        if (userId != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .set({
                            'fullName': fullName.text, // Save full name
                            'username': username.text,
                            'email': email.text,
                          });
                        }

                        FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          title: 'Verification Sent',
                          desc:
                              'A verification email has been sent to your email. Please verify your account before logging in.',
                          btnOkOnPress: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => Login(),
                            ));
                          },
                        )..show();
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,
                            title: 'Error',
                            desc: 'The password is too weak',
                            btnOkOnPress: () {},
                          )..show();
                        } else if (e.code == 'email-already-in-use') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,
                            title: 'Error',
                            desc: 'The email is already in use',
                            btnOkOnPress: () {},
                          )..show();
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Or sign up using',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),

                // Social icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google login icon
                    IconButton(
                      icon:
                          Icon(Icons.g_mobiledata, color: Colors.red, size: 50),
                      onPressed: () async {
                        // Call Google sign-in function
                      },
                    ),

                    SizedBox(width: 20), // Space between icons

                    // Facebook login icon
                    IconButton(
                      icon: Icon(Icons.facebook, color: Colors.blue, size: 40),
                      onPressed: () async {
                        // Call Facebook sign-in function
                      },
                    ),

                    SizedBox(width: 20), // Space between icons

                    // Twitter login icon
                    IconButton(
                      icon: Icon(Icons.alternate_email,
                          color: Colors.lightBlue, size: 40),
                      onPressed: () async {
                        // Call Twitter sign-in function
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Login(),
                      ));
                    },
                    child: const Text('Already have an account?',
                        style: TextStyle(
                          color: Color(0xFF005F99),
                          fontWeight: FontWeight.bold,
                        )),
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
