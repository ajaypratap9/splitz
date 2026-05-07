import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _repository;

  const SignupUseCase(this._repository);

  Future<UserEntity> call({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (fullName.isEmpty) throw ArgumentError('Name cannot be empty');
    if (email.isEmpty) throw ArgumentError('Email cannot be empty');
    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }
    return _repository.signup(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}
