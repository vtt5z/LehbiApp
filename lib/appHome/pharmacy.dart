import 'package:abc2/appHome/cart.dart';
import 'package:flutter/material.dart';
import 'infmid.dart'; // تأكد من استيراد صفحة Infmid

class PharmacyPage extends StatefulWidget {
  PharmacyPage({Key? key}) : super(key: key);

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  final List<Map<String, dynamic>> products = [
    {
      'images': 'lib/assets/Z.png',
      'name': 'Ibuprofen 900mg',
      'price': 70.00,
      'rating': 4.3,
      'datapage': [
        'lib/assets/p.png',
        'lib/assets/p.png',
      ],
      'description':
          'Ibuprofen is a nonsteroidal anti-inflammatory drug (NSAID) that reduces pain, fever, and inflammation. It is commonly used for headaches, toothaches, and menstrual cramps.',
      'expiryDate': '20/04/2027',
    },
    {
      'images': 'lib/assets/Z.png',
      'name': 'Ibuprofen 400mg',
      'price': 45.00,
      'rating': 4.3,
      'datapage': [
        'lib/assets/p.png',
        'lib/assets/p.png',
      ],
      'description':
          'Ibuprofen is a nonsteroidal anti-inflammatory drug (NSAID) that reduces pain, fever, and inflammation. It is commonly used for headaches, toothaches, and menstrual cramps.',
      'expiryDate': '20/04/2027',
    },
    {
      'images': 'lib/assets/Medsan/W.jpg',
      'name': 'Accu-check Active',
      'price': 112.99,
      'rating': 4.5,
      'datapage': [
        'lib/assets/Medsan/W.jpg',
        'lib/assets/Medsan/W1.jpg',
        'lib/assets/Medsan/W11.jpg',
      ],
      'description':
          'Dr. Reckeweg R41 Fortivirone Drops 22 ml is a homeopathic remedy specifically formulated to address sexual dysfunction in both men and women.',
      'expiryDate': '25/12/2028',
    },
    {
      'images': 'lib/assets/Medsan/W.jpg',
      'name': 'Accu-check',
      'price': 111.99,
      'rating': 4.5,
      'datapage': [
        'lib/assets/Medsan/W.jpg',
        'lib/assets/Medsan/W1.jpg',
        'lib/assets/Medsan/W11.jpg',
      ],
      'description':
          'Dr. Reckeweg R41 Fortivirone Drops 22 ml is a homeopathic remedy specifically formulated to address sexual dysfunction in both men and women.',
      'expiryDate': '25/12/2028',
    },
    {
      'images': 'lib/assets/Medsan/W.jpg',
      'name': 'Accu Active',
      'price': 299.99,
      'rating': 4.5,
      'datapage': [
        'lib/assets/Medsan/W.jpg',
        'lib/assets/Medsan/W1.jpg',
        'lib/assets/Medsan/W11.jpg',
      ],
      'description':
          'Dr. Reckeweg R41 Fortivirone Drops 22 ml is a homeopathic remedy specifically formulated to address sexual dysfunction in both men and women.',
      'expiryDate': '25/12/2028',
    },
    {
      'images': 'lib/assets/Medsan/M1.jpg',
      'name': 'Paracetamol 500mg',
      'price': 25.50,
      'rating': 4.7,
      'datapage': [
        'lib/assets/Medsan/M1.jpg',
        'lib/assets/Medsan/M11.jpg',
        'lib/assets/Medsan/M111.jpg',
      ],
      'description':
          'Paracetamol is a pain reliever and a fever reducer. It is used to treat mild to moderate pain and is often recommended for headaches and muscle aches.',
      'expiryDate': '30/11/2025',
    },
    {
      'images': 'lib/assets/p.png',
      'name': 'Amoxicillin 250mg',
      'price': 60.00,
      'rating': 4.0,
      'datapage': [
        'lib/assets/p.png',
        'lib/assets/p.png',
        'lib/assets/p.png',
      ],
      'description':
          'Amoxicillin is a penicillin antibiotic that fights bacteria in the body. It is used to treat various infections including ear infections and urinary tract infections.',
      'expiryDate': '15/03/2026',
    },
    {
      'images': 'lib/assets/Z.png',
      'name': 'Ibuprofen 400mg',
      'price': 30.00,
      'rating': 4.3,
      'datapage': [
        'lib/assets/p.png',
        'lib/assets/p.png',
      ],
      'description':
          'Ibuprofen is a nonsteroidal anti-inflammatory drug (NSAID) that reduces pain, fever, and inflammation. It is commonly used for headaches, toothaches, and menstrual cramps.',
      'expiryDate': '20/04/2027',
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> cartProducts = []; // قائمة المنتجات في العربة
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = products; // عرض جميع المنتجات في البداية
  }

  void _searchProduct() {
    String query = searchController.text;
    setState(() {
      filteredProducts = products
          .where((product) =>
              product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cartProducts.add(product); // إضافة المنتج إلى العربة
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF005F99), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Header with greeting and search bar
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        decoration: const BoxDecoration(
                          color: Color(0xFF005F99),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Welcome to Lehbi pharmacy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            TextField(
                              controller: searchController,
                              onChanged: (value) {
                                _searchProduct(); // البحث عند كل تغيير في النص
                              },
                              decoration: InputDecoration(
                                hintText: 'search for medicine',
                                hintStyle: const TextStyle(color: Colors.grey),
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Product GridView
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Infmid(
                                  datapage: product['datapage'],
                                  name: product['name'],
                                  price: product['price'],
                                  rating: product['rating'],
                                  description: product['description'],
                                  expiryDate: product['expiryDate'],
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        product['images'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text('Rs.${product['price']}'),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${product['rating']}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _addToCart(
                                        product); // إضافة المنتج إلى العربة
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.all(6),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Color(0xFF005F99),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // زر العربة الثابت في الأسفل
          Positioned(
            bottom: 20,
            right: 20,
            child: Stack(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            Cart(selectedProducts: cartProducts),
                      ),
                      (Route<dynamic> route) =>
                          false, // هذا الشرط يقوم بإزالة جميع الصفحات السابقة من المكدس
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Color(0xFF005F99),
                  ),
                ),
                // عدّاد المنتجات المضافة
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartProducts.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
