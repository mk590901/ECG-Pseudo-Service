// Custom card view
import 'package:flutter/material.dart';

import '../ui_blocks/item_model.dart';
import '../widget/graph_widget.dart';

class CardView extends StatelessWidget {
  final Item item;

  //final GraphWidget graphWidget;

  const CardView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(Icons.info_outline, color: Colors.lightBlue),
            title: Text(item.title),
            subtitle: Text(
              item.subtitle,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
    );
  }
}
