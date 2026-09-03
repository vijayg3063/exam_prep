import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'mock_data.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> loginWithEmail(String email, String password);
  Future<UserModel> register(String fullName, String email, String phone, String password);
  Future<UserModel> loginWithGoogle();
  Future<void> updateTargetExam(String examTitle);
  Future<void> updateLanguage(String language);
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser = MockData.initialUser;

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<UserModel> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = MockData.initialUser.copyWith(email: email);
    return _currentUser!;
  }

  @override
  Future<UserModel> register(String fullName, String email, String phone, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phone: phone,
      targetExam: 'SSC CGL',
      preferredLanguage: 'Bilingual (Hinglish)',
      joinedDate: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = MockData.initialUser;
    return _currentUser!;
  }

  @override
  Future<void> updateTargetExam(String examTitle) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(targetExam: examTitle);
    }
  }

  @override
  Future<void> updateLanguage(String language) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(preferredLanguage: language);
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = null;
  }
}

// Riverpod Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _repo;

  // Start with initialUser immediately so HomeView has data right away.
  // Do NOT call checkAuthStatus() here — it would overwrite the initial
  // data with AsyncValue.loading(), causing a blank header on every build.
  AuthNotifier(this._repo) : super(AsyncValue.data(MockData.initialUser));

  Future<void> checkAuthStatus() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.loginWithEmail(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.loginWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String fullName, String email, String phone, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.register(fullName, email, phone, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTargetExam(String exam) async {
    await _repo.updateTargetExam(exam);
    if (state.value != null) {
      state = AsyncValue.data(state.value!.copyWith(targetExam: exam));
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
