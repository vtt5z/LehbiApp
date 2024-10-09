import 'package:abc2/appHome/location.dart';
import 'package:abc2/appHome/pharmacy.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts; // المنتجات المختارة

  const Cart({super.key, required this.selectedProducts});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  late List<Map<String, dynamic>> cartProducts;

  @override
  void initState() {
    super.initState();
    cartProducts = []; // بدء قائمة المنتجات فارغة
    for (var product in widget.selectedProducts) {
      _addToCart(product); // إضافة المنتجات باستخدام الدالة المعدلة
    }
  }

  void _addToCart(Map<String, dynamic> product) {
    final existingProductIndex =
        cartProducts.indexWhere((item) => item['name'] == product['name']);

    if (existingProductIndex != -1) {
      setState(() {
        cartProducts[existingProductIndex]['quantity']++;
      });
    } else {
      setState(() {
        cartProducts.add({
          ...product,
          'quantity': 1, // الكمية المبدئية لكل منتج
        });
      });
    }
  }

  void _increaseQuantity(int index) {
    setState(() {
      cartProducts[index]['quantity']++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (cartProducts[index]['quantity'] > 1) {
        cartProducts[index]['quantity']--;
      } else {
        cartProducts.removeAt(index);
      }
    });
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    for (var product in cartProducts) {
      total += product['price'] * product['quantity'];
    }
    return total;
  }

  double _calculateTax(double total) {
    return total * 0.15; // 15% ضريبة
  }

  double _calculateFinalTotal(double total, double tax) {
    return total + tax; // الإجمالي بعد إضافة الضريبة
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice();
    double taxAmount = _calculateTax(totalPrice);
    double finalTotal = _calculateFinalTotal(totalPrice, taxAmount);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF005F99),
        title: const Center(
            child: Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005F99), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: cartProducts.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text('There are no products in the cart'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PharmacyPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005F99),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Go Shopping',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProducts.length,
                      itemBuilder: (context, index) {
                        final product = cartProducts[index];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: Image.asset(
                              product['images'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text('Rs.${product['price']}'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _decreaseQuantity(index);
                                      },
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
                                    ),
                                    Text('${product['quantity']}'),
                                    IconButton(
                                      onPressed: () {
                                        _increaseQuantity(index);
                                      },
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Rs.${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Value Added Tax (15%):',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Rs.${taxAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery:',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Free',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Final Total:',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Rs.${finalTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // تمرير قائمة المنتجات إلى صفحة Location
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Location(
                              cartProducts: cartProducts), // تمرير المعلومات
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005F99),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Order',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
