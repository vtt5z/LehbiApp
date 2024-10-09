import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // إضافة مكتبة Firebase

class Infmid extends StatefulWidget {
  const Infmid({
    super.key,
    this.datapage,
    this.name,
    this.price,
    this.rating,
    this.description,
    this.expiryDate,
  });

  final List<String>? datapage;
  final String? name;
  final double? price;
  final double? rating;
  final String? description;
  final String? expiryDate;

  @override
  State<Infmid> createState() => _InfmidState();
}

class _InfmidState extends State<Infmid> {
  int point = 0;
  double userRating = 0.0; // متغير لحفظ التقييم الجديد
  bool showAllComments = false; // متغير للتحكم بعرض جميع التعليقات
  final TextEditingController _commentController = TextEditingController();

  // افتراضيًا عرض 3 تعليقات فقط
  int initialCommentsCount = 3;

  // قائمة افتراضية للتعليقات - سيتم استبدالها بالتعليقات من Firebase
  final List<Map<String, String>> comments = List.generate(20, (index) {
    return {
      'name': 'User $index',
      'comment': 'This is a sample comment $index',
      'time': '${index + 1} days ago',
    };
  });

  Widget _buildRatingBar(int starLevel, int count) {
    return Row(
      children: [
        Text(
          starLevel.toString(),
          style: const TextStyle(fontSize: 16),
        ),
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              widthFactor: count > 0 ? count / 100 : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text('$count'),
      ],
    );
  }

  Future<void> _submitComment() async {
    String comment = _commentController.text;
    if (comment.isNotEmpty) {
      // حفظ التعليق في Firebase
      await FirebaseFirestore.instance.collection('comments').add({
        'name': 'New User',
        'comment': comment,
        'rating': userRating,
        'time': DateTime.now().toString(),
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF005F99),
        title: Text(widget.name ?? 'Product Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005F99), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عرض الصور
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    child: PageView.builder(
                      onPageChanged: (index) {
                        setState(() {
                          point = index;
                        });
                      },
                      itemCount: widget.datapage?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          widget.datapage?[index] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < (widget.datapage?.length ?? 0); i++)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: point == i
                            ? const Color.fromARGB(255, 31, 34, 206)
                            : const Color.fromARGB(255, 223, 230, 236),
                      ),
                      height: 10,
                      width: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.name ?? 'Unknown Product',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.description ?? 'No description available.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Expiry Date: ${widget.expiryDate ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              // عرض التقييمات
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                                Text(
                                  '${widget.rating?.toStringAsFixed(1) ?? '0.0'}',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            const Text('923 Ratings and \n257 Reviews'),
                          ],
                        ),
                        const SizedBox(width: 10),
                        const VerticalDivider(
                          thickness: 1,
                          color: Colors.grey,
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRatingBar(5, 67),
                              _buildRatingBar(4, 20),
                              _buildRatingBar(3, 7),
                              _buildRatingBar(2, 0),
                              _buildRatingBar(1, 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              // عرض التعليقات
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Reviews:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...comments
                        .take(showAllComments
                            ? comments.length
                            : initialCommentsCount)
                        .map((comment) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.account_circle, size: 40),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment['name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      comment['time']!,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(comment['comment']!),
                          ],
                        ),
                      );
                    }).toList(),
                    if (!showAllComments)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showAllComments = true;
                          });
                        },
                        child: const Text('View more reviews'),
                      ),
                    const SizedBox(height: 20),
                    const Divider(),
                    // مربع إضافة التقييم
                    const Text(
                      'Rate this product:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          userRating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a review...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _submitComment,
                      child: Center(child: const Text('Submit Review')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
