import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/config/supabase_config.dart';
import '../../../../core/errors/app_exception.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const AuthException(message: 'Login failed. Please try again.');
      }

      final profile = await _fetchProfile(response.user!.id);
      return profile;
    } on AuthApiException catch (e) {
      throw AuthException(message: e.message, code: e.statusCode?.toString());
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  Future<UserModel> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user == null) {
        throw const AuthException(message: 'Signup failed. Please try again.');
      }

      // Wait a moment for the trigger to create the profile
      await Future.delayed(const Duration(milliseconds: 500));

      // Try to fetch the profile, or create it if the trigger hasn't run yet
      try {
        final profile = await _fetchProfile(response.user!.id);
        return profile;
      } catch (_) {
        // Profile might not exist yet if trigger is slow, create manually
        await _client.from('profiles').upsert({
          'id': response.user!.id,
          'full_name': fullName,
        });
        return UserModel(
          id: response.user!.id,
          fullName: fullName,
          email: email,
        );
      }
    } on AuthApiException catch (e) {
      throw AuthException(message: e.message, code: e.statusCode?.toString());
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;
      return await _fetchProfile(user.id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? upiId,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (phone != null) updates['phone'] = phone;
      if (upiId != null) updates['upi_id'] = upiId;

      if (updates.isNotEmpty) {
        await _client.from('profiles').update(updates).eq('id', userId);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<void> updateFcmToken(String userId, String token) async {
    try {
      await _client
          .from('profiles')
          .update({'fcm_token': token}).eq('id', userId);
    } catch (e) {
      // Non-critical, don't throw
    }
  }

  Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }

  bool get isAuthenticated => _client.auth.currentUser != null;
  String? get currentUserId => _client.auth.currentUser?.id;

  Future<UserModel> _fetchProfile(String userId) async {
    final data =
        await _client.from('profiles').select().eq('id', userId).single();
    return UserModel.fromJson(data);
  }
}
