// Custom card view
import 'package:flutter/material.dart';

import '../ui_blocks/item_model.dart';

class CustomCardView extends StatelessWidget {
  final Item item;

  const CustomCardView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(item.title),
      ),
    );
  }
}
