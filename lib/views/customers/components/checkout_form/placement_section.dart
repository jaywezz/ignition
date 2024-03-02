import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soko_flow/data/providers/customer_provider.dart';
import 'package:soko_flow/views/customers/components/checkout_form/checkout_form_screen.dart';
import 'package:soko_flow/widgets/inputs/form_drop_down_widget.dart';

class PlacementSection extends ConsumerStatefulWidget {
  const PlacementSection({Key? key}) : super(key: key);

  @override
  ConsumerState<PlacementSection> createState() => _PlacementSectionState();
}

class _PlacementSectionState extends ConsumerState<PlacementSection> {
  File? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        ref.watch(checkoutFormDataProvider).image =  File(pickedFile.path);
        // _imageFile = File(pickedFile.path);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FormDropDownField(
              title: "Update the very next step for this customer",
              onChanged: (value) {
                ref.watch(checkoutFormDataProvider).veryNextStep = value;
              },
              value: "Schedule another Visit",
              itemsLists: const [
                "Schedule another Visit",
                "Schedule an order",
                "Push for order",
                "Mark as Cold."
              ]
          ),

          SizedBox(height: 20,),

          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child:ref.watch(checkoutFormDataProvider).image != null
                  ? Image.file(
                ref.watch(checkoutFormDataProvider).image!,
                fit: BoxFit.cover,
              )
                  : Icon(
                Icons.photo,
                size: 60,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 10),
          ref.watch(checkoutFormDataProvider).image != null
              ? Text('Tap the image to change it.')
              : Text('Tap to take a photo.'),
        ],
      ),
    );
  }
}
