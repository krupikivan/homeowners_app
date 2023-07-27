import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeowners_app/models/data_model.dart';
import 'package:homeowners_app/models/home_buyer.dart';
import 'package:http/http.dart' as http;

import '../models/neighborhood.dart';
import '../models/result.dart';

final dataService = Provider<_DataService>((ref) {
  const service = _DataService();
  return service;
});

class _DataService {
  const _DataService();

  Future<List<Result>> execute() async {
    try {
      var body = {
        'input_file': 'assets/input.txt',
      };
      final url = dotenv.env['BASE_URL'];
      final response = await http.post(
        Uri.parse('http://$url:8080/execute'),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(response.body);
      return (data['data'] as Map)
          .entries
          .map((e) => Result.fromJson(e))
          .toList();
    } catch (e) {
      throw 'Error executing data';
    }
  }

  Future<List<DataModel>> loadFile() async {
    try {
      final res = await rootBundle.loadString('assets/input.txt');
      final data = res.split('\n');
      return data.map((e) {
        if (e[0] == 'N') {
          return Neighborhood.fromJson(e.split(' '));
        } else {
          return HomeBuyer.fromJson(e.split(' '));
        }
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
