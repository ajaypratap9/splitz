import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../../core/config/supabase_config.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Data source provider
final authDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authDataSourceProvider));
});

// Auth state stream provider
final authStateProvider = StreamProvider<supa.AuthState>((ref) {
  return SupabaseConfig.client.auth.onAuthStateChange;
});

// Current user provider
final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) async {
      if (state.session != null) {
        final repo = ref.read(authRepositoryProvider);
        return await repo.getCurrentUser();
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// User profile provider (fetches profile for the current user)
final userProfileProvider = FutureProvider<UserEntity?>((ref) async {
  final user = SupabaseConfig.client.auth.currentUser;
  if (user == null) return null;

  final data = await SupabaseConfig.client
      .from('profiles')
      .select()
      .eq('id', user.id)
      .single();
  return UserEntity(
    id: data['id'] as String,
    fullName: data['full_name'] as String? ?? 'User',
    email: user.email,
    avatarUrl: data['avatar_url'] as String?,
    phone: data['phone'] as String?,
    upiId: data['upi_id'] as String?,
    createdAt: data['created_at'] != null
        ? DateTime.parse(data['created_at'] as String)
        : null,
    updatedAt: data['updated_at'] != null
        ? DateTime.parse(data['updated_at'] as String)
        : null,
  );
});

// Auth notifier for login/signup/logout actions
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider), ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.login(email: email, password: password);
      state = AsyncValue.data(user);
      _ref.invalidate(userProfileProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signup(
        fullName: fullName,
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
      _ref.invalidate(userProfileProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? upiId,
  }) async {
    try {
      await _repository.updateProfile(
        fullName: fullName,
        avatarUrl: avatarUrl,
        phone: phone,
        upiId: upiId,
      );
      _ref.invalidate(userProfileProvider);
    } catch (e) {
      // Handle error
    }
  }
}
