import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback selectImageFromGallery, selectImageFromCamera;

  CustomAlertDialog({
    required this.selectImageFromCamera,
    required this.selectImageFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text(
        'Select image from',
      ),
      content: Container(
        height: 60,
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: selectImageFromGallery,
                  icon: const Icon(Icons.image),
                  label: const Text('Gallery'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: selectImageFromCamera,
                  icon: const Icon(Icons.camera),
                  label: const Text('Camera'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
