class Result {
  final String neightborhood;
  final List<String> data;

  Result({
    required this.neightborhood,
    required this.data,
  });

  factory Result.fromJson(MapEntry json) => Result(
        neightborhood: json.key,
        data: (json.value as List).map((e) => e.toString()).toList(),
      );

  static int parseValue(String value) {
    final parts = value.split(':');
    return int.parse(parts[1]);
  }
}
