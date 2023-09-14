import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image selected');
}

// for displaying snackbars
void showSnackBar(BuildContext context, String text) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  });
}
