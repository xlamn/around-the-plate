import 'dart:io';

import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';

class DishDetailsPage extends StatelessWidget {
  final Dish dish;

  const DishDetailsPage({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.file(File(dish.imagePath)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Text(dish.name),
          SizedBox(
            height: 64,
          ),
          Text(
            '${dish.rating * 10}/10',
          ),
          SizedBox(
            height: 64,
          ),

          if (dish.origin != null) Text(dish.origin!),
          if (dish.category != null) Text(dish.category!.name),

          Text('some more text generated with GPT'),

          SizedBox(
            height: 64,
          ),

          if (dish.date != null) Text('${dish.date}'),

          SizedBox(
            height: 64,
          ),

          if (dish.location != null) Text('${dish.location?.placeName}'),

          SizedBox(
            height: 64,
          ),

          Text('${dish.lastModifiedDate}'),
        ],
      ),
    );
  }
}
