import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWeatherPage(),
    );
  }
}

class MyWeatherPage extends StatefulWidget {
  const MyWeatherPage({Key? key}) : super(key: key);

  @override
  State<MyWeatherPage> createState() => _MyWeatherPageState();
}

class _MyWeatherPageState extends State<MyWeatherPage> {
  String selectLoc = "Melaka",
      description = "No weather information",
      weather = "";

  var temperature, humidity, feelslike;
  List<String> locList = [
    "Melaka",
    "Alor Gajah",
    "Jasin",
    "Masjid Tanah",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Weather APP")),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Simple Weather App",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            DropdownButton(
              itemHeight: 50,
              value: selectLoc,
              onChanged: (newValue) {
                setState(() {
                  selectLoc = newValue.toString();
                });
              },
              items: locList.map((selectLoc) {
                return DropdownMenuItem(
                  child: Text(
                    selectLoc,
                  ),
                  value: selectLoc,
                );
              }).toList(),
            ),
            ElevatedButton(
                onPressed: _loadWeather, child: const Text("Load Weather")),
            const SizedBox(height: 10),
            Text(
              description,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
            ),
          ],
        )));
  }

  Future<void> _loadWeather() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();

    var apiid = "a2977528151fe5089fdfd36f3bc03a35";
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$selectLoc&appid=$apiid&units=metric');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      temperature = parsedData['main']['temp'];
      humidity = parsedData['main']['humidity'];
      weather = parsedData['weather'][0]['main'];
      feelslike = parsedData['main']['feels_like'];
      setState(() {
        description =
            "The current weather in $selectLoc is $weather. It feels like $feelslike. The current temperature is $temperature Celcius and humidity is $humidity percent. ";
      });
      progressDialog.dismiss();
    }
  }
}
