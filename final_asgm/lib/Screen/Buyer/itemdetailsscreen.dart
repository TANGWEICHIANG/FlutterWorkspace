import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:barterit_asgm2/Model/user.dart';
import 'package:barterit_asgm2/Model/items.dart';
import 'package:barterit_asgm2/Model/config.dart';

class ItemDetailScreen extends StatefulWidget {
  final User user;
  final Item item;
  const ItemDetailScreen({super.key, required this.user, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int currentImageIndex = 0;
  int qty = 0;
  int userqty = 1;
  double totalprice = 0.0;
  double singleprice = 0.0;

  @override
  void initState() {
    super.initState();
    totalprice = double.parse(widget.item.itemPrice.toString());
    singleprice = double.parse(widget.item.itemPrice.toString());
  }

  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late double screenHeight, screenWidth, cardwitdh;
  // final List<File?> _imageUrl = List.generate(3, (index) => null);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    List<String> imageUrls = [
      "${Config().server}/barterit/assets/items/${widget.item.itemId}.png",
      "${Config().server}/barterit/assets/items/${widget.item.itemId}.1.png",
      "${Config().server}/barterit/assets/items/${widget.item.itemId}.2.png",
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Item Details")),
      body: Column(children: [
        Flexible(
            flex: 4,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              addAutomaticKeepAlives: false,
              shrinkWrap: true,
              itemCount: imageUrls.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(1, 2, 1, 2),
                  child: Card(
                    child: SizedBox(
                      width: screenWidth,
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            )),
        Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.item.itemTitle.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
        Flexible(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(6),
              },
              children: [
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.item.itemDescription.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Item Type",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.item.itemType.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "RM ${double.parse(widget.item.itemPrice.toString()).toStringAsFixed(2)}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "${widget.item.itemLocality}/${widget.item.itemState}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      df.format(
                          DateTime.parse(widget.item.itemDate.toString())),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
        Text(
          "RM ${totalprice.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
            onPressed: () {
              addtocartdialog();
            },
            child: const Text("Add to Cart"))
      ]),
    );
  }

  void addtocartdialog() {
    if (widget.user.id.toString() == widget.item.userId.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: const Text("User cannot add own item"),
            ),
          ),
          shape: const StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          elevation: 30,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Add to cart?",
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
                //deductToken();
                addtocart();
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

  void addtocart() {
    http.post(Uri.parse("${Config().server}/barterit/php/addtocart.php"),
        body: {
          "item_id": widget.item.itemId.toString(),
          "item_title": widget.item.itemTitle.toString(),
          "cart_price": totalprice.toString(),
          "user_id": widget.user.id.toString(),
          "seller_id": widget.item.userId.toString(),
        }).then((response) {
      log(response.body);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: const Text("Success"),
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
                child: const Text("Failed"),
              ),
            ),
            shape: const StadiumBorder(),
            behavior: SnackBarBehavior.floating,
            elevation: 30,
            duration: const Duration(seconds: 2),
          ));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: const Text("Failed"),
            ),
          ),
          shape: const StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          elevation: 30,
          duration: const Duration(seconds: 2),
        ));
        Navigator.pop(context);
      }
    });
  }
}
