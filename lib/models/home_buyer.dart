import 'data_model.dart';

class HomeBuyer extends DataModel {
  final List<String> neighborhoodPreferences;

  HomeBuyer({
    required String name,
    required int energyEfficiency,
    required int water,
    required int resilience,
    required this.neighborhoodPreferences,
  }) : super(
          name: name,
          energyEfficiency: energyEfficiency,
          water: water,
          resilience: resilience,
        );

  factory HomeBuyer.fromJson(List<String> json) {
    final name = json[1];
    final energyEfficiency = parseValue(json[2]);
    final water = parseValue(json[3]);
    final resilience = parseValue(json[4]);
    final preferences = json[5].split('>');

    return HomeBuyer(
      name: name,
      energyEfficiency: energyEfficiency,
      water: water,
      resilience: resilience,
      neighborhoodPreferences: preferences,
    );
  }

  static int parseValue(String value) {
    final parts = value.split(':');
    return int.parse(parts[1]);
  }
}
