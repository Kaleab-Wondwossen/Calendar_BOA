import 'dart:io';
import 'dart:math'; // Import the dart:math library

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../components/my_text_field.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final nameController = TextEditingController();
  final tinController = TextEditingController();
  final incomeController = TextEditingController();

  CollectionReference referenceFireStore =
      FirebaseFirestore.instance.collection("AdsList");

  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text(
          'Adding Ads...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "Target URL",
                  style: GoogleFonts.acme(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyTextField(
                    hintText: "URL",
                    controllers: nameController,
                    obscureText: false),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "AD Name",
                  style: GoogleFonts.acme(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyTextField(
                    hintText: "Name",
                    controllers: tinController,
                    obscureText: false),
              ),
              Column(
                children: [
                  Center(
                    child: IconButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          //debugging
                          print("Path:${file?.path}");
                          if (file == null) return;
                          String uniqueFileName =
                              DateTime.now().millisecondsSinceEpoch.toString();

                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImages =
                              referenceRoot.child("Images");
                          Reference referenceImagetoUpload =
                              referenceDirImages.child(uniqueFileName);

                          try {
                            await referenceImagetoUpload
                                .putFile(File(file.path));
                            imageUrl =
                                await referenceImagetoUpload.getDownloadURL();
                            print("URL : ${imageUrl}");
                          } catch (e) {}
                        },
                        icon: Icon(
                          Icons.image_rounded,
                          size: 50,
                          color: Color.fromARGB(255, 233, 176, 64),
                        )),
                  ),
                  Center(
                    child: Text(
                      "Add Image",
                      style: GoogleFonts.acme(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  "Please wait about 10 seconds after adding a new image, and then add!",
                  style: GoogleFonts.acme(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ),
              Center(
                  child: IconButton(
                      onPressed: () {
                        if (imageUrl.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Upload Image First!!"),
                          ));
                          return;
                        }
                        String url = nameController.text;
                        String name = tinController.text;

                        // Generate a random integer
                        int randomId = Random().nextInt(100000);

                        Map<String, dynamic> dataToSend = {
                          "url": url,
                          "name": name,
                          "image": imageUrl,
                          "timestamp": Timestamp.now().toString(),
                          "randomId": randomId, // Add the random integer
                        };

                        referenceFireStore.add(dataToSend);
                        nameController.clear();
                        tinController.clear();
                      },
                      icon: const Icon(
                        Icons.add_box,
                        size: 60,
                        color: Colors.black,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
