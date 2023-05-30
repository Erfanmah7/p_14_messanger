import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

final kMyInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
);

const String kMyPhoneNumber = '+11111111111';

List<MultiSelectItem> Categories = [
  MultiSelectItem('Clothing', 'Clothing'),
  MultiSelectItem('Foods', 'Foods'),
  MultiSelectItem('Kitchen appliances', 'Kitchen appliances'),
  MultiSelectItem('Books', 'Books'),
];
