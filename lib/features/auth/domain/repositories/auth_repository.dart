import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> signup({
    required String fullName,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? upiId,
  });
  Stream<UserEntity?> authStateChanges();
  bool get isAuthenticated;
}
