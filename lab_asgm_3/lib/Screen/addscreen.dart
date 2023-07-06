import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barterit_asgm2/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:barterit_asgm2/config.dart';
import 'listscreen.dart';

class AddScreen extends StatefulWidget {
  final User user;

  const AddScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  //File? _image;
  List<File> imageFileList = [];

  var pathAsset = "assets/images/camera.jpg";
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _itemtitleEditingController =
      TextEditingController();
  final TextEditingController _itemdescEditingController =
      TextEditingController();
  final TextEditingController _itempriceEditingController =
      TextEditingController();
  final TextEditingController _itemquantityEditingController =
      TextEditingController();
  final TextEditingController _itemstateEditingController =
      TextEditingController();
  final TextEditingController _itemlocalEditingController =
      TextEditingController();
  String selectedType = "Electronics";
  List<String> itemlist = [
    "Electronics",
    "Fashion and clothing",
    "Home and Furniture",
    "Books and Media",
    "Sports and Fitness",
    "Vehicles and Automotive",
    "Collectibles",
    "Toys and Games",
    "Arts and Crafts",
    "Music and Instruments",
    "Health and Beauty",
    "Garden and Outdoor",
  ];
  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String itemlat = "";
  String itemlong = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              style: TextStyle(color: Colors.white), "Insert New Item")),
      body: Column(children: [
        GestureDetector(
          onTap: () {
            _selectMultipleImages();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Card(
              // ignore: sized_box_for_whitespace
              child: Container(
                width: screenWidth,
                height: screenHeight /
                    2.5, // Specify a fixed height for the container
                child: imageFileList.isEmpty
                    ? Image.asset(pathAsset)
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageFileList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.file(
                              File(imageFileList[index].path),
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.type_specimen),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          height: 50,
                          child: DropdownButton<String>(
                            value: selectedType.isNotEmpty
                                ? selectedType
                                : null, // Set value to null if selectedType is empty
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedType = newValue ??
                                    ""; // Use empty string if newValue is null
                                print(selectedType);
                              });
                            },
                            items: itemlist.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(
                                  selectedType,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Item name must be longer than 3"
                                : null,
                            onFieldSubmitted: (v) {},
                            controller: _itemtitleEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Item Name',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.title),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ]),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Item description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        //maxLines: 2,
                        controller: _itemdescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Item price must contain value"
                                  : null,
                              onFieldSubmitted: (v) {},
                              controller: _itempriceEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Item Price',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current State"
                                : null,
                            enabled: false,
                            controller: _itemstateEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current State',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current Locality"
                                : null,
                            controller: _itemlocalEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Locality',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            insertDialog();
                          },
                          child: const Text("Insert Item")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _selectMultipleImages() async {
    final picker = ImagePicker();
    final selectedImageList = await picker.pickMultiImage();

    // ignore: unnecessary_null_comparison
    if (selectedImageList != null) {
      List<File> selectedImages = selectedImageList
          .map((selectedImage) => File(selectedImage.path))
          .toList();
      List<File>? croppedImages = await cropImage(selectedImages);

      if (croppedImages != null) {
        setState(() {
          imageFileList.addAll(croppedImages);
        });
      } else {
        print('No images selected or cropped.');
      }
    } else {
      print('No images selected.');
    }
  }

  Future<List<File>?> cropImage(List<File> images) async {
    List<File> croppedImages = [];
    for (var image in images) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          //CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          //CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        File imageFile = File(croppedFile.path);
        croppedImages.add(imageFile);
      }
    }
    return croppedImages.isNotEmpty ? croppedImages : null;
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    // ignore: unnecessary_null_comparison
    if (imageFileList == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please take picture")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert your item?",
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
                insertItem();
                //registerUser();
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

  void insertItem() async {
    List<String> imageList = [];
    String itemtitle = _itemtitleEditingController.text;
    String itemdesc = _itemdescEditingController.text;
    String itemprice = _itempriceEditingController.text;
    // String itemqty = _itemquantityEditingController.text;
    String itemstate = _itemstateEditingController.text;
    String itemlocality = _itemlocalEditingController.text;
    for (var image in imageFileList) {
      List<int> imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      imageList.add(base64Image);
    }
    http.post(Uri.parse("${Config().server}/barterit/php/add_item.php"), body: {
      "userid": widget.user.id.toString(),
      "itemtitle": itemtitle,
      "itemdesc": itemdesc,
      "itemtype": selectedType,
      "itemlatitude": itemlat,
      "itemlongitude": itemlong,
      "itemstate": itemstate,
      "itemlocality": itemlocality,
      "itemprice": itemprice,
      "image": jsonEncode(imageList)
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ListScreen(user: widget.user),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ListScreen(user: widget.user),
          ),
        );
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _itemlocalEditingController.text = "Sintok";
      _itemstateEditingController.text = "Kedah";
      itemlat = "6.4502";
      itemlong = "100.4959";
    } else {
      _itemlocalEditingController.text = placemarks[0].locality.toString();
      _itemstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      itemlat = _currentPosition.latitude.toString();
      itemlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }
}
