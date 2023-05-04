// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:cropchain/navigation.dart';
import 'package:cropchain/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'config.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddInventoryPage extends StatefulWidget {
  Product product;
  AddInventoryPage({Key? key, required this.product}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddInventoryPageState createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _dateOfProduction = DateTime.now();
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Inventory'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dateOfProduction,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != _dateOfProduction) {
                    setState(() {
                      _dateOfProduction = pickedDate;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date of Production',
                    ),
                    controller: TextEditingController(
                      text: DateFormat('yyyy/MM/dd').format(_dateOfProduction),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a date of production';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the quantity of the product';
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
                            "${Config.server}/cropchain/php/addinventory.php"),
                        body: {
                          "product_id": widget.product.productid.toString(),
                          "date_of_production": _dateOfProduction.toString(),
                          "quantity": _quantity.toString(),
                        }).then((response) {
                      print(response.body);
                      var data = jsonDecode(response.body);
                      print(data);
                      if (response.statusCode == 200 &&
                          data['status'] == 'success') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Navigation()));
                        Fluttertoast.showToast(
                            msg: "Success",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor:
                                Colors.green, // set background color to green
                            textColor: Colors.white, // set text color to white
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
                  backgroundColor: Color.fromARGB(255, 58, 157, 61), // set background color to green
                ),
                child: const Text('Add Product'),
              ),
            ]),
          ),
        ));
  }
}
