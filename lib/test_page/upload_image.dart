import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  List<XFile>? images;

  final ImagePicker picker = ImagePicker();

  // Upload image from camera or gallery based on the selected source
  Future<void> getImage(ImageSource source) async {
    var pickedImages = await picker.pickMultiImage();

    setState(() {
      images = pickedImages;
    });
  }

  // Show popup dialog
  void showMediaSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('Please choose media to select'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.image),
                      Text('From Gallery'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.camera),
                      Text('From Camera'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text('Upload image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.blueGrey,
              onPressed: showMediaSelectionDialog,
              child: const Text('Upload Photo'),
            ),
            const SizedBox(
              height: 10,
            ),
            if (images != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(images!.first.path),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                  ),
                ),
              )
            else
              const Text(
                "No Image",
                style: TextStyle(fontSize: 20),
              ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              color: Colors.blueGrey,
              onPressed: () async {
                if (images != null && images!.isNotEmpty) {
                  await Share.shareFiles(
                    images!.map((image) => image.path).toList(),
                    text: 'This is from my test app',
                  );
                }
              },
              child: const Text(
                'Share',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// link youtube to share data 
//   https://www.youtube.com/watch?v=CNUBhb_cM6E