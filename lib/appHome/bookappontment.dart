import 'package:abc2/button.dart/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = "+962";
  DateTime? _selectedDateTime;
  String? _problemDescription;
  String? _selectedDoctorId;
  String? _selectedDoctorName;
  String? _selectedDoctorImageUrl;
  List<Map<String, dynamic>> _doctors = [];

  final PageController _pageController = PageController();
  final List<Map<String, String>> _faqList = [
    {
      "title": "What information do you need to book an appointment?",
      "description": "We need your full name, email address, and phone number."
    },
    {
      "title": "I want to change the time or date of my appointment?",
      "description":
          "We understand that things may happen at the last minute. If something comes up and you need to change your appointment, please call customer service, and we will assist you with the rescheduling."
    },
    {
      "title": "Should I arrive before my appointment?",
      "description":
          "You can arrive right on time if you don't have time, but we prefer that you come a few minutes early."
    },
    {
      "title": "I feel scared when I'm alone; can I bring someone with me?",
      "description":
          "Of course, you can. At Al-Lahbi Medical, we care that you feel at home, and we are honored to have any friend or family member accompany you. We also recommend bringing someone along for procedures that take longer."
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('employees').get();
    setState(() {
      _doctors = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['doctorName'],
                'imageUrl': doc['imageUrl'],
              })
          .toList();
    });
  }

  void _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveAppointmentToDatabase() async {
    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phone': '$_selectedCountryCode${_phoneController.text}',
        'appointmentDate': _selectedDateTime,
        'doctorId': _selectedDoctorId,
        'doctorName': _selectedDoctorName,
        'problemDescription': _problemDescription ?? 'Not available'
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save the appointment: $error')),
      );
    }
  }

  void _sendEmail(String email, String appointmentDetails) async {
    final Email sendEmail = Email(
      body: appointmentDetails,
      subject: 'Appointment booked successfully',
      recipients: [email, 'mhamad2129@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(sendEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sent successfully')),
      );
    } catch (error) {
      if (error.toString().contains('not_available')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending email: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: const Color(0xFF005F99),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005F99), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.7, // تعيين ارتفاع مناسب
                  child: PageView(
                    controller: _pageController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedDoctorId,
                              hint: const Text('Choose Your Doctor'),
                              items: _doctors.map((doctor) {
                                return DropdownMenuItem<String>(
                                  value: doctor['id'],
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'lib/assets/doctorAli.jpg'),
                                        radius: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(doctor['name']),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDoctorId = value;
                                  final selectedDoctor = _doctors.firstWhere(
                                      (doctor) => doctor['id'] == value);
                                  _selectedDoctorName = selectedDoctor['name'];
                                  _selectedDoctorImageUrl =
                                      selectedDoctor['imageUrl'];
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _fullNameController,
                              decoration: const InputDecoration(
                                labelText: 'Full name',
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CountryCodePicker(
                                    onChanged: (code) {
                                      setState(() {
                                        _selectedCountryCode = code.dialCode!;
                                      });
                                    },
                                    initialSelection: 'JO',
                                    showCountryOnly: true,
                                    showOnlyCountryWhenClosed: true,
                                    favorite: ['+962', '+1', '+44'],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                      labelText: 'Phone Number',
                                      border: OutlineInputBorder(),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: InkWell(
                                  onTap: () => _selectDateTime(context),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedDateTime == null
                                            ? 'Select Appointment Date'
                                            : 'Appointment Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(_selectedDateTime!)}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const Icon(Icons.calendar_today,
                                          color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              onChanged: (value) {
                                _problemDescription = value;
                              },
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Problem Description',
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Custombutton(
                              title: 'Sent',
                              onPressed: () {
                                if (_fullNameController.text.isNotEmpty &&
                                    _emailController.text.isNotEmpty &&
                                    _phoneController.text.isNotEmpty &&
                                    _selectedDateTime != null &&
                                    _selectedDoctorId != null) {
                                  String appointmentDetails = '''
                    Name: ${_fullNameController.text}
                    Email: ${_emailController.text}
                    Phone Number: $_selectedCountryCode${_phoneController.text}
                    Appointment Date: ${_selectedDateTime!.toLocal().toString().split(' ')[0]}
                    Doctor: $_selectedDoctorName
                    Problem Description: ${_problemDescription ?? 'None'}
                  ''';
                                  _sendEmail(_emailController.text,
                                      appointmentDetails);
                                  _saveAppointmentToDatabase();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please fill in all required fields')),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      // يمكن إضافة صفحة الأسئلة المتكررة هنا
                      ListView.builder(
                        itemCount: _faqList.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            title: Text(_faqList[index]['title']!),
                            children: [Text(_faqList[index]['description']!)],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: 2,
              effect: const ExpandingDotsEffect(
                activeDotColor: Colors.blue,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
