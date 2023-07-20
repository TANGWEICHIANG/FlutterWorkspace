// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:convert';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:barterit_asgm2/Model/user.dart';
// import 'package:barterit_asgm2/Model/config.dart';

// class AddCredit extends StatefulWidget {
//   final User user;
//   const AddCredit({super.key, required this.user});

//   @override
//   State<AddCredit> createState() => _AddCreditState();
// }

// class _AddCreditState extends State<AddCredit> {
//   late double screenHeight, screenWidth, resWidth;
//   final df = DateFormat('dd/MM/yyyy hh:mm a');
//   int val = -1;
//   List<String> creditType = ["100", "1000", "10000", "100000"];
//   String selectedValue = "100";
//   double price = 0.00;

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     if (screenWidth <= 600) {
//       resWidth = screenWidth;
//     } else {
//       resWidth = screenWidth * 0.75;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Credit Top Up",
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.transparent,
//         foregroundColor: Theme.of(context).colorScheme.secondary,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               height: screenHeight * 0.25,
//               width: screenWidth,
//               child: Card(
//                 elevation: 10,
//                 shape: RoundedRectangleBorder(
//                   borderRadius:
//                       BorderRadius.circular(20), // Adjust the radius as needed
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       widget.user.name.toString(),
//                       style: const TextStyle(fontSize: 24),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
//                       child: Divider(
//                         color: Colors.blueGrey,
//                         height: 2,
//                         thickness: 2.0,
//                       ),
//                     ),
//                     Table(
//                       columnWidths: const {
//                         0: FractionColumnWidth(0.3),
//                         1: FractionColumnWidth(0.7)
//                       },
//                       defaultVerticalAlignment:
//                           TableCellVerticalAlignment.middle,
//                       children: [
//                         TableRow(children: [
//                           const Icon(Icons.email_outlined),
//                           Text(widget.user.email.toString()),
//                         ]),
//                         TableRow(children: [
//                           const Icon(Icons.money),
//                           Text(
//                             "${widget.user.credit} Credits",
//                           )
//                         ]),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
//               child: Card(
//                 elevation: 10,
//                 shape: RoundedRectangleBorder(
//                   borderRadius:
//                       BorderRadius.circular(20), // Adjust the radius as needed
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   width: screenWidth,
//                   height: screenHeight * 0.38,
//                   child: Column(
//                     children: [
//                       const Text("BUY CREDIT NOW (100 Credit = RM 1)",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                       const Padding(
//                         padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
//                         child: Divider(
//                           color: Colors.blueGrey,
//                           height: 1,
//                           thickness: 2.0,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         "Select Credit Value",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       const Divider(
//                         color: Colors.blueGrey,
//                         height: 2,
//                         indent: 125,
//                         endIndent: 135,
//                         thickness: 1.0,
//                       ),
//                       SizedBox(
//                         height: 60,
//                         width: 100,
//                         child: DropdownButton(
//                           isExpanded: true,
//                           //sorting dropdownoption
//                           hint: const Text(
//                             'Please Select Credit Value',
//                             style: TextStyle(
//                               color: Color.fromRGBO(101, 255, 218, 50),
//                             ),
//                           ), // Not necessary for Option 1
//                           value: selectedValue,
//                           onChanged: (newValue) {
//                             setState(() {
//                               selectedValue = newValue.toString();
//                               if (selectedValue == "100") {
//                                 price = 1.00;
//                               }
//                               if (selectedValue == "1000") {
//                                 price = 10.00;
//                               }
//                               if (selectedValue == "10000") {
//                                 price = 20.00;
//                               }
//                               if (selectedValue == "100000") {
//                                 price = 50.00;
//                               }
//                             });
//                           },
//                           items: creditType.map((selectedValue) {
//                             return DropdownMenuItem(
//                               value: selectedValue,
//                               child:
//                                   Text(selectedValue, style: const TextStyle()),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       const Divider(
//                         color: Colors.blueGrey,
//                         height: 0,
//                         indent: 125,
//                         endIndent: 135,
//                         thickness: 1.0,
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         "RM ${price.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           _buyCreditDialog();
//                           //pop current page
//                         },
//                         style: ElevatedButton.styleFrom(
//                             fixedSize: Size(screenWidth / 2, 50)),
//                         child: const Text(
//                           "BUY",
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _buyCreditDialog() async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20.0)),
//           ),
//           title: Text(
//             "Buy Credit RM ${(double.parse(selectedValue) / 100).toStringAsFixed(2)}?",
//             style: const TextStyle(),
//           ),
//           content: const Text("Are you sure?", style: TextStyle(fontSize: 20)),
//           actions: <Widget>[
//             ButtonBar(
//               children: [
//                 TextButton(
//                   child: const Text(
//                     "No",
//                     style: TextStyle(),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 TextButton(
//                   child: const Text(
//                     "Yes",
//                     style: TextStyle(),
//                   ),
//                   onPressed: () async {
//                     Navigator.of(context).pop();
//                     showDialog(
//                         context: context,
//                         builder: (c) {
//                           return AlertDialog(
//                               content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                   alignment: Alignment.center,
//                                   padding: const EdgeInsets.only(top: 14),
//                                   child: const CircularProgressIndicator(
//                                     valueColor:
//                                         AlwaysStoppedAnimation(Colors.purple),
//                                   )),
//                               const Text(
//                                 "Processing Payment",
//                               ),
//                             ],
//                           ));
//                         });
//                     int newCredit = (int.parse(widget.user.credit!) +
//                         int.parse(selectedValue));
//                     Timer(const Duration(seconds: 3),
//                         () => _updateCredit(newCredit));
//                     Navigator.of(context)
//                         .pop(); // Close the processing payment dialog
//                     // Show the Snackbar after payment is processed
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Center(
//                           child: Container(
//                             constraints: BoxConstraints(
//                               maxWidth: MediaQuery.of(context).size.width * 0.4,
//                             ),
//                             child: const Text("Payment Successful"),
//                           ),
//                         ),
//                         shape: const StadiumBorder(),
//                         behavior: SnackBarBehavior.floating,
//                         elevation: 30,
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _updateCredit(int credit) {
//     String newCredit = credit.toString();
//     http.post(Uri.parse("${Config().server}/barterit/php/update_profile.php"),
//         body: {
//           "userid": widget.user.id,
//           "purchasedcredit": newCredit
//         }).then((response) {
//       print(response);
//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(response.body);
//         if (jsonResponse['status'] == "success") {
//           Navigator.pop(context);
//           Fluttertoast.showToast(
//             msg: "Credit Purchase Successful!",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 1,
//             fontSize: 16.0,
//           );
//           setState(() {
//             widget.user.credit = newCredit;
//           });
//         } else {
//           Navigator.pop(context);
//           Fluttertoast.showToast(
//             msg: "Purchase Failed",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 1,
//             fontSize: 16.0,
//           );
//         }
//       } else {
//         // Handle non-200 status codes here
//         Navigator.pop(context);
//         Fluttertoast.showToast(
//           msg: "Server Error",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           fontSize: 16.0,
//         );
//       }
//     }).catchError((error) {
//       // Handle any exceptions that occurred during the HTTP request
//       Navigator.pop(context);
//       Fluttertoast.showToast(
//         msg: "Error: $error",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         fontSize: 16.0,
//       );
//     });
//   }
// }
