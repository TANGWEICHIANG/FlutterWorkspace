// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barterit_asgm2/Model/user.dart';
import 'package:barterit_asgm2/Model/config.dart';
import 'register.dart';
import 'package:barterit_asgm2/Screen/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
              height: screenHeight * 0.50,
              width: screenWidth,
              child: Image.asset(
                "assets/images/login.jpg",
                fit: BoxFit.cover,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(children: [
                  Form(
                    key: _formKey,
                    child: Column(children: [
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
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _passFocusNode.unfocus();
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
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.blue,
                            value: _isChecked,
                            onChanged: (bool? value) {
                              saveremovepref(value!);
                              setState(() {
                                _isChecked = value;
                              });
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: null,
                              child: const Text('Remember Me',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: screenWidth / 3,
                            height: 50,
                            elevation: 10,
                            onPressed: onLogin,
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.onError,
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ]),
                  )
                ]),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            //onTap: null,
            onTap: _goToRegister,
            child: const Text(
              "No account? Register now!",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          // GestureDetector(
          //   onTap: _forgotDialog,
          //   child: const Text(
          //     "Forgot Password?",
          //     style: TextStyle(
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
        ],
      )),
    );
  }

  void onLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.4,
              ),
              child: const Text("Check your input"),
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
    String email = _emailEditingController.text;
    String pass = _passEditingController.text;
    //print(pass);
    try {
      http.post(Uri.parse("${Config().server}/barterit/php/login_user.php"),
          body: {
            "email": email,
            "password": pass,
          }).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            //print(jsondata);
            print(user.name);
            print(user.email);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4,
                    ),
                    child: const Text("Login Success"),
                  ),
                ),
                shape: const StadiumBorder(),
                behavior: SnackBarBehavior.floating,
                elevation: 30,
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(
                          user: user,
                        )));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4,
                    ),
                    child: const Text("Login Failed"),
                  ),
                ),
                shape: const StadiumBorder(),
                behavior: SnackBarBehavior.floating,
                elevation: 30,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }).timeout(const Duration(seconds: 5), onTimeout: () {
        // Time has run out, do what you wanted to do.
      });
    } on TimeoutException catch (_) {
      print("Time out");
    }
  }

  // void _forgotDialog() {}

  void _goToRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegisterScreen()));
  }

  void saveremovepref(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      if (!_formKey.currentState!.validate()) {
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool("checkbox", value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.4,
              ),
              child: const Text("Preference Stored"),
            ),
          ),
          shape: const StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          elevation: 30,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.4,
              ),
              child: const Text("Preference Removed"),
            ),
          ),
          shape: const StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          elevation: 30,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;
    if (_isChecked) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
      });
    }
  }
}
