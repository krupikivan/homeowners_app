import 'data_model.dart';

class Neighborhood extends DataModel {
  Neighborhood({
    required String name,
    required int energyEfficiency,
    required int water,
    required int resilience,
  }) : super(
          name: name,
          energyEfficiency: energyEfficiency,
          water: water,
          resilience: resilience,
        );

// N N0 E:7 W:7 R:10
  factory Neighborhood.fromJson(List<String> json) {
    final name = json[1];
    final energyEfficiency = parseValue(json[2]);
    final water = parseValue(json[3]);
    final resilience = parseValue(json[4]);

    return Neighborhood(
      name: name,
      energyEfficiency: energyEfficiency,
      water: water,
      resilience: resilience,
    );
  }

  static int parseValue(String value) {
    final parts = value.split(':');
    return int.parse(parts[1]);
  }
}
