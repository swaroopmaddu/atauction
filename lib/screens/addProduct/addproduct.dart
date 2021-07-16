import 'dart:io';
import 'package:atauction/components/constants.dart';
import 'package:atauction/models/Product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  AaddProducrState createState() => AaddProducrState();
}

class AaddProducrState extends State<AddProduct> {
  //varibles
  List<String> categories = [
    "Coins & Bullion",
    "Arts & Crafts",
    "Vintage collectibles",
    "Jewellery",
    "Fashion",
    "Others"
  ];
  final _picker = ImagePicker();
  bool isloading = false;
  File? _selectedImage;
  DateTime _dateTime = DateTime.now();
  String? _category = "Coins & Bullion";
  //form text editing controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  //to store product image
  firebase_storage.Reference storageBucket =
      firebase_storage.FirebaseStorage.instance.ref().child('products');
  var uuid = Uuid();

  //instance to firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //instance to our products collection
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: Text("Add Product"),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/back.svg',
              color: kTextColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: isloading
            ? Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Please wait!")
                      ],
                    ),
                  ],
                ),
              )
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.4,
                          child: _selectedImage != null
                              ? ClipRRect(
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Container(
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200]),
                                  child: Icon(
                                    CupertinoIcons.photo,
                                    size: 40,
                                  ),
                                ),
                        ),
                        onTap: () => selectImageFromGallery(),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.receipt, color: Colors.black),
                            hintText: 'Your Product name',
                            labelText: 'Product Name',
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please enter your valid Product name';
                            }
                          },
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.description, color: Colors.black),
                            hintText: 'A valid description about product?',
                            labelText: 'Description',
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please enter a valid description about your product';
                            }
                          },
                          minLines: 3,
                          maxLines: 5,
                          controller: _descController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.local_atm, color: Colors.black),
                            hintText: 'Price for your product?',
                            labelText: 'Seed Price',
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter a valid price';
                            } else {
                              if (int.tryParse(val) == null) {
                                return 'Enter a valid price in imteger format';
                              }
                            }
                          },
                          controller: _priceController,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.calendar_view_day),
                              SizedBox(width: 20),
                              Flexible(
                                child: DropdownButton<String>(
                                  focusColor: Colors.white,
                                  value: _category,
                                  elevation: 5,
                                  isExpanded: true,
                                  style: TextStyle(color: Colors.white),
                                  iconEnabledColor: Colors.black,
                                  items: categories
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    _category!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _category = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(CupertinoIcons.calendar, color: Colors.black),
                            SizedBox(width: 20),
                            Container(
                              height: 25,
                              width: MediaQuery.of(context).size.width - 130,
                              child: Column(
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd-MM-yyyy kk:mm')
                                        .format(_dateTime)
                                        .toString(),
                                  ),
                                  SizedBox(height: 2),
                                  Container(
                                    height: 1.0,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                _showDatepicker();
                              },
                              child: Icon(Icons.edit, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          child: Text("Submit",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              addProductToCollection().then((value) {
                                _descController.clear();
                                _nameController.clear();
                                _priceController.clear();
                                _dateTime = DateTime.now();
                                _selectedImage = null;
                                setState(() {
                                  isloading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Product Successfully added')));
                              }).onError((error, stackTrace) {
                                setState(() {
                                  isloading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Unable to add new Product')));
                              });
                            }
                          },
                        )
                      ],
                    ),
                  )
                ],
              ));
  }

  _showDatepicker() {
    DatePicker.showDateTimePicker(context, showTitleActions: true,
        onConfirm: (date) {
      setState(() {
        _dateTime = date;
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  Future<void> addProductToCollection() async {
    setState(() {
      isloading = true;
    });
    //Upload the file to firebase
    firebase_storage.UploadTask uploadTask = storageBucket
        .child(_selectedImage!.path.split('/').last)
        .putFile(_selectedImage!);

    //create product object
    Product? _product;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await uploadTask.whenComplete(() async {
        String url = await uploadTask.snapshot.ref.getDownloadURL();
        _product = Product(
            url,
            uuid.v1(),
            _nameController.text,
            _nameController.text.toLowerCase(),
            _descController.text,
            _priceController.text,
            _priceController.text,
            _category!,
            _dateTime);
      });
      Map<String, dynamic> data = _product!.toJson();
      data.addAll({
        'biddersList': [],
        'bidder': auth.currentUser?.email,
        'owner': auth.currentUser?.email
      });
      return products.doc(_product?.uid).set(data).then((value) {
        setState(() {
          isloading = false;
        });
        print("Product Added");
      }).catchError((error) {
        print("Failed to add user: $error");
      });
    } on FirebaseException catch (e) {
      setState(() {
        isloading = false;
      });
      print(uploadTask.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  Future selectImageFromGallery() async {
    final PickedFile? pickedFile =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    final File file = File(pickedFile!.path);
    var decodedImage = await decodeImageFromList(file.readAsBytesSync());
    if (decodedImage.width / decodedImage.height == 1) {
      setState(() {
        _selectedImage = file;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Select a square Image which is 1:1 ratio')));
    }
  }
}
