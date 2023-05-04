// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:cropchain/navigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'config.dart';
import 'order.dart';
import 'package:http/http.dart' as http;

class OrderDetails extends StatefulWidget {
  final Order order;
  const OrderDetails({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late List orderData = [];

  @override
  void initState() {
    super.initState();
    fetchData(widget.order.orderid.toString());
  }

  fetchData(String orderid) async {
    final response = await http.get(Uri.parse(
        '${Config.server}/cropchain/php/orderdata.php?order_id=$orderid'));
    if (response.statusCode == 200) {
      setState(() {
        orderData = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
        ),
        body: orderData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        SizedBox(width: 30),
                        Text('Details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Text('Order ID: ${orderData[0]['order_id']}',
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Text('Name: ${orderData[0]['cus_name']}',
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Text('Email: ${orderData[0]['cus_email']}',
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Text('Address: ${orderData[0]['cus_address']}',
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Text('Phone Number: ${orderData[0]['cus_phone']}',
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Expanded(
                          child: Text(
                              'Total Price: ${orderData[0]['total_price']}',
                              style: const TextStyle(fontSize: 15)),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Expanded(
                          child: Text(
                              'Date Order: ${orderData[0]['date_order']}',
                              style: const TextStyle(fontSize: 15)),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Expanded(
                          child: Text(
                              'Complete Status: ${orderData[0]['status'].toString()}',
                              style: const TextStyle(fontSize: 15)),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        SizedBox(width: 30),
                        Text('Product Ordered',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orderData.length,
                      itemBuilder: (context, index) {
                        final data = orderData[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 30),
                                  Text(
                                      '${data['product_name']}(${data['quantity_buy']})',
                                      style: const TextStyle(fontSize: 15)),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        http.post(
                            Uri.parse(
                                "${Config.server}/cropchain/php/checkout.php"),
                            body: {
                              "order_id": widget.order.orderid.toString(),
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 58, 157, 61), // set background color to green
                      ),
                      child: const Text('Order completed'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String url =
                            "${Config.server}/cropchain/php/qrcode.php?order_id=${widget.order.orderid}";
                        http.get(Uri.parse(url)).then((response) {
                          print(response.body);
                          if (response.statusCode == 200) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Navigation()),
                            );
                            Fluttertoast.showToast(
                              msg: "Success",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.green,
                              fontSize: 14.0,
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "Failed",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.red,
                              fontSize: 14.0,
                            );
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 58, 157, 61), // set background color to green
                      ),
                      child: const Text('Generate Invoice'),
                    ),
                    const SizedBox(height: 10),
                  ])));
  }
}
