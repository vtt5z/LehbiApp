import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome library

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Padding around the card
      child: Card(
        color: Colors.white, // Card background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 6.0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize:
                MainAxisSize.min, // Keeps size appropriate without stretching
            children: [
              Text(
                'Al-Lahabi Medical Hospital',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                'King Abdulaziz Road, Al-Mursalat, 7415, Riyadh',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(),
              Text(
                'About the Hospital',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color
                ),
              ),
              Text(
                'Al-Lahabi Medical Hospital specializes in providing healthcare services for dialysis patients. We offer a comfortable treatment environment with international standards to ensure the best healthcare for kidney patients, focusing on improving their quality of life and providing necessary treatments using modern and advanced methods.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialMediaIcon(
                    icon: FontAwesomeIcons.facebook,
                    onPressed: () => print('Facebook icon pressed'),
                    color: Color(0xFF3b5998),
                  ),
                  SocialMediaIcon(
                    icon: FontAwesomeIcons.twitter,
                    onPressed: () => print('Twitter icon pressed'),
                    color: Color(0xFF00acee),
                  ),
                  SocialMediaIcon(
                    icon: FontAwesomeIcons.instagram,
                    onPressed: () => print('Instagram icon pressed'),
                    color: Color(0xFFC13584),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialMediaIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const SocialMediaIcon({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color,
      iconSize: 32.0,
    );
  }
}
