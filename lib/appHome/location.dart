import 'package:abc2/appHome/cart.dart';
import 'package:abc2/appHome/order.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Location extends StatefulWidget {
  final List<Map<String, dynamic>> cartProducts;

  const Location({Key? key, required this.cartProducts}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String? selectedCountry;
  String? selectedCity;
  String? selectedArea;
  String? street;
  String? houseNumber;
  String? description;
  String? postalCode;

  final Map<String, List<String>> cities = {
    'مصر': ['القاهرة', 'الإسكندرية'],
    'السعودية': ['الرياض', 'جدة'],
    'الأردن': ['عمان', 'إربد'],
  };

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // حواف دائرية للCard
          ),
          backgroundColor: const Color(0xFF005F99), // لون الخلفية الأزرق الغامق
          title: const Center(
              child: Text(
            'Location', // الموقع
            style: TextStyle(
              color: Colors.white, // لون النص أبيض
              fontWeight: FontWeight.bold, // وزن الخط عريض
              fontSize: 18, // حجم الخط 18
            ),
          )),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CountryListPick(
                  appBar: AppBar(
                    title: const Text('Select Country'), // اختر الدولة
                  ),
                  initialSelection: '+20',
                  onChanged: (code) {
                    setState(() {
                      selectedCountry = code?.name;
                      selectedCity =
                          null; // إعادة تعيين المدينة عند تغيير الدولة
                    });
                  },
                ),
                if (selectedCountry != null) ...[
                  DropdownButton<String>(
                    hint: const Text('Select City'), // اختر المدينة
                    value: selectedCity,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCity = newValue;
                      });
                    },
                    items: cities[selectedCountry]!.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 10), // Space between fields
                _buildTextField(
                    'Neighborhood', (value) => selectedArea = value), // الحي
                const SizedBox(height: 10),
                _buildTextField('Street', (value) => street = value), // الشارع
                const SizedBox(height: 10),
                _buildTextField('House Number',
                    (value) => houseNumber = value), // رقم البيت
                const SizedBox(height: 10),
                _buildTextField('Additional Description',
                    (value) => description = value), // وصف آخر
                const SizedBox(height: 10),
                _buildTextField('Postal Code',
                    (value) => postalCode = value), // الكود البريدي
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _saveLocationData();
                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
              child: const Text(
                'Save Information', // حفظ المعلومات
                style: TextStyle(color: Colors.white), // لون النص أبيض
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
              child: const Text(
                'Cancel', // إلغاء
                style: TextStyle(color: Colors.white), // لون النص أبيض
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveLocationData() {
    // تخزين البيانات في Firebase
    final locationData = {
      'country': selectedCountry,
      'city': selectedCity,
      'area': selectedArea,
      'street': street,
      'house_number': houseNumber,
      'description': description,
      'postal_code': postalCode,
    };

    _databaseReference
        .child('locations/${FirebaseAuth.instance.currentUser?.uid}')
        .set(locationData);
    print(
        'Information saved: $locationData'); // تم حفظ المعلومات: $locationData
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
    );
  }

  void _showPaymentDialog() {
    String selectedPaymentMethod = 'Cash';
    // القيمة الافتراضية

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16), // حواف دائرية لمربع الحوار
              ),
              backgroundColor: const Color(
                  0xFF005F99), // خلفية مربع الحوار باللون الأزرق الغامق
              // title: const Center(
              //   child: Text(
              //     'اختر طريقة الدفع',
              //     style: TextStyle(
              //       color: Colors.white, // لون النص الأبيض
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.money, color: Colors.white),
                    title: const Text(
                      'Cash',
                      style: TextStyle(
                        color: Colors.white, // لون النص الأبيض
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tileColor:
                        const Color(0xFF004F89), // خلفية الCard بلون أزرق غامق
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // حواف دائرية للCard
                    ),
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = 'Cash';
                      });
                      Navigator.of(context).pop(); // إغلاق مربع الحوار
                    },
                    selected: selectedPaymentMethod == 'Cash',
                    selectedTileColor:
                        Colors.blueGrey, // تغيير اللون عند التحديد
                  ),
                  const Divider(
                    color: Colors.white, // لون الخط الفاصل أبيض
                    thickness: 1.0,
                  ),
                  ListTile(
                    leading: const Icon(Icons.credit_card, color: Colors.white),
                    title: const Text(
                      'Card',
                      style: TextStyle(
                        color: Colors.white, // لون النص الأبيض
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tileColor:
                        const Color(0xFF004F89), // خلفية البطاقة بلون أزرق غامق
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // حواف دائرية للبطاقة
                    ),
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = 'Card';
                      });
                      Navigator.of(context).pop(); // إغلاق مربع الحوار
                      _showCardInfoDialog(); // عرض مربع حوار معلومات البطاقة
                    },
                    selected: selectedPaymentMethod == 'Card',
                    selectedTileColor:
                        Colors.blueGrey, // تغيير اللون عند التحديد
                  ),
                ],
              ),
              // actions: [
              //   TextButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: const Text(
              //       'إلغاء',
              //       style: TextStyle(color: Colors.white), // لون النص أبيض
              //     ),
              //   ),
              // ],
            );
          },
        );
      },
    );
  }

  void _showCardInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String cardNumber = '';
        String cardHolder = '';
        String expiryDate = '';

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // حواف دائرية لمربع الحوار
          ),
          backgroundColor:
              const Color(0xFF005F99), // خلفية الCard بنفس اللون الأزرق
          title: const Center(
            child: Text(
              'Card Information', // The text that will be displayed
              style: TextStyle(
                color: Colors.white, // Text color is white
                fontWeight: FontWeight.bold, // Make the text bold
                fontSize: 18, // Text size
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Card Number', (value) => cardNumber = value),
              const SizedBox(height: 10), // Space between fields
              _buildTextField('Cardholder Name', (value) => cardHolder = value),
              const SizedBox(height: 10),
              _buildTextField(
                  'Expiration Date (MM/YY)', (value) => expiryDate = value),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Validate the fields
                if (cardNumber.isEmpty ||
                    cardHolder.isEmpty ||
                    expiryDate.isEmpty) {
                  // Show an error message if any fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields before saving.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // You can store the card information or perform any other action here
                  print('Card Number: $cardNumber');
                  print('Cardholder Name: $cardHolder');
                  print('Expiration Date: $expiryDate');
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white), // Text color is white
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white), // لون النص أبيض
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF005F99),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Cart(
                  selectedProducts: [],
                ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
              const SizedBox(height: 10),
              _buildSelectedProductsCard(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _showLocationDialog,
                child: Card(
                  color: const Color(0xFF005F99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Select your location',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildPaymentMethodCard(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderPage(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005F99),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Order Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedProductsCard() {
    return Card(
      color: const Color(0xFF005F99),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: widget.cartProducts.map((product) {
            return ListTile(
              title: Text(
                product['name'],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Quantity: ${product['quantity']}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                'Rs.${product['price']}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return GestureDetector(
      onTap: _showPaymentDialog,
      child: Card(
        color: const Color(0xFF005F99),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text('Choose Payment Method',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
