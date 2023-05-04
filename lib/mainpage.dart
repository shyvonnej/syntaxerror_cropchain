// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:cropchain/product.dart';
import 'package:cropchain/productdetails.dart';
import 'package:flutter/material.dart';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'newproduct.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List productList = [];
  String results = "Found: ";
  int numProd = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    late double screenHeight, screenWidth, resWidth;
    late int gridCount;

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
      gridCount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      gridCount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        automaticallyImplyLeading: false, // This line removes the back button
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const AddProductPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: resWidth * 2,
          height: screenHeight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "Number of products",
                  style: TextStyle(
                    fontSize: resWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  results + numProd.toString(),
                  style: TextStyle(
                    fontSize: resWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.035),
                Expanded(
                  child: productList.isNotEmpty
                      ? GridView.count(
                          crossAxisCount: gridCount,
                          childAspectRatio: 1.5,
                          children: List.generate(
                            numProd,
                            (index) {
                              return SingleChildScrollView(
                                child: Card(
                                  elevation: 5,
                                  child: InkWell(
                                    onTap: (() => {
                                          _productDetails(index),
                                        }),
                                    child: Container(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  productList[index]
                                                          ['product_name']
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: resWidth * 0.045,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color.fromARGB(255, 152, 255, 190),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: screenHeight * 0.020),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "Total quantity " +
                                                      productList[index]
                                                          ['total_quantity'],
                                                  style: TextStyle(
                                                    fontSize: resWidth * 0.032,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Center(child: Text('No products found')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _loadProducts() {
    http
        .post(Uri.parse("${Config.server}/cropchain/php/loadproduct.php"))
        .then((response) {
      if (response.statusCode == 200 && response.body != "failed") {
        var parsedJson = json.decode(response.body);
        if (parsedJson['data'] != null) {
          // check if data is null
          productList = parsedJson['data']['products'];
          setState(() {
            numProd = productList.length;
          });
        } else {
          setState(() {
            results = "Found: ";
          });
        }
      }
    });
  }

  _productDetails(int index) async {
    Product product = Product(
      productid: productList[index]['product_id'],
      name: productList[index]['product_name'],
      shelf_life: productList[index]['shelf_life'],
      total: productList[index]['total_quantity'],
      price: productList[index]['price'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductDetail(product: product, refreshData: refreshData)));
  }

  Future<void> refreshData() async {
    // Fetch the latest data from the server or local storage
    final List<Product> products = await _loadProducts() ?? [];

    // Update the UI with the latest data
    setState(() {
      productList = products;
      numProd = productList.length;
    });
  }
}
