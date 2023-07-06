import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:barterit_asgm2/user.dart';
import 'package:barterit_asgm2/items.dart';
import 'package:barterit_asgm2/config.dart';

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
        // Flexible(
        //     flex: 4,
        //     // height: screenHeight / 2.5,
        //     // width: screenWidth,
        //     child: Padding(
        //       padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        //       child: Card(
        //         child: SizedBox(
        //           width: screenWidth,
        //           child: CachedNetworkImage(
        //             width: screenWidth,
        //             fit: BoxFit.cover,
        //             imageUrl:
        //                 "${Config().server}/barter_it/assets/items/${widget.item.itemId}-${index + 1}.jpg",
        //             placeholder: (context, url) =>
        //                 const LinearProgressIndicator(),
        //             errorWidget: (context, url, error) =>
        //                 const Icon(Icons.error),
        //           ),
        //         ),
        //       ),
        //     )),
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
                // TableRow(children: [
                //   const TableCell(
                //     child: Text(
                //       "Date",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //   ),
                //   TableCell(
                //     child: Text(
                //       df.format(
                //           DateTime.parse(widget.item.itemDate.toString())),
                //     ),
                //   )
                // ]),
              ],
            ),
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.all(8),
        //   child:
        //       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //     IconButton(
        //         onPressed: () {
        //           if (userqty <= 1) {
        //             userqty = 1;
        //             totalprice = singleprice * userqty;
        //           } else {
        //             userqty = userqty - 1;
        //             totalprice = singleprice * userqty;
        //           }
        //           setState(() {});
        //         },
        //         icon: const Icon(Icons.remove)),
        //     Text(
        //       userqty.toString(),
        //       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //     ),
        //     // IconButton(
        //     //     onPressed: () {
        //     //       if (userqty >= qty) {
        //     //         userqty = qty;
        //     //         totalprice = singleprice * userqty;
        //     //       } else {
        //     //         userqty = userqty + 1;
        //     //         totalprice = singleprice * userqty;
        //     //       }
        //     //       setState(() {});
        //     //     },
        //     //     icon: const Icon(Icons.add)),
        //   ]),
        // ),
        // Text(
        //   "RM ${totalprice.toStringAsFixed(2)}",
        //   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        // ),
        //ElevatedButton(onPressed: () {}, child: const Text("Add to Cart"))
      ]),
    );
  }
}
