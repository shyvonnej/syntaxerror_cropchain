// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'navigation.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Center(
            child: Column(
          children: [
            Flexible(
                flex: 5,
                child: Container(color: const Color.fromARGB(255, 19, 30, 36))),
            Flexible(
                flex: 5,
                child: Column(
                  children: [
                    Container(
                        color: const Color.fromARGB(255, 66, 195, 122),
                        child: const Center(
                            child: Text(
                          "SETTINGS",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ))),
                    Expanded(
                        child: ListView(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            shrinkWrap: true,
                            children: [
                          MaterialButton(
                            onPressed: _cleaninventory,
                            child: const Text(
                              "Clean Inventory",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 2,
                            color: Color.fromARGB(255, 88, 247, 144),
                          ),
                          MaterialButton(
                            onPressed: _cleanorders,
                            child: const Text(
                              "Clean Orders",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 2,
                            color: Color.fromARGB(255, 88, 247, 144),
                          ),
                          MaterialButton(
                            onPressed: _refresh,
                            child: const Text(
                              "Refresh database",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 2,
                            color: Color.fromARGB(255, 88, 247, 144),
                          ),
                          const MaterialButton(
                            onPressed: null,
                            child: Text(
                              "Check Farm",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 2,
                            color: Color.fromARGB(255, 88, 247, 144),
                          ),
                          MaterialButton(
                            onPressed: () => exit(0),
                            child: const Text(
                              "Exit",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 2,
                            color: Color.fromARGB(255, 88, 247, 144),
                          ),
                        ]))
                  ],
                ))
          ],
        )));
  }

  void _cleanorders() {
    String url =
        "${Config.server}/cropchain/php/cleanorders.php";
    http.get(Uri.parse(url)).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Navigation()),
        );
        Fluttertoast.showToast(
          msg: "Clean Orders Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.green,
          fontSize: 14.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to clean orders",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          fontSize: 14.0,
        );
      }
    });
  }

  void _cleaninventory() {
    String url =
        "${Config.server}/cropchain/php/cleaninv.php";
    http.get(Uri.parse(url)).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Navigation()),
        );
        Fluttertoast.showToast(
          msg: "Successfully cleaned",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.green,
          fontSize: 14.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to clean Inventory",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          fontSize: 14.0,
        );
      }
    });
  }

  void _refresh() {
    String url =
        "${Config.server}/cropchain/php/refreshprice.php";
    http.get(Uri.parse(url)).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Navigation()),
        );
        Fluttertoast.showToast(
          msg: "Successfully refresh",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.green,
          fontSize: 14.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to refresh",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          fontSize: 14.0,
        );
      }
    });
  }
}
