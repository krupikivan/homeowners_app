import 'package:flutter/material.dart';

import '../models/data_model.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.data,
  });
  final DataModel data;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data.name),
      subtitle: Text(
        'E: ${data.energyEfficiency} W: ${data.water} R: ${data.resilience}',
      ),
    );
  }
}
