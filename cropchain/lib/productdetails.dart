// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'addinventory.dart';
import 'checkout.dart';
import 'config.dart';
import 'inventory.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  final Product product;
  final Function refreshData;
  const ProductDetail(
      {Key? key, required this.product, required this.refreshData})
      : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List inventoryList = [];
  int numList = 0;

  @override
  void initState() {
    super.initState();
    // fetch inventory data for this product from the database
    _loadInventory(widget.product.productid!);
  }

  @override
  Widget build(BuildContext context) {
    late double screenHeight, screenWidth, resWidth;

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.70;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Product Details"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteProduct(widget.product.productid!);
              },
            ),
          ],
        ),
        body: Center(
            child: SizedBox(
          width: resWidth * 2,
          height: screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    widget.product.name!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: resWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: Icon(Icons.calendar_month),
                    ),
                    SizedBox(width: resWidth * 0.03),
                    Flexible(
                      child: Text(
                        'Shelf Life: ${widget.product.shelf_life!}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: Icon(Icons.calculate),
                    ),
                    SizedBox(width: resWidth * 0.03),
                    Flexible(
                      child: Text(
                        'Total Quantity: ${widget.product.total!}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: Icon(Icons.calculate),
                    ),
                    SizedBox(width: resWidth * 0.03),
                    Flexible(
                      child: Text(
                        'Price (per): ${widget.product.price!}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AddInventoryPage(
                          product: widget.product,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 58, 157, 61), // set background color to green
                  ),
                  child: const Text('Add Inventory'),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (BuildContext context) => CheckoutPage(
                //           product: widget.product,
                //         ),
                //       ),
                //     );
                //   },
                //   child: const Text('Checkout'),
                // ),
                const SizedBox(height: 30),
                SizedBox(
                  height: screenHeight * 0.5,
                  child: ListView.builder(
                    itemCount: inventoryList.length,
                    itemBuilder: (context, index) {
                      // Add this print statement
                      return ListTile(
                        title: Text('Batch Number: ' +
                            inventoryList[index]['batch_num']),
                        subtitle: Text(
                            'Quantity: ' + inventoryList[index]['quantity']),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  void _deleteProduct(String index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _doDeletePlan(index);
              Navigator.pop(context);
            },
            child: const Text("Yes, I'm sure"),
          ),
        ],
      ),
    );
  }

  void _doDeletePlan(String index) {
    http.post(Uri.parse('${Config.server}/cropchain/php/deleteproduct.php'),
        body: {
          'product_id': widget.product.productid,
        }).then((response) {
      if (response.statusCode == 200 && response.body == 'success') {
        Fluttertoast.showToast(
          msg: 'Product deleted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
        );
        Navigator.pop(context);
        widget.refreshData();
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to delete product',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
        );
      }
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Failed to delete product',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0,
      );
    });
  }

  _inventoryDetails(int index) async {
    Inventory inventory = Inventory(
      batchid: inventoryList[index]['batch_id'],
      batchnum: inventoryList[index]['batch_num'],
      quantity: inventoryList[index]['quantity'],
      date_of_production: inventoryList[index]['date_of_production'],
      best_before_date: inventoryList[index]['best_before_date'],
    );
  }

  _loadInventory(String productid) {
    http
        .post(Uri.parse(
            "${Config.server}/cropchain/php/loadinventory.php?product_id=$productid"))
        .then((response) {
      if (response.statusCode == 200 && response.body != "failed") {
        var parsedJson = json.decode(response.body);
        if (parsedJson['data'] != null) {
          // check if data is null
          inventoryList = parsedJson['data']['inventory'];
          setState(() {
            numList = inventoryList.length;
          });
        } else {
          setState(() {});
        }
      }
    });
  }
}
