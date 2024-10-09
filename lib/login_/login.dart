import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:abc2/appHome/LehbiPage.dart'; // تأكد من استيراد صفحة Lehbipage الخاصة بك
import 'package:abc2/themeApp/textformfield.dart';
import 'package:abc2/button.dart/custombutton.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailOrUsername = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formStat = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/Lehbipage', // المسار لصفحة التسجيل
      (Route<dynamic> route) => false, // إزالة جميع الصفحات السابقة
    );
  }

  bool isLoading = false;

  // دالة لتسجيل الدخول باستخدام Firestore
  Future<void> signInWithUsernameOrEmail() async {
    if (formStat.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // البحث في Firestore عن المستخدم بواسطة البريد الإلكتروني أو اسم المستخدم
        String input = emailOrUsername.text;
        String userPassword = password.text;

        QuerySnapshot querySnapshot;
        // البحث إذا كان المدخل بريد إلكتروني
        if (input.contains('@')) {
          querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: input)
              .get();
        } else {
          // البحث إذا كان المدخل اسم مستخدم
          querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: input)
              .get();
        }

        if (querySnapshot.docs.isNotEmpty) {
          // استخراج معلومات المستخدم من المستند
          var userDoc = querySnapshot.docs.first;
          String email = userDoc['email'];

          // تسجيل الدخول باستخدام Firebase Authentication
          final userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: userPassword);

          // التحقق مما إذا كان البريد الإلكتروني موثقًا
          if (userCredential.user!.emailVerified) {
            // الانتقال إلى الصفحة الرئيسية
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Lehbipage()),
              (Route<dynamic> route) => false,
            );
          } else {
            // عرض رسالة تفيد بضرورة توثيق البريد الإلكتروني
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.rightSlide,
              title: 'Error',
              desc: 'Please verify your email',
            )..show();
          }
        } else {
          // في حال عدم العثور على المستخدم
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Account not found',
          )..show();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'Email not found',
            desc: 'Account not found. Please create a new account.',
          )..show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Incorrect password',
          )..show();
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'An error occurred during login',
          )..show();
        }
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
                          textAlign: TextAlign.left, // تغيير الاتجاه
                          style: TextStyle(
                            color: Color(0xFF005F99),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Username or Email',
                        textAlign: TextAlign.left, // تغيير الاتجاه
                        style: TextStyle(
                          color: Color(0xFF005F99),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),
                      Textformfield(
                        hintText: 'example@gmail.com',
                        mycontroller: emailOrUsername,
                        validator: (val) {
                          if (val == '') {
                            return 'Please enter your email or username.';
                          }
                          return null; // إذا كانت البيانات صحيحة
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Password',
                        textAlign: TextAlign.left, // تغيير الاتجاه
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
                            return 'Please enter your password.';
                          }
                          return null; // إذا كانت البيانات صحيحة
                        },
                      ),
                      // const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            if (emailOrUsername.text.isEmpty) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    'Please enter your email to reset your password.',
                              )..show();
                              return;
                            }
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: emailOrUsername.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: '',
                                desc:
                                    'A link to reset your password has been sent.',
                              )..show();
                            } catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Please make sure the email is correct.',
                              )..show();
                            }
                          },
                          child: const Text('Forgot your password?',
                              style: TextStyle(
                                color: Color(0xFF005F99),
                              )),
                        ),
                      ),
                      Custombutton(
                        title: 'Login',
                        onPressed: signInWithUsernameOrEmail,
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Or sign in with',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),

                      // إضافة الأيقونات
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // أيقونة تسجيل الدخول باستخدام Google
                          IconButton(
                            icon: const Icon(Icons.g_mobiledata,
                                color: Colors.red, size: 50),
                            onPressed: () async {
                              signInWithGoogle();
                              // استدعاء دالة تسجيل الدخول باستخدام Google
                            },
                          ),

                          const SizedBox(width: 20), // مسافة بين الأيقونات

                          // أيقونة تسجيل الدخول باستخدام Facebook
                          IconButton(
                            icon: const Icon(Icons.facebook,
                                color: Colors.blue, size: 40),
                            onPressed: () async {
                              // استدعاء دالة تسجيل الدخول باستخدام Facebook
                            },
                          ),

                          const SizedBox(width: 20), // مسافة بين الأيقونات

                          // أيقونة تسجيل الدخول باستخدام Twitter
                          IconButton(
                            icon: const Icon(Icons.alternate_email,
                                color: Colors.lightBlue, size: 40),
                            onPressed: () async {
                              // استدعاء دالة تسجيل الدخول باستخدام Twitter
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/signup', // المسار لصفحة التسجيل
                              (Route<dynamic> route) =>
                                  false, // إزالة جميع الصفحات السابقة
                            );
                          },
                          child: const Text(
                            'Dont have an account? Sign up now',
                            textAlign: TextAlign.left, // تغيير الاتجاه
                            style: TextStyle(
                              color: Color(0xFF005F99),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/MyHomePage', // المسار لصفحة الصفحة الرئيسية
                              (Route<dynamic> route) =>
                                  false, // إزالة جميع الصفحات السابقة
                            );
                          },
                          child: const Icon(
                            Icons.home, // أيقونة المنزل
                            color: Color(0xFF005F99), // لون الأيقونة
                            size: 30, // حجم الأيقونة
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
