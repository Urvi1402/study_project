// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:study_project/responsive/mobile_screen_layout.dart';
// import 'package:study_project/responsive/responsive_layout_screen.dart';
// import 'package:study_project/responsive/web_screen_layout.dart';
// import 'package:study_project/screens/home_screen.dart';
// import 'package:study_project/utilities/colors.dart';
// import 'package:camera/camera.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyDxA9YsZH_eD8XOmEjXtDos8F9H_lYl0uk",
//         appId: "1:267937519577:web:d06607f793c734cdd66bc8",
//         messagingSenderId: "267937519577",
//         projectId: "study-project-99570",
//         storageBucket: "study-project-99570.appspot.com",
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Study Project',
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: mobileBackgroundColor,
//       ),
//       // home: const ResponsiveLayout(
//       //   mobileScreenLayout: MobileScreenLayout(),
//       //   webScreenLayout: WebScreenLayout(),
//       // ),
//       home: HomeScreen(),
//     );
//   }
// }

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_project/utilities/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDxA9YsZH_eD8XOmEjXtDos8F9H_lYl0uk",
        appId: "1:267937519577:web:d06607f793c734cdd66bc8",
        messagingSenderId: "267937519577",
        projectId: "study-project-99570",
        storageBucket: "study-project-99570.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark()
        .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<XFile> images = [];
  List<String> imageUrls = [];

  final DatabaseReference database =
      FirebaseDatabase.instance.reference().child('images');
  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> getImage(ImageSource media) async {
    final XFile? selectedImage = await picker.pickImage(source: media);

    if (selectedImage != null) {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final Reference storageReference = storage.ref().child(fileName);

      await storageReference.putFile(File(selectedImage.path));

      final String imageUrl = await storageReference.getDownloadURL();

      setState(() {
        _getImagesUrls();
      });

      database.push().set(imageUrl);

      print('Image URL: $imageUrl');
    }
  }

  Future<void> _getImagesUrls() async {
    ListResult result = await storage.ref().listAll();
    List<Reference> allImages = result.items;
    List<String> urls = await Future.wait(
      allImages.map(
        (Reference ref) async {
          String url = await ref.getDownloadURL();
          return url;
        },
      ),
    );
    setState(() {
      imageUrls = urls;
    });
  }

  Future<void> getImages() async {
    ListResult result = await storage.ref().listAll();
    List<Reference> allImages = result.items;
    List<String> urls = await Future.wait(
      allImages.map(
        (Reference ref) async {
          String url = await ref.getDownloadURL();
          return url;
        },
      ),
    );
    setState(() {
      imageUrls = urls;
    });
  }

  Future<void> deleteImage(int index) async {
    // Get the reference to the image's storage location using its URL
    Reference storageReference =
        FirebaseStorage.instance.refFromURL(imageUrls[index]);

    // Delete the image from Firebase Storage
    await storageReference.delete();

    // Remove the image's URL from the list of image URLs
    setState(() {
      imageUrls.removeAt(index);
    });
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    getImage(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getImagesUrls();
  }

// class _HomeState extends State<Home> {
//   List<XFile> images = [];

//   final ImagePicker picker = ImagePicker();

// final FirebaseStorage storage = FirebaseStorage.instance;

//   //we can upload image from camera or from gallery based on parameter
//   Future<void> getImage(ImageSource media) async {
//   final XFile? selectedImage = await picker.pickImage(source: media);

//   if (selectedImage != null) {
//     // setState(() {
//     //   image = selectedImage;
//     // });

//     // Generate a unique filename for the selected image
//     final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

//     // Reference to the Firebase Storage location where the image will be uploaded
//     final Reference storageReference = storage.ref().child(fileName);

//     // Upload the image to Firebase Storage
//      await storageReference.putFile(File(selectedImage.path));

//     // Get the URL of the uploaded image
//     final String imageUrl = await storageReference.getDownloadURL();

//     setState(() {
//         // Add the selected image to the list of images
//         images.add(selectedImage);
//       });

//     // Do something with the image URL, such as saving it to a database
//     print('Image URL: $imageUrl');
//   }
// }

  // //show popup dialog
  // void myAlert() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //           title: Text('Please choose media to select'),
  //           content: Container(
  //             height: MediaQuery.of(context).size.height / 6,
  //             child: Column(
  //               children: [
  //                 ElevatedButton(
  //                   //if user click this button, user can upload image from gallery
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     getImage(ImageSource.gallery);
  //                   },
  //                   child: Row(
  //                     children: [
  //                       Icon(Icons.image),
  //                       Text('From Gallery'),
  //                     ],
  //                   ),
  //                 ),
  //                 ElevatedButton(
  //                   //if user click this button. user can upload image from camera
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     getImage(ImageSource.camera);
  //                   },
  //                   child: Row(
  //                     children: [
  //                       Icon(Icons.camera),
  //                       Text('From Camera'),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(imageUrls.length, (index) {
          return Center(
            child: Stack(
              children: <Widget>[
                Image.network(imageUrls[index], fit: BoxFit.cover),
                Positioned(
                  right: 5,
                  top: 5,
                  child: GestureDetector(
                    onTap: () {
                      deleteImage(index);
                    },
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Image'),
//       ),
//       body: Center(
//         child: images.isEmpty
//             ? Text(
//                 'No Images',
//                 style: TextStyle(fontSize: 20),
//               )
//             : ListView.builder(
//                 itemCount: images.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Stack(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.file(
//                             File(images[index].path),
//                             fit: BoxFit.cover,
//                             width: MediaQuery.of(context).size.width,
//                             height: 200,
//                           ),
//                         ),
//                         Positioned(
//                           top: 0,
//                           right: 0,
//                           child: GestureDetector(
//                             onTap: () => deleteImage(index),
//                             child: Container(
//                               padding: EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.red,
//                               ),
//                               child: Icon(
//                                 Icons.delete,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showDialog();
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
