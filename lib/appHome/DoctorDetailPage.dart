import 'package:flutter/material.dart';

class DoctorDetailPage extends StatelessWidget {
  final String doctorName;
  final String doctorSpecialty;
  final String imageUrl;
  final String bio;

  const DoctorDetailPage({
    Key? key,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.imageUrl,
    required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Doctor Details"),
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
        child: SingleChildScrollView(
          // Wrap the body in a SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor's image
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(imageUrl),
                  ),
                ),
                const SizedBox(height: 16),
                // Doctor's name
                Center(
                  child: Text(
                    doctorName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Doctor's specialty
                Center(
                  child: Text(
                    doctorSpecialty,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Bio Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      bio,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Action Cards
                Text(
                  "Actions:",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Regular Call Card
                    _buildActionCard(
                      context,
                      Icons.call,
                      "Call",
                      () {
                        // Call action
                        print("Calling ${doctorName}");
                      },
                    ),
                    // Video Call Card
                    _buildActionCard(
                      context,
                      Icons.videocam,
                      "Video Call",
                      () {
                        // Video call action
                        print("Video calling ${doctorName}");
                      },
                    ),
                    // Share Card
                    _buildActionCard(
                      context,
                      Icons.share,
                      "Share",
                      () {
                        // Share action
                        print("Sharing ${doctorName}'s info");
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Appointment Days
                Text(
                  "Appointment Availability:",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildAppointmentCard("Monday", "11 AM - 4 PM"),
                _buildAppointmentCard("Tuesday", "8 AM - 2 PM"),
                _buildAppointmentCard("Wednesday", "9 AM - 4 PM"),
                _buildAppointmentCard("Thursday", "12 AM - 4 PM"),
                _buildAppointmentCard("Friday", "10 AM - 4 PM"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build action cards
  Widget _buildActionCard(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: const Color(0xFF005F99)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build appointment cards
  Widget _buildAppointmentCard(String day, String time) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(day),
        subtitle: Text(time),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Handle appointment selection
          print("Selected appointment for $day");
        },
      ),
    );
  }
}
