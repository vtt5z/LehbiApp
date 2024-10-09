import 'package:flutter/material.dart';
import 'dart:math'; // To import the library for generating random numbers

class OrderPage extends StatelessWidget {
  final int orderNumber =
      Random().nextInt(1000000); // Generate a random invoice number

  OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thank you message
              const Text(
                'Thank you for your order!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Display the random invoice number
              Text(
                'Invoice Number: #$orderNumber',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Order completion message
              const Text(
                'Your order has been successfully completed! We are working hard to provide the best service.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Button to return to the Lehbipage
              ElevatedButton(
                onPressed: () {
                  // Navigate to Lehbipage using a specific route
                  Navigator.pushReplacementNamed(context, '/Lehbipage');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005F99),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Shop Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
