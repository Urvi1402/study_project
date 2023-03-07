import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_project/utilities/utils.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';

String imageUrl = '';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late File _imageFile;
  int _selectedIndex = 0;

  void selectPhoto() async {
    await pickImage(
      ImageSource.gallery,
    );
  }

  void selectImage() async {
    await pickImage(
      ImageSource.camera,
    );
  }
void _onItemTapped(int index) async {
  setState(() {
    _selectedIndex = index;
  });

  // call the appropriate function based on the selected index
  if (index == 0) {
    selectImage();
  } else {
    selectPhoto();
  }

  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
  print('${file?.path}');

  if (file == null) return;
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

  //getting a reference to storage root
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImages = referenceRoot.child('images');

  //creating a reference for the image to be stored
  Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

  try {
    await referenceImageToUpload.putFile(File(file.path));
    //Success: get the download Url
    imageUrl = await referenceImageToUpload.getDownloadURL();
    setState(() {}); // re-build the UI to display the uploaded image
  } catch (error) {
    //some error occured
  }
}


  @override
  Widget build(BuildContext context) {
    final _scaffold = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Main UI')),
      body: Center(
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 200,
                height: 200,
              )
            : Text('Your pictures will be uploaded here'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera,
              color: Colors.white,
            ),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo,
              color: Colors.white,
            ),
            label: 'Gallery',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
