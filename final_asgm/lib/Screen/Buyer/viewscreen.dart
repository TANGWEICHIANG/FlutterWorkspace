import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barterit_asgm2/Model/user.dart';
import 'package:barterit_asgm2/Model/items.dart';
import 'package:barterit_asgm2/Model/config.dart';
import 'cartscreen.dart';
import 'itemdetailsscreen.dart';

class ViewScreen extends StatefulWidget {
  final User user;
  const ViewScreen({super.key, required this.user});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  String maintitle = "Barter";
  List<Item> itemList = <Item>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  //int cartqty = 0;

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadItem(1);
    print("Barter");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(maintitle),
          foregroundColor: Theme.of(context).colorScheme.onBackground,
          actions: [
            IconButton(
                onPressed: () {
                  showsearchDialog();
                },
                icon: const Icon(Icons.search),
                color: Colors.black),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CartScreen(
                              user: widget.user,
                            )));
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ],
        ),
        body: itemList.isEmpty
            ? const Center(
                child: Text("No Data"),
              )
            : Column(
                children: [
                  Container(
                    height: 24,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    alignment: Alignment.center,
                    child: Text(
                      "$numberofresult Item Found",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18),
                    ),
                  ),
                  Expanded(
                      child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(itemList.length, (index) {
                      return Card(
                        child: InkWell(
                          onTap: () async {
                            if (widget.user.id != "na") {
                              Item useritem =
                                  Item.fromJson(itemList[index].toJson());
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => ItemDetailScreen(
                                            user: widget.user,
                                            item: useritem,
                                          )));
                              loadItem(1);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                      ),
                                      child: const Text(
                                          "Please login/register an account"),
                                    ),
                                  ),
                                  shape: const StadiumBorder(),
                                  behavior: SnackBarBehavior.floating,
                                  elevation: 30,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                width: screenWidth,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${Config().server}/barterit/assets/items/${itemList[index].itemId}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Text(
                                itemList[index].itemTitle.toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              // Text(
                              //   itemList[index].itemDescription.toString(),
                              //   style: const TextStyle(fontSize: 14),
                              // ),
                              Text(
                                itemList[index].itemType.toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "RM ${double.parse(itemList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  )),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numofpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        //build the list for textbutton with scroll
                        if ((curpage - 1) == index) {
                          //set current page number active
                          color = const Color.fromARGB(255, 64, 106, 211);
                        } else {
                          color = Colors.black;
                        }
                        return TextButton(
                            onPressed: () {
                              curpage = index + 1;
                              loadItem(index + 1);
                            },
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color, fontSize: 18),
                            ));
                      },
                    ),
                  ),
                ],
              ));
  }

  void loadItem(int pg) {
    //var userID;
    http.post(Uri.parse("${Config().server}/barterit/php/load_item.php"),
        body: {
          "cartuserid": widget.user.id,
          "pageno": pg.toString()
        }).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          //print(numberofresult);
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          // print(itemList[0].itemTitle);
        }
        setState(() {});
      }
    });
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Search Item",
                style: TextStyle(),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Insert item name ',
                    labelStyle: TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchitem(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"))
          ]),
        );
      },
    );
  }

  void searchitem(String search) {
    http.post(Uri.parse("${Config().server}/barterit/php/load_item.php"),
        body: {"user_id": widget.user.id, "search": search}).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemTitle);
        }
        setState(() {});
      }
    });
  }
}
