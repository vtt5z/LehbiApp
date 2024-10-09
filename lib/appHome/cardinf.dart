import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ServicesSection extends StatelessWidget {
  final List<ServiceItem> services = [
    ServiceItem(
      title: 'Home Visit Services',
      description:
          'We provide comprehensive healthcare services for patients in their homes to ensure their comfort.',
      imageUrl:
          'lib/assets/helthecare/Homevisit.jpg', // Ensure the image path is correct
    ),
    ServiceItem(
      title: 'In-Hospital Care',
      description:
          'Providing comprehensive care for patients during their stay in the hospital.',
      imageUrl:
          'lib/assets/helthecare/Inpatientcare.jpg', // Ensure the image path is correct
    ),
    ServiceItem(
      title: 'Laboratory Services',
      description:
          'Offering a variety of laboratory tests to analyze health conditions.',
      imageUrl:
          'lib/assets/helthecare/Laboratoryservices.jpg', // Ensure the image path is correct
    ),
    ServiceItem(
      title: 'Pharmacy Services',
      description:
          'Providing integrated health services and consultations on the proper use of medications.',
      imageUrl:
          'lib/assets/helthecare/delevery.jpg', // Ensure the image path is correct
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          TextDirection.ltr, // Change text direction to left-to-right
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 60,
            child: Card(
              elevation: 30,
              color: Color(0xFF004F89),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft, // Align title to the left
                  child: Text(
                    "Our Services",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 280, // Height of the card
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ServiceCard(service: services[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceItem service;

  const ServiceCard({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Width of the card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              service.imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft, // Align title to the left
                  child: Text(
                    service.title,
                    textAlign: TextAlign.left, // Align text to the left
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment:
                      Alignment.centerLeft, // Align description to the left
                  child: Text(
                    service.description,
                    textAlign: TextAlign.left, // Align text to the left
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceItem {
  final String title;
  final String description;
  final String imageUrl;

  ServiceItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
