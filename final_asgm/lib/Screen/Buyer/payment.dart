import 'dart:convert';
import 'billscreen.dart';
import 'package:barterit_asgm2/Model/card.dart';
import 'package:barterit_asgm2/Model/cart.dart';
import 'package:barterit_asgm2/Model/user.dart';
import 'package:barterit_asgm2/Model/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final User user;
  const PaymentScreen({super.key, required this.user});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<Cart> cartList = <Cart>[];
  List<CardModel> cardList = <CardModel>[];
  late double screenHeight, screenWidth, containerHeight, containerWidth;
  double totalprice = 0.0;
  String password = '';

  @override
  void initState() {
    super.initState();
    loadcart();
    loadcard();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    containerHeight = screenHeight * 0.5;
    containerWidth = screenWidth * 0.5;
    return Scaffold(
        appBar: AppBar(
          title: Text("Order Confirmation",
              style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Column(
            children: [
              //  Card(
              //   child: Column(
              //     children: [
              //       Container(
              //         width: 60,
              //         height: 60,
              //         decoration: const BoxDecoration(
              //           image: DecorationImage(image: AssetImage("assets/images/tick.png"))
              //         ),
              //       ),
              //       Text("The seller has received your order!",
              //       textAlign: TextAlign.center,
              //       style: GoogleFonts.manrope(fontWeight: FontWeight.bold,fontSize: 20)),
              //       Text("Thank you for ordering, your item will be delivering within 3 business day",
              //       textAlign: TextAlign.center,
              //       style: GoogleFonts.manrope(fontSize: 13)),
              //       Text("Please contact the seller if any inquiries",
              //       textAlign: TextAlign.center,
              //       style: GoogleFonts.manrope(fontSize: 13))
              //     ],
              //   )
              // ),
              Expanded(
                child: ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  cartList[index].itemTitle.toString(),
                                  style: GoogleFonts.manrope(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total: RM ${totalprice.toStringAsFixed(2)}",
                        style: GoogleFonts.manrope(
                          fontSize: 17,
                        )),
                    ElevatedButton(
                        onPressed: () {
                          _paymentMethodBottomSheet(context);
                        },
                        child: Text("Confirm",
                            style: GoogleFonts.manrope(
                                fontSize: 17, fontWeight: FontWeight.bold))),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void loadcart() {
    http.post(Uri.parse("${Config().server}/barterit/php/load_cart.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      print(response.body);
      cartList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
          });
          totalprice = 0.0;

          for (var element in cartList) {
            totalprice =
                totalprice + double.parse(element.cartPrice.toString());
          }
        } else {
          Navigator.of(context).pop();
        }
        setState(() {});
      }
    });
  }

  void _paymentMethodBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: containerHeight,
            color: const Color.fromRGBO(255, 248, 214, 90),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: containerHeight / 7.5,
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/google.png"))),
                    ),
                    const Text(
                      "Google Pay",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                height: containerHeight / 2.5,
                width: double.infinity,
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cardList[0].cardName.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                cardList[0].cardNumber.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.navigate_next))
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.black),
              Container(
                height: containerHeight / 5,
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pay Total",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "RM ${totalprice.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                          child: IconButton(
                            onPressed: () {
                              payNow();
                            },
                            icon: const Icon(Icons.wallet),
                            iconSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Pay Now",
                            style: TextStyle(
                              fontSize: 15,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          );
        });
  }

  void payNow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter password'),
          content: TextFormField(
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                verifyPassword();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void verifyPassword() {
    if (password == widget.user.password) {
      Navigator.of(context).pop();
      addorder();
      _billPrompt();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the correct password")),
      );
      return;
    }
  }

  void loadcard() {
    http.post(Uri.parse("${Config().server}/barterit/php/load_card.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      print(response.body);
      cardList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['cards'].forEach((v) {
            cardList.add(CardModel.fromJson(v));
          });
        } else {
          Navigator.of(context).pop();
        }
        setState(() {});
      }
    });
  }

  void addorder() {
//       for (int index = 0; index < cartList.length; index++) {
//       String sellerid = cartList[index].sellerId.toString();
//       double orderpaid = double.parse(cartList[index].cartPrice.toString());
//       String itemid = cartList[index].itemId.toString();
//       int cartQty = int.parse(cartList[index].cartQty.toString());
// }
    http.post(Uri.parse("${Config().server}/barterit/php/add_order.php"),
        body: {
          "userid": widget.user.id,
          "sellerid": cartList[0].barterId.toString(),
          "orderpaid": cartList[0].cartPrice.toString(),
          "itemid": cartList[0].itemId.toString(),
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Success")));
          Navigator.pop(context);
          _billPrompt();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _billPrompt() {
    // Navigate to the BillScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BillScreen(
          cartList: cartList,
          user: widget.user,
          totalprice: totalprice,
        ),
      ),
    );
  }
}
