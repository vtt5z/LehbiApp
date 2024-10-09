import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add this line
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName = "User Name"; // User name
  String email = "Email Address"; // Email address
  String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  File? _profileImage;
  String? _profileImageUrl; // Variable to store image URL
  final TextEditingController _nameController = TextEditingController();
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userData.exists) {
        setState(() {
          displayName = userData['fullName'] ?? "User Name"; // User name
          email = userData['email'] ?? "Email Address"; // Email address
          // Load image if it exists
          if (userData['profileImageUrl'] != null) {
            _profileImageUrl = userData['profileImageUrl']; // Save URL
          }
        });
      }
    } catch (e) {
      setState(() {
        displayName = FirebaseAuth.instance.currentUser?.displayName ??
            "User Name"; // User name
        email = FirebaseAuth.instance.currentUser?.email ??
            "Email Address"; // Email address
      });
    }
  }

  Future<void> _updateName() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fullName': _nameController.text,
      });
      setState(() {
        displayName = _nameController.text;
      });
      _nameController.clear();
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      await _uploadImage(); // Upload image after selection
    }
  }

  Future<void> _uploadImage() async {
    if (_profileImage != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref();
        final imageRef = storageRef.child('profile_images/$userId.jpg');

        // Upload the image
        await imageRef.putFile(_profileImage!);

        // Get the image URL
        String downloadUrl = await imageRef.getDownloadURL();

        // Update image URL in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'profileImageUrl': downloadUrl,
        });

        setState(() {
          _profileImageUrl = downloadUrl; // Update displayed URL
        });

        print("Image uploaded successfully: $downloadUrl");
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = displayName; // Update name in the TextField

    return Scaffold(
      // الانتقال إلى TestsPage
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005F99), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                children: [
                  // Profile image
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!) // Use NetworkImage
                        : null,
                    child: _profileImageUrl == null
                        ? const Icon(Icons.person,
                            size: 50, color: Colors.white)
                        : null,
                  ),
                  // Edit image button
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      // ignore: prefer_const_constructors
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: const Icon(Icons.edit,
                            size: 20, color: Color(0xFF005F99)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const Divider(height: 40, thickness: 2),
              _buildProfileCard(
                title: 'Edit Name', // Edit name
                icon: Icons.edit,
                color: const Color(0xFF005F99),
                onTap: () => _showEditNameDialog(),
              ),
              _buildProfileCard(
                title: 'Orders', // Orders
                icon: Icons.shopping_cart,
                color: Colors.green,
                onTap: () {
                  // You can navigate the user to the shopping cart page here
                },
              ),
              _buildProfileCard(
                title: 'Health File', // Health file
                icon: Icons.folder_shared,
                color: Colors.red,
                onTap: () {
                  // You can navigate the user to the health file page here
                },
              ),
              _buildProfileCard(
                title: 'Doctor Appointments', // Doctor appointments
                icon: Icons.calendar_today,
                color: Colors.orange,
                onTap: () {
                  // You can navigate the user to the appointments page here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'), // Edit name
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Enter New Name', // Enter new name
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateName();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005F99),
              ),
              child: const Text('Save'), // Save
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'), // Cancel
            ),
          ],
        );
      },
    );
  }
}
