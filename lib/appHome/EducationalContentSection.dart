import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HealthRecipesSection extends StatefulWidget {
  @override
  _HealthRecipesSectionState createState() => _HealthRecipesSectionState();
}

class _HealthRecipesSectionState extends State<HealthRecipesSection> {
  final List<RecipeTip> recipeTips = [
    RecipeTip(
      imageUrl: 'lib/assets/slotles.jpg',
      tip: 'Eat more fresh fruits and vegetables.',
    ),
    RecipeTip(
      imageUrl: 'lib/assets/slotles.jpg',
      tip: 'Choose low-sodium foods to reduce blood pressure.',
    ),
    RecipeTip(
      imageUrl: 'lib/assets/water.jpg',
      tip: 'Drink water regularly, but don’t overdo fluids.',
    ),
    RecipeTip(
      imageUrl: 'lib/assets/slotles.jpg',
      tip: 'Choose plant-based proteins to lessen the burden on kidneys.',
    ),
    RecipeTip(
      imageUrl: 'lib/assets/slotles.jpg',
      tip: 'Avoid processed foods and fast meals.',
    ),
    RecipeTip(
      imageUrl: 'lib/assets/slotles.jpg',
      tip: 'Use herbs and spices to enhance flavor without adding salt.',
    ),
    RecipeTip(
      imageUrl: 'lib/assets/fruits.jpg',
      tip: 'Choose fiber-rich foods to promote good digestion.',
    ),
  ];

  int currentTipIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTipRotation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTipRotation() {
    _timer = Timer.periodic(Duration(seconds: 8), (Timer timer) {
      setState(() {
        currentTipIndex = (currentTipIndex + 1) % recipeTips.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Healthy Recipe Tips",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Display the current image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                recipeTips[currentTipIndex].imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            // Display the current tip
            Text(
              recipeTips[currentTipIndex].tip,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Circular indicator below the tips
            SmoothIndicator(
              currentTipIndex: currentTipIndex,
              count: recipeTips.length,
            ),
          ],
        ),
      ),
    );
  }
}

// Circular indicator for controlling tips
class SmoothIndicator extends StatelessWidget {
  final int currentTipIndex;
  final int count;

  const SmoothIndicator({
    required this.currentTipIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: PageController(initialPage: currentTipIndex),
      count: count,
      effect: ExpandingDotsEffect(
        dotHeight: 8.0,
        dotWidth: 8.0,
        activeDotColor: Colors.blue,
        dotColor: Colors.grey,
      ),
    );
  }
}

class RecipeTip {
  final String imageUrl;
  final String tip;

  RecipeTip({
    required this.imageUrl,
    required this.tip,
  });
}
