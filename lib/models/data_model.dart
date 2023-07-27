abstract class DataModel {
  final String name;
  final int energyEfficiency;
  final int water;
  final int resilience;

  DataModel({
    required this.name,
    required this.energyEfficiency,
    required this.water,
    required this.resilience,
  });
}
