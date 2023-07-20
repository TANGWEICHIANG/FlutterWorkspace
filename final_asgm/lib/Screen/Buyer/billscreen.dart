import 'dart:convert';

import 'package:barterit_asgm2/Model/cart.dart';

import 'package:barterit_asgm2/Model/order.dart';
import 'package:barterit_asgm2/Model/user.dart';
import 'package:barterit_asgm2/Model/config.dart';
import 'package:barterit_asgm2/Screen/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class BillScreen extends StatefulWidget {
  final User user;
  final List<Cart> cartList;
  final double totalprice;

  // Add the constructor and assign the parameters to class properties
  const BillScreen({
    super.key,
    required this.user,
    required this.cartList,
    required this.totalprice,
  });

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  late double screenHeight, screenWidth, cardwitdh;
  String status = "Loading...";
  List<Order> orderList = <Order>[];

  @override
  void initState() {
    super.initState();
    loadorders();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Order",
              style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Column(
            children: [
              Card(
                  child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/paymentsuc.png"))),
                  ),
                  Text("The seller has received your order!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(
                      "Thank you for ordering, your item will be delivering within 3 business day",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(fontSize: 13)),
                  Text("Please contact the seller if any inquiries",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(fontSize: 13))
                ],
              )),
              Expanded(
                  child: ListView.builder(
                      itemCount: orderList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            loadorders();
                          },
                          leading:
                              CircleAvatar(child: Text((index + 1).toString())),
                          title: Text("Receipt: ${orderList[index].orderBill}"),
                          trailing: const Icon(Icons.arrow_forward),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Order ID: ${orderList[index].orderId}"),
                                    const Text("Status: Paid")
                                  ]),
                              Column(
                                children: [
                                  Text(
                                    "RM ${double.parse(orderList[index].orderPaid.toString()).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text("")
                                ],
                              )
                            ],
                          ),
                        );
                      })),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (content) => MainScreen(
                                  user: widget.user,
                                )));
                  },
                  child: Text("Back",
                      style: GoogleFonts.manrope(
                          fontSize: 17, fontWeight: FontWeight.bold)))
            ],
          ),
        ));
  }

  void loadorders() {
    http.post(Uri.parse("${Config().server}/barterit/php/load_order.php"),
        body: {"userid": widget.user.id}).then((response) {
      //orderList.clear();
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          orderList.clear();
          var extractdata = jsondata['data'];
          extractdata['orders'].forEach((v) {
            orderList.add(Order.fromJson(v));
          });
        } else {
          status = "Please register an account first";
          setState(() {});
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("No order found")));
        }
        setState(() {});
      }
    });
  }
}
