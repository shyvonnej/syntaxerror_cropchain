// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:cropchain/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'config.dart';
import 'mainpage.dart';

// ignore: must_be_immutable
class CheckoutPage extends StatefulWidget {
  Product product;
  CheckoutPage({Key? key, required this.product}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Checkout'),
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
                      labelText: 'Quantity',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the quantity for checkout the product';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _quantity = int.tryParse(value) ?? 0;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Order Number',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the order number for checkout the product';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _quantity = int.tryParse(value) ?? 0;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        http.post(
                            Uri.parse(
                                "${Config.server}/cropchain/php/checkout.php"),
                            body: {
                              "product_id": widget.product.productid.toString(),
                              "quantity": _quantity.toString(),
                            }).then((response) {
                          var data = jsonDecode(response.body);
                          print(data);
                          if (response.statusCode == 200 && data['status'] == 'success') {
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
                    child: const Text('Confirm Checkout'),
                  ),
                ]),
          ),
        ));
  }
}
