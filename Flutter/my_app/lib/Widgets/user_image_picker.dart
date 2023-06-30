import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickerImage});

  final void Function(File pickedImage) onPickerImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickerImageFile;

  void _imagePicker() async {
    print('_imagePicker');
    final pickerImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (pickerImage == null) {
      return;
    }

    setState(() {
      _pickerImageFile = File(pickerImage.path);
    });

    widget.onPickerImage(_pickerImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.amberAccent,
          foregroundImage:
              _pickerImageFile != null ? FileImage(_pickerImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _imagePicker,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
