import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserIamgePicker extends StatefulWidget {
  const UserIamgePicker(this.imagePickFn, {Key? key}) : super(key: key);

  final void Function(XFile pickedImage) imagePickFn;

  @override
  _UserIamgePickerState createState() => _UserIamgePickerState();
}

class _UserIamgePickerState extends State<UserIamgePicker> {
  XFile? _pickedImage;
  void _pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 200,
    );

    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.background,
          radius: 60,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            radius: 59,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.background,
              radius: 53,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                radius: 52,
                child: CircleAvatar(
                  backgroundImage: _pickedImage != null
                      ? FileImage(File(_pickedImage!.path))
                      : null,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  radius: 46,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -2.5,
          child: CircleAvatar(
            radius: 17,
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              child: IconButton(
                iconSize: 22,
                //alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 2),
                tooltip: 'Upload your photo',
                icon: const Icon(Icons.camera_alt_rounded),
                onPressed: _pickImage,
              ),
            ),
          ),
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
