import 'package:flutter/material.dart';

class HalalFoodCheckerScreen extends StatefulWidget {
  const HalalFoodCheckerScreen({super.key});

  @override
  _HalalFoodCheckerScreenState createState() => _HalalFoodCheckerScreenState();
}

class _HalalFoodCheckerScreenState extends State<HalalFoodCheckerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _halalStatus = '';
  bool _isHalal = false;
  bool _hasResult = false;

  //  list of food items
  final Map<String, bool> _foodData = {
    // Common Halal Animals
    'chicken': true,
    'beef': true,
    'lamb': true,
    'mutton': true,
    'goat': true,
    'camel': true,
    'duck': true,
    'turkey': true,
    'rabbit': true,
    'deer': true,

    // Common Haram Animals
    'pork': false,
    'dog': false,
    'cat': false,
    'donkey': false,
    'horse': false,
    'rat': false,
    'bat': false,

    // Seafood (Halal)
    'fish': true,
    'shrimp': true,
    'prawn': true,
    'salmon': true,
    'tuna': true,
    'cod': true,
    'mackerel': true,
    'sardines': true,
    'tilapia': true,
    'catfish': true,

    // Seafood (Non-Halal)
    'crab': false,
    'lobster': false,
    'octopus': false,
    'squid': false,
    'eel': false,
    'shark': false,
    'dolphin': false,
    'whale': false,

    // Exotic & Wild Animals
    'elephant': false,
    'bear': false,
    'snake': false,
    'frog': false,
    'alligator': false,
    'crocodile': false,
    'kangaroo': false,
    'ostrich': true,
    'peacock': true,
    'partridge': true,

    // Fruits
    'apple': true,
    'banana': true,
    'mango': true,
    'orange': true,
    'grapes': true,
    'watermelon': true,
    'pineapple': true,
    'guava': true,
    'strawberry': true,
    'raspberry': true,
    'blueberry': true,
    'blackberry': true,
    'pear': true,
    'peach': true,
    'plum': true,
    'kiwi': true,
    'cherry': true,
    'papaya': true,
    'fig': true,
    'pomegranate': true,
    'lychee': true,
    'dragon fruit': true,
    'jackfruit': true,
    'coconut': true,
    'lemon': true,
    'lime': true,

    // Vegetables
    'carrot': true,
    'potato': true,
    'tomato': true,
    'onion': true,
    'garlic': true,
    'ginger': true,
    'broccoli': true,
    'cabbage': true,
    'cauliflower': true,
    'spinach': true,
    'lettuce': true,
    'peas': true,
    'corn': true,
    'zucchini': true,
    'cucumber': true,
    'pumpkin': true,
    'eggplant': true,
    'bell pepper': true,
    'chili pepper': true,
    'sweet potato': true,
    'radish': true,
    'turnip': true,

    // Grains & Legumes
    'rice': true,
    'wheat': true,
    'barley': true,
    'oats': true,
    'cornmeal': true,
    'lentils': true,
    'chickpeas': true,
    'kidney beans': true,
    'black beans': true,
    'soybeans': true,
    'quinoa': true,
    'millet': true,
    'sorghum': true,

    // Processed Foods
    'hot dog': false,
    'pepperoni': false,
    'salami': false,
    'sausage': false,
    'burger patty': true,
    'gelatin': false,
    'marshmallow': false,
    'cheese': true,
    'bread': true,
    'butter': true,
    'mayonnaise': true,
    'ketchup': true,
    'mustard': true,
    'pizza': true,

    // Desserts & Sweets
    'ice cream': true,
    'chocolate': true,
    'cake': true,
    'custard': true,
    'halwa': true,
    'gulab jamun': true,
    'ras malai': true,
    'jalebi': true,
    'laddu': true,
    'brownie': true,
    'cookies': true,

    // Spices
    'salt': true,
    'black pepper': true,
    'turmeric': true,
    'cumin': true,
    'coriander': true,
    'cardamom': true,
    'cinnamon': true,
    'cloves': true,
    'nutmeg': true,
    'paprika': true,
    'saffron': true,
  };

  void checkHalalStatus(String foodItem) {
    // Debug print

    setState(() {
      // Ensure case-insensitive matching
      final match = _foodData.keys.firstWhere(
        (key) => key.toLowerCase().trim() == foodItem.toLowerCase().trim(),
        orElse: () => '', // Return an empty string if no match is found
      );

      if (match.isNotEmpty) {
        // Debug print
        // Debug print

        _isHalal = _foodData[match]!;
        _halalStatus = _isHalal
            ? 'The food item "$foodItem" is Halal.'
            : 'The food item "$foodItem" is NOT Halal.';
        _hasResult = true;
      } else {
        // Debug print
        _halalStatus =
            'No information available for the food item "$foodItem".';
        _hasResult = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            // backgroundColor: Colors.green,
            ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Check if your food is Halal!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: "Enter Food Item",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final foodItem = _searchController.text.trim();
                  if (foodItem.isNotEmpty) {
                    // Debug print
                    checkHalalStatus(foodItem);
                  } else {
                    // Debug print
                    setState(() {
                      _halalStatus = "Please enter a food item to check.";
                      _hasResult = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF133D3E),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Check Halal Status"),
              ),
              const SizedBox(height: 20),
              if (_halalStatus.isNotEmpty)
                Card(
                  color: _hasResult
                      ? (_isHalal ? Colors.lightGreen : Colors.redAccent)
                      : Colors.yellow[600],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _halalStatus,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_hasResult)
                          Icon(
                            _isHalal ? Icons.check_circle : Icons.cancel,
                            color: Colors.white,
                            size: 50,
                          ),
                      ],
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
