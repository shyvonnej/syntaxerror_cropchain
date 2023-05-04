// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'newproduct.dart';
import 'order.dart';
import 'orderdetails.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List orderList = [];
  String results = "Orders: ";
  int numord = 0;

  @override
  void initState() {
    super.initState();
    _loadOrders();
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
        title: const Text('Orders'),
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
                  "Number of orders: " + numord.toString(),
                  style: TextStyle(
                    fontSize: resWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.035),
                Expanded(
                  child: orderList.isNotEmpty
                      ? GridView.count(
                          crossAxisCount: gridCount,
                          childAspectRatio: 1.5,
                          children: List.generate(
                            numord,
                            (index) {
                              return SingleChildScrollView(
                                child: Card(
                                  elevation: 5,
                                  child: InkWell(
                                    onTap: (() => {
                                          _orderDetails(index),
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
                                                  orderList[index]
                                                          ['order_id']
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: resWidth * 0.045,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color.fromARGB(255, 161, 255, 216),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "Complete: " +
                                                      orderList[index]
                                                          ['status'].toString(),
                                                  style: TextStyle(
                                                    fontSize: resWidth * 0.030,
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
                      : const Center(child: Text('No order found')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _loadOrders() {
    http
        .post(Uri.parse("${Config.server}/cropchain/php/loadorder.php"))
        .then((response) {
      if (response.statusCode == 200 && response.body != "failed") {
        var parsedJson = json.decode(response.body);
        if (parsedJson['data'] != null) {
          // check if data is null
          orderList = parsedJson['data']['orders'];
          setState(() {
            numord = orderList.length;
          });
        } else {
          setState(() {
            results = "Orders: ";
          });
        }
      }
    });
  }

  _orderDetails(int index) async {
    Order order = Order(
      orderid: orderList[index]['order_id'],
      // billid: orderList[index]['bill_id'],
      date_order: orderList[index]['date_order'],
      totalprice: orderList[index]['total_price'], 
      status: orderList[index]['status'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                OrderDetails(order: order)));
  }

  Future<void> refreshData() async {
    // Fetch the latest data from the server or local storage
    final List<Order> orders = await _loadOrders() ?? [];

    // Update the UI with the latest data
    setState(() {
      orderList = orders;
      numord = orderList.length;
    });
  }
}
