import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/live_class_model.dart';
import 'mock_data.dart';

abstract class LiveRepository {
  Future<List<LiveClassModel>> getLiveClasses();
  Future<List<LiveClassModel>> getUpcomingClasses();
  Future<List<LiveClassModel>> getDoubtSessions();
  Future<void> toggleReminder(String liveId);
}

class MockLiveRepository implements LiveRepository {
  final List<LiveClassModel> _liveClasses = List.from(MockData.liveClasses);

  @override
  Future<List<LiveClassModel>> getLiveClasses() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _liveClasses;
  }

  @override
  Future<List<LiveClassModel>> getUpcomingClasses() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _liveClasses.where((l) => l.isUpcoming && l.type == LiveType.liveClass).toList();
  }

  @override
  Future<List<LiveClassModel>> getDoubtSessions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _liveClasses.where((l) => l.type == LiveType.doubtSession).toList();
  }

  @override
  Future<void> toggleReminder(String liveId) async {
    final idx = _liveClasses.indexWhere((l) => l.id == liveId);
    if (idx != -1) {
      _liveClasses[idx] = _liveClasses[idx].copyWith(
        reminderSet: !_liveClasses[idx].reminderSet,
      );
    }
  }
}

final liveRepositoryProvider = Provider<LiveRepository>((ref) {
  return MockLiveRepository();
});

final liveClassesProvider = FutureProvider<List<LiveClassModel>>((ref) {
  return ref.watch(liveRepositoryProvider).getLiveClasses();
});
