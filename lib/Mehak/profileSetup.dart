// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart' show rootBundle;

import '../BottomNavigationBar.dart';
import '../FireBase/Auth/ExceptionHandler.dart';

class profileSetup extends StatefulWidget {
  const profileSetup({Key? key}) : super(key: key);

  @override
  State<profileSetup> createState() => _profileSetupState();
}

class _profileSetupState extends State<profileSetup> {
  Color inactiveColor = Color(0xF91C788);
  Color activeColor = Colors.white;
  int height = 180;
  int weight = 30;
  int Age = 15;
  bool male = true;
  bool female = false;

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('users');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  bool loading = false;

  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image picked');
      }
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final Directory systemTempDir = Directory.systemTemp;
    final file = File('${(systemTempDir.path)}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }
  File? _image;


  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            "Profile Setup",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                  fillColor: Colors.blueGrey,
                                  focusColor: Colors.blueGrey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Name";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Gender: "),
                                  InkWell(
                                    onTap: () {
                                      setState(
                                        () {
                                          male = true;
                                          female = false;
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: male
                                              ? Colors.greenAccent
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.male,
                                          color: Colors.yellowAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(
                                        () {
                                          male = false;
                                          female = true;
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: female
                                              ? Colors.greenAccent
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.female,
                                          color: Colors.yellowAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                getImageGallery();
                              },
                              child: _image != null
                                  ? CircleAvatar(
                                      radius: 80,
                                      backgroundImage:
                                          FileImage(File(_image!.path)),
                                    )
                                  : CircleAvatar(
                                      radius: 80,
                                      backgroundImage:
                                          AssetImage('assets/anonymous.jpg'),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "HEIGHT",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "${height}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            Text("cm",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.black)),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.green,
                            // overlayColor: Color(0x291DE986),
                            overlayColor: Colors.greenAccent,
                            inactiveTrackColor: Colors.black,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 16.0),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 30.0),
                            thumbColor: Color(0xFF1DE9B6),
                          ),
                          child: Slider(
                            onChanged: (double v) {
                              setState(
                                () {
                                  height = v.round();
                                },
                              );
                            },
                            value: height.toDouble(),
                            min: 100.0,
                            max: 250.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${weight}",
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "kg",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () {
                                          weight++;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () {
                                          if (weight > 10) {
                                            weight--;
                                          }
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${Age}",
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "yrs",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () {
                                          Age++;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () {
                                          if (Age > 10) {
                                            Age--;
                                          }
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            InkWell(
              enableFeedback: false,
              onTap: () async {
                print("Hello");
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/${auth.currentUser!.uid}/ Profile_Picture');
                firebase_storage.UploadTask uploadTask;
                if (_image != null) {
                  uploadTask = ref.putFile(_image!.absolute);
                } else {
                  _image = await getImageFileFromAssets('anonymous.jpg') ;
                  uploadTask = ref.putFile(_image!.absolute);
                }

                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  await Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    fireStore.doc(auth.currentUser!.uid).set({
                      "ID": auth.currentUser!.uid,
                      "Name": nameController.text.toString(),
                      "Gender": male ? "Male" : "Female",
                      "ProfilePic": newUrl.toString(),
                      "Height": height.toString(),
                      "Weight": weight.toString(),
                      "Age": Age.toString(),
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => navBar()),
                      );
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      ExceptionHandle().toastMessage(error.toString());
                    });
                  });
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF1DE986),
                ),
                child: Center(
                  child: loading
                      ? CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
