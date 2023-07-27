import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/data_model.dart';
import 'item_tile.dart';

class ColumnTile extends StatelessWidget {
  const ColumnTile({
    super.key,
    required this.title,
    required this.asyncData,
  });
  final String title;
  final AsyncValue<List<DataModel>> asyncData;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: asyncData.when(
              data: (data) => ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ItemTile(
                    data: data[index],
                  );
                },
              ),
              error: (e, s) => const Center(
                child: Text(
                  'Error loading data',
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
