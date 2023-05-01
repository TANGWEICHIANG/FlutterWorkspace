import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp(apiKey: '07WXRky2pAKNuJ6V3HAYYh39oD9AIjoVIc52oLj7'));
}

class MyApp extends StatelessWidget {
  final String apiKey;

  const MyApp({Key? key, required this.apiKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Info App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(apiKey: apiKey),
    );
  }
}

class HomePage extends StatefulWidget {
  final String apiKey;

  const HomePage({Key? key, required this.apiKey}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  bool _isLoading = false;
  Map<String, dynamic>? _countryData;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _getCountryData(String name) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$name');

    final response = await http.get(
      url,
      headers: {'x-api-key': widget.apiKey},
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      return data;
    } else {
      throw Exception('Failed to get country data');
    }
  }

  void _searchCountry() async {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      try {
        final data = await _getCountryData(name);
        setState(() {
          _countryData = data;
        });
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        setState(() {
          _countryData = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter a country name',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchCountry,
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),
            if (_isLoading) const CircularProgressIndicator(),
            _countryData != null
                ? SizedBox(
                    width: 400,
                    height: null,
                    child: Center(
                      child: Container(
                        width: 400,
                        height: 110,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Capital: ${_countryData!['capital']}'),
                            const SizedBox(height: 8.0),
                            Text(
                                'Currency: ${_countryData!['currency']['name']}'),
                            const SizedBox(height: 8.0),
                            if (_countryData!['iso2'] != null)
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 52, 53, 54),
                                    width: 2.0,
                                  ),
                                ),
                                child: Image.network(
                                  'https://flagsapi.com/${_countryData!['iso2']}/flat/64.png',
                                  height: 50,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Text('No country data found')
          ],
        ),
      ),
    );
  }
}
