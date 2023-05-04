// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'config.dart';
import 'mainpage.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  int _shelfLife = 0;
  int _price = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _productName = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Shelf Life (in months)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the shelf life of the product';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _shelfLife = int.tryParse(value) ?? 0;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price (per)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the price of the product';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _price = int.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    http.post(
                        Uri.parse(
                            "${Config.server}/cropchain/php/addproduct.php"),
                        body: {
                          "product_name": _productName.toString(),
                          "shelf_life": _shelfLife.toString(),
                          "price": _price.toString(),
                        }).then((response) {
                      print(response.body);
                      var data = jsonDecode(response.body);
                      print(data);
                      if (response.statusCode == 200 &&
                          data['status'] == 'success') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()));
                        Fluttertoast.showToast(
                            msg: "Success",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.green,
                            fontSize: 14.0);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Failed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.red,
                            fontSize: 14.0);
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 58, 157, 61), // set background color to green
                ),
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
