import 'dart:convert';
import 'package:barterit_asgm2/user.dart';

import 'login.dart';
import 'package:barterit_asgm2/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key, required User user}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _pass2FocusNode = FocusNode();
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _pass2FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Registration"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: screenHeight * 0.50,
                width: screenWidth,
                child: Image.asset(
                  "assets/images/register.jpg",
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                child: Column(children: [
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                          controller: _nameEditingController,
                          focusNode: _nameFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "name must be longer than 5"
                              : null,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _emailEditingController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passFocusNode);
                          },
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "enter a valid email"
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _passEditingController,
                          focusNode: _passFocusNode,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_pass2FocusNode);
                          },
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _pass2EditingController,
                          focusNode: _pass2FocusNode,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _pass2FocusNode.unfocus();
                            onRegisterDialog();
                          },
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Re-enter password',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              if (!_isChecked) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Terms have been read and accepted.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    shape: StadiumBorder(),
                                    behavior: SnackBarBehavior.floating,
                                    width: double.infinity,
                                    elevation: 30,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: null,
                            child: const Text('Agree with terms',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                              child: ElevatedButton(
                            onPressed: onRegisterDialog,
                            child: const Text("Register"),
                          ))
                        ],
                      )
                    ]),
                  )
                ]),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              // onTap: _goLogin,
              onTap: null,
              child: const Text(
                "Already Registered? Login",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Check your input",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        width: double.infinity,
        elevation: 30,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Please agree with terms and conditions.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        width: double.infinity,
        elevation: 30,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    String passa = _passEditingController.text;
    String passb = _pass2EditingController.text;
    if (passa != passb) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Check your password",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        width: double.infinity,
        elevation: 30,
        duration: Duration(seconds: 2),
      ));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Register new account?",
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
                registerUser();
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

  void registerUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registering..."),
        );
      },
    );

    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String passa = _passEditingController.text;

    http.post(Uri.parse("${Config().server}/barterit/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "password": passa,
        }).then((response) {
      //print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Registration Success",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
            width: double.infinity,
            elevation: 30,
            duration: Duration(seconds: 2),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Registration Failed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
            width: double.infinity,
            elevation: 30,
            duration: Duration(seconds: 2),
          ));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Registration Failed",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          width: double.infinity,
          elevation: 30,
          duration: Duration(seconds: 2),
        ));
        Navigator.pop(context);
      }
    });
  }

  // void _goLogin() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  // }
}
