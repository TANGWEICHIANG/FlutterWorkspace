import 'dart:convert';

import 'package:barterit_asgm2/Screen/Buyer/payment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:barterit_asgm2/Model/user.dart';
import 'package:barterit_asgm2/Model/cart.dart';
import 'package:barterit_asgm2/Model/config.dart';

class CartScreen extends StatefulWidget {
  final User user;
  const CartScreen({super.key, required this.user});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> cartList = <Cart>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  double totalprice = 0.0;
  int credit = 0;

  @override
  void initState() {
    super.initState();
    loadcart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          cartList.isEmpty
              ? Container()
              : Expanded(
                  child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                width: screenWidth / 3,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${Config().server}/barterit/assets/items/${cartList[index].itemId}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        cartList[index].itemTitle.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "RM ${double.parse(cartList[index].cartPrice.toString()).toStringAsFixed(2)}",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteDialog(index);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ));
                      })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Price RM ${totalprice.toStringAsFixed(2)}"),
                    // ElevatedButton(
                    //     onPressed: () {}, child: const Text("Check Out"))
                    ElevatedButton(
                        onPressed: () {
                          // var credit;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                        user: widget.user,
                                        // totalprice: totalprice,
                                        // paymentCartList: cartList,
                                      )));
                        },
                        child: const Text("Check Out"))
                  ],
                )),
          )
        ],
      ),
    );
  }

  void loadcart() {
    http.post(Uri.parse("${Config().server}/barterit/php/load_cart.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      print(response.body);
      // log(response.body);
      cartList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
            // totalprice = totalprice +
            //     double.parse(extractdata["carts"]["cart_price"].toString());
          });
          totalprice = 0.0;
          for (var element in cartList) {
            totalprice =
                totalprice + double.parse(element.cartPrice.toString());
          }
          //print(catchList[0].catchName);
        } else {
          Navigator.of(context).pop();
        }

        setState(() {});
      }
    });
  }

  void deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Delete this item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteCart(index);
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteCart(int index) {
    http.post(Uri.parse("${Config().server}/barterit/php/delete_cart.php"),
        body: {
          "user_id": widget.user.id,
          "cartid": cartList[index].cartId,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          loadcart();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: const Text("Delete Success"),
              ),
            ),
            shape: const StadiumBorder(),
            behavior: SnackBarBehavior.floating,
            elevation: 30,
            duration: const Duration(seconds: 2),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: const Text("Delete Failed"),
              ),
            ),
            shape: const StadiumBorder(),
            behavior: SnackBarBehavior.floating,
            elevation: 30,
            duration: const Duration(seconds: 2),
          ));
        }
      }
    });
  }

  void sendBarterRequestDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Send Request to owner to Barter for item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure? \n(3 Credits will be deducted)",
              style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _sendBarterRequest(index);
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendBarterRequest(int index) {
    String tradeStatus = "pending";
    int newcreditValue = (int.parse(widget.user.credit!) - 3);

    if (newcreditValue >= 0) {
      String newCredit = newcreditValue.toString();
      http.post(
          Uri.parse("${Config().server}/barterit/php/sendBarterRequest.php"),
          body: {
            "cart_id": cartList[index].cartId,
            "itemid": cartList[index].itemId,
            "userid": widget.user.id,
            "barterid": cartList[index].barterId,
            "status": tradeStatus,
            //"newCredit": newCredit
          }).then((response) {
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            _updateCredit(newCredit);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Request sent, please wait for owner to reply to your request")));
            loadcart();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Request Failed")));
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Request Failed")));
        }
      });
    } else {
      Fluttertoast.showToast(
          msg:
              "Your Credit is not enough, please purchase credit at Profile Tab",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      return;
    }
  }

  void _updateCredit(String newCredit) {
    http.post(Uri.parse("${Config().server}/barterit/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "newCredit": newCredit
        }).then((response) {
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        setState(() {
          widget.user.credit = newCredit;
        });
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Purchase Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
