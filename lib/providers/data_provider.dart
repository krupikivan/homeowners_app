import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/data_model.dart';
import '../models/result.dart';
import '../services/data_service.dart';
import '../utils/enum.dart';

final statusProvider = StateProvider<Status>((ref) => Status.none);

final executeProvider = StreamProvider<List<Result>>((ref) async* {
  try {
    ref.read(statusProvider.notifier).state = Status.running;
    final data = await ref.watch(dataService).execute();
    ref.read(statusProvider.notifier).state = Status.finished;
    yield data;
  } catch (e) {
    ref.read(statusProvider.notifier).state = Status.error;
    yield [];
  }
});

final dataProvider = FutureProvider<List<DataModel>>((ref) async {
  try {
    final data = await ref.watch(dataService).loadFile();
    return data;
  } catch (e) {
    return [];
  }
});

final homeBuyersProvider = StreamProvider<List<DataModel>>((ref) async* {
  try {
    final data = await ref.read(dataProvider.future);
    yield data.where((e) => e.name[0] == 'H').toList();
  } catch (e) {
    yield [];
  }
});

final neighborhoodProvider = StreamProvider<List<DataModel>>((ref) async* {
  try {
    final data = await ref.read(dataProvider.future);
    yield data.where((e) => e.name[0] == 'N').toList();
  } catch (e) {
    yield [];
  }
});
