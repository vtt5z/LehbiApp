import 'package:abc2/MyHomePage.dart';
import 'package:abc2/appHome/LehbiPage.dart';
import 'package:abc2/appHome/NextSessionPage.dart';
import 'package:abc2/appHome/appontmentdoctor.dart';
import 'package:abc2/appHome/cart.dart';
import 'package:abc2/login_/SignUp.dart';
import 'package:abc2/login_/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
      routes: {
        '/home': (context) => const MyHomePage(),
        '/signup': (context) => Signup(),
        '/login': (context) => const Login(),
        '/Lehbipage': (context) => const Lehbipage(),
        '/MyHomePage': (context) => const MyHomePage(),
        '/Appontmentdoctor': (context) => const Appontmentdoctor(),
        '/NextSessionPage': (context) => const NextSessionPage(
              nextAppointments: [],
              additionalData: [],
            ),
        '/PharmacyPage': (context) => const Cart(
              selectedProducts: [],
            ),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          final user = snapshot.data;
          if (user != null && user.emailVerified) {
            return const Lehbipage();
          } else {
            return const MyHomePage();
          }
        }
        return const Login();
      },
    );
  }
}
