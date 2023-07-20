import 'dart:convert';

import 'package:barterit_asgm2/Model/user.dart';
import 'package:barterit_asgm2/Model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CardInfoScreen extends StatefulWidget {
  final User user;
  const CardInfoScreen({super.key, required this.user});

  @override
  State<CardInfoScreen> createState() => _CardInfoScreenState();
}

class _CardInfoScreenState extends State<CardInfoScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _numberEditingController =
      TextEditingController();
  final TextEditingController _monthEditingController = TextEditingController();
  final TextEditingController _yearEditingController = TextEditingController();
  final TextEditingController _cvvEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String selectedType = "Visa";
  List<String> cardList = ["MasterCard", "Visa", "PayPal"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Card Information",
            style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Card(
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/card.png'))),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card),
                      const SizedBox(
                        width: 16,
                      ),
                      SizedBox(
                        height: 50,
                        child: DropdownButton(
                            value: selectedType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedType = newValue!;
                                print(selectedType);
                              });
                            },
                            items: cardList.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(selectedType),
                              );
                            }).toList()),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (val) => val!.isEmpty || (val.length < 3)
                      ? "Name must be longer than 3"
                      : null,
                  onFieldSubmitted: (v) {},
                  controller: _nameEditingController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Card Holder Name',
                      labelStyle: const TextStyle(),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      icon: const Icon(Icons.abc),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)))),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                validator: (val) => val!.isEmpty || (val.length < 15)
                    ? "Enter valid card number"
                    : null,
                onFieldSubmitted: (v) {},
                controller: _numberEditingController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  CardNumberInputFormatter()
                ],
                decoration: InputDecoration(
                    hintText: 'Card Number',
                    labelStyle: const TextStyle(),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    icon: const Icon(Icons.numbers),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: SizedBox(
                      width: 150,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty || (val.length < 2)
                            ? "Enter valid month"
                            : null,
                        onFieldSubmitted: (v) {},
                        controller: _monthEditingController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: InputDecoration(
                            hintText: 'MM',
                            labelStyle: const TextStyle(),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            icon: const Icon(Icons.calendar_month),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    flex: 5,
                    child: SizedBox(
                      width: 150,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty || (val.length < 2)
                            ? "Enter valid year"
                            : null,
                        onFieldSubmitted: (v) {},
                        controller: _yearEditingController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: InputDecoration(
                            hintText: 'YY',
                            labelStyle: const TextStyle(),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            icon: const Icon(Icons.calendar_today),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                validator: (val) =>
                    val!.isEmpty || (val.length < 3) ? "Enter valid CVV" : null,
                onFieldSubmitted: (v) {},
                controller: _cvvEditingController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                    hintText: 'CVV',
                    labelStyle: const TextStyle(),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    icon: const Icon(Icons.numbers),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10))),
              ),
              ElevatedButton(
                  onPressed: () {
                    _saveDialog();
                  },
                  child: const Text("Save Card"))
            ],
          ),
        ),
      ),
    );
  }

  void _saveDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Save new card?",
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
                _savecard();
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

  void _savecard() {
    String cardname = _nameEditingController.text;
    String cardnum = _numberEditingController.text;
    String cardmonth = _monthEditingController.text;
    String cardyear = _yearEditingController.text;
    String cardcvv = _cvvEditingController.text;

    http.post(Uri.parse("${Config().server}/barterit/php/insert_card.php"),
        body: {
          "userid": widget.user.id,
          "cardname": cardname,
          "cardnum": cardnum,
          "cardyear": cardyear,
          "cardmonth": cardmonth,
          "cardcvv": cardcvv,
          "cardtype": selectedType
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: const Text("Card Saved Successfully"),
              ),
            ),
            shape: const StadiumBorder(),
            behavior: SnackBarBehavior.floating,
            elevation: 30,
            duration: const Duration(seconds: 1),
          ));
          print(cardnum);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: const Text("Card Saved Failed"),
              ),
            ),
            shape: const StadiumBorder(),
            behavior: SnackBarBehavior.floating,
            elevation: 30,
            duration: const Duration(seconds: 1),
          ));
        }
        // Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: const Text("Card Saved Failed"),
            ),
          ),
          shape: const StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          elevation: 30,
          duration: const Duration(seconds: 1),
        ));
        // Navigator.pop(context);
      }
    });
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;

      if (index % 4 == 0 && inputData.length != index) {
        buffer.write("  ");
      }
    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}
