import 'package:abc2/appHome/DoctorDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDetailPage extends StatefulWidget {
  final String doctorId; // Doctor ID
  final String userId; // User ID
  final String doctorName;
  final String doctorSpecialty;
  final String imageUrl;
  final String bio; // Added bio field

  const ChatDetailPage({
    Key? key,
    required this.doctorId,
    required this.userId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.imageUrl,
    required this.bio, // Adding the field here
  }) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isResponseSent = false; // Flag to track if response has been sent

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      String message = _controller.text;

      try {
        // Send user's message
        await FirebaseFirestore.instance
            .collection('doctor_messages_${widget.doctorId}')
            .add({
          'text': message,
          'senderId': widget.userId, // User ID
          'receiverId': widget.doctorId, // Doctor ID
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Check if the automatic response has not been sent
        if (!_isResponseSent) {
          // Send automated response from the hospital
          await FirebaseFirestore.instance
              .collection('doctor_messages_${widget.doctorId}')
              .add({
            'text': "The doctor will respond shortly.",
            'senderId': "hospital", // Indicating response from hospital
            'receiverId': widget.doctorId, // Doctor ID
            'timestamp': FieldValue.serverTimestamp(),
          });

          // Set the flag to true to prevent multiple responses
          _isResponseSent = true;
        }
      } catch (e) {
        print("Error sending message: $e");
      }

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(widget.imageUrl),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Pass doctor info to DoctorDetailPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailPage(
                        doctorName: widget.doctorName,
                        doctorSpecialty: widget.doctorSpecialty,
                        imageUrl: widget.imageUrl,
                        bio: widget.bio, // Passing the bio here
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctorName,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 248, 248, 248),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.doctorSpecialty,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 248, 248, 248),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              onPressed: () {
                // Handle the call action
                print("Calling ${widget.doctorName}");
              },
            ),
            IconButton(
              icon: const Icon(Icons.videocam, color: Colors.white),
              onPressed: () {
                // Handle the video call action
                print("Video calling ${widget.doctorName}");
              },
            ),
          ],
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('doctor_messages_${widget.doctorId}')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No messages yet."));
                    }

                    final messages = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isUser = message['senderId'] == widget.userId;
                        final isHospital = message['senderId'] ==
                            "hospital"; // Check if the message is from the hospital

                        return Align(
                          alignment: isUser
                              ? Alignment.centerLeft // User messages on left
                              : Alignment
                                  .centerRight, // Doctor/hospital messages on right
                          child: Column(
                            crossAxisAlignment: isUser
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.all(10),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Colors.blue[100]
                                      : isHospital
                                          ? Colors.green[
                                              100] // Hospital message color
                                          : Colors.grey[
                                              300], // Doctor message color
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  message['text'] ?? '',
                                  style: TextStyle(
                                    color:
                                        isUser ? Colors.black : Colors.black87,
                                  ),
                                  softWrap: true,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Stack(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        color: Colors.blue,
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
