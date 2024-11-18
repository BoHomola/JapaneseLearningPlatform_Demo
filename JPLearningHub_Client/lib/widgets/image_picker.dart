import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jplearninghub/api/api_facade.dart';
import 'package:jplearninghub/utils/logger.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});

  @override
  ImageUploadPageState createState() => ImageUploadPageState();
}

class ImageUploadPageState extends State<ImageUploadPage> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> uploadImage() async {
    if (_image == null) {
      return;
    }

    var response = await apiFacade.sendFile("avatar", _image!, (progress) {
      double percent = progress.sent / progress.total;
      logger.d('Upload progress: ${percent.toStringAsFixed(2)}');
    });
    if (response.statusCode == 200) {
      logger.d('Upload successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image == null
              ? const Text('No image selected.')
              : Image.file(_image!),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: getImage,
            child: const Text('Select Image'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _image == null ? null : uploadImage,
            child: const Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
