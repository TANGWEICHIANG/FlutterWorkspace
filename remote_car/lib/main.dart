import 'package:flutter/material.dart';

void main() {
  runApp(const MyCar());
}

class MyCar extends StatefulWidget {
  const MyCar({Key? key}) : super(key: key);

  @override
  State<MyCar> createState() => _MyCarState();
}

class _MyCarState extends State<MyCar> {
  String operation = 'stop';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Remote Car"),
          backgroundColor: Color.fromARGB(255, 107, 227, 169),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 320,
                color: Colors.greenAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    side: BorderSide(color: Colors.black12)))),
                        onPressed: () {
                          _setOperation('Forward');
                        },
                        child: Text('Forward'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        side: BorderSide(
                                            color: Colors.black12)))),
                            onPressed: () {
                              _setOperation('Left');
                            },
                            child: Text('Left'),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        side: BorderSide(
                                            color: Colors.black12)))),
                            onPressed: () {
                              _setOperation('Stop');
                            },
                            child: Text('Stop'),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        side: BorderSide(
                                            color: Colors.black12)))),
                            onPressed: () {
                              _setOperation('Right');
                            },
                            child: Text('Right'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        side: BorderSide(
                                            color: Colors.black12)))),
                            onPressed: () {
                              _setOperation('Reverse');
                            },
                            child: Text('Reverse'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: Offset(0.0, 10.0),
                  child: Text(
                    operation,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setOperation(String newOperation) {
    setState(
      () {
        operation = newOperation;
      },
    );
  }
}
