import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _dataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    return await _dataSource.login(email: email, password: password);
  }

  @override
  Future<UserEntity> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    return await _dataSource.signup(
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    await _dataSource.logout();
  }

  @override
  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? upiId,
  }) async {
    final userId = _dataSource.currentUserId;
    if (userId == null) throw Exception('Not authenticated');
    await _dataSource.updateProfile(
      userId: userId,
      fullName: fullName,
      avatarUrl: avatarUrl,
      phone: phone,
      upiId: upiId,
    );
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _dataSource.authStateChanges().asyncMap((event) async {
      if (event.session != null) {
        try {
          return await _dataSource.getCurrentUser();
        } catch (_) {
          return null;
        }
      }
      return null;
    });
  }

  @override
  bool get isAuthenticated => _dataSource.isAuthenticated;
}
